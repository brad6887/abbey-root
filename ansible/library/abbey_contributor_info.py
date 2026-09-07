#!/usr/bin/python
"""Read-only account inspection; password material never leaves the target."""

DOCUMENTATION = r"""
---
module: abbey_contributor_info
short_description: Inspect Abbey contributor account policy and drift
description: Reads account metadata and Abbey-owned access files without changes.
options:
  username:
    type: str
    required: true
  desired_state:
    type: str
    choices: [active, revoked, absent]
    required: true
  public_key:
    type: str
    default: ''
  groups:
    type: list
    elements: str
    default: []
  sudo:
    type: str
    choices: [none, full]
    default: none
supports_check_mode: true
"""

import grp
import os
from pathlib import Path
import pwd
import re
import stat


def sudo_content(username):
    return f"# Managed by Abbey contributor\n{username} ALL=(ALL:ALL) PASSWD: ALL\n"


def key_content(key):
    return f"# Managed by Abbey contributor\n{key}\n"


def inspect_account(username, desired_state, public_key="", groups=None, sudo="none"):
    if not re.fullmatch(r"[a-z_][a-z0-9_-]{0,30}", username) or username in {
        "root", "bcooke", "bradcooke", "nobody", "ansible", "abbey-deploy"
    }:
        raise ValueError("Refusing a reserved or invalid contributor username.")
    expected_home = f"/home/{username}"
    try:
        account = pwd.getpwnam(username)
    except KeyError:
        account = None
    managed = bool(account and account.pw_uid >= 1000 and
                   account.pw_gecos == f"Abbey contributor {username}")
    home = Path(expected_home)
    ssh = home / ".ssh"
    keys = ssh / "authorized_keys"
    sudo_file = Path(f"/etc/sudoers.d/abbey-{username}")
    problems = []
    # Fail closed on links/nonstandard paths before reading or managing their contents.
    for path, directory in ((Path("/home"), True), (home, True), (ssh, True),
                            (keys, False), (Path("/etc/sudoers.d"), True), (sudo_file, False)):
        if path.is_symlink():
            problems.append(f"Symbolic link is not managed: {path}")
        elif path.exists() and not (path.is_dir() if directory else path.is_file()):
            problems.append(f"Unexpected file type: {path}")
    if problems:
        return dict(exists=bool(account), managed=managed, safe=False, problems=problems,
                    drift=problems, summary="UNSAFE paths; no changes allowed")
    if account and not managed:
        problems.append("Existing account is not an Abbey-managed non-system contributor.")
    if account and account.pw_dir != expected_home:
        problems.append("Existing home differs from /home/<username>.")
    if not account and (keys.exists() or sudo_file.exists()):
        problems.append("Access files exist without a managed account; inspect retained data manually.")
    if not account and home.exists() and desired_state == "active":
        problems.append("Home already exists without an account; archive/recover it explicitly before recreating.")
    password_locked, password_usable, password_empty, expires = False, False, False, ""
    if account:
        with open("/etc/shadow", encoding="utf-8") as handle:
            shadow = next((line.rstrip("\n").split(":") for line in handle
                           if line.split(":", 1)[0] == username), None)
        if shadow is None:
            problems.append("Local shadow entry is missing; external accounts are not supported.")
        else:
            secret = shadow[1]
            password_locked = secret.startswith("!")
            password_usable = secret.lstrip("!").startswith("$")
            password_empty = secret.lstrip("!") == ""
            expires = shadow[7]
            if password_empty and desired_state == "active":
                problems.append("Empty password would be unsafe to unlock; set a password or disable it first.")
    try:
        primary = grp.getgrgid(account.pw_gid).gr_name if account else ""
    except KeyError:
        primary = ""
    if account and primary != username:
        problems.append("Primary group is not the contributor's own group.")
    all_groups = grp.getgrall()
    supplementary = sorted(g.gr_name for g in all_groups
                           if username in g.gr_mem and (not account or g.gr_gid != account.pw_gid))
    desired_groups = sorted(groups or []) if desired_state == "active" else []
    desired_sudo = sudo if desired_state == "active" else "none"
    if desired_state == "active":
        existing_groups = {g.gr_name for g in all_groups}
        missing = set(desired_groups) - existing_groups
        if missing:
            problems.append("Approved groups do not exist: " + ", ".join(sorted(missing)))
        if not account and username in existing_groups:
            candidate = grp.getgrnam(username)
            if candidate.gr_gid < 1000 or candidate.gr_mem or any(
                user.pw_gid == candidate.gr_gid for user in pwd.getpwall()
            ):
                problems.append("Existing primary group is not an empty, unassigned non-system group.")
        if desired_sudo == "full" and not password_usable:
            problems.append("Full sudo requires a local password: apply sudo=none, run sudo passwd <username>, then grant full.")
    key_text = keys.read_text(encoding="utf-8") if keys.is_file() else ""
    sudo_text = sudo_file.read_text(encoding="utf-8") if sudo_file.is_file() else ""
    key_lines = [line for line in key_text.splitlines() if line.strip() and not line.lstrip().startswith("#")]
    key_ok = key_text == key_content(public_key)

    def correct_mode(path, mode, uid, gid):
        if not path.exists():
            return False
        info = path.stat()
        return stat.S_IMODE(info.st_mode) == mode and info.st_uid == uid and info.st_gid == gid

    drift = []
    if desired_state == "active":
        if not account:
            drift.append("create account and private primary group")
        else:
            if account.pw_shell != "/bin/bash" or expires not in {"", "-1"} or password_locked:
                drift.append("restore shell, account expiry and password lock")
            if supplementary != desired_groups:
                drift.append("replace supplementary groups")
            if not correct_mode(home, 0o750, account.pw_uid, account.pw_gid):
                drift.append("repair home owner/mode")
        if not key_ok or not account or not correct_mode(keys, 0o600, account.pw_uid, account.pw_gid) or not correct_mode(ssh, 0o700, account.pw_uid, account.pw_gid):
            drift.append("install exclusive ED25519 authorization and SSH permissions")
    elif account:
        if desired_state == "absent":
            drift.append("remove Unix account (home deletion only with --remove-home)")
        else:
            if account.pw_shell != "/usr/sbin/nologin" or expires != "1" or not password_locked:
                drift.append("lock and expire account; set nologin")
            if supplementary:
                drift.append("remove all supplementary groups")
    if desired_state != "active" and keys.exists():
        drift.append("remove SSH authorization")
    if desired_sudo == "full":
        if sudo_text != sudo_content(username) or not correct_mode(sudo_file, 0o440, 0, 0):
            drift.append("install password-required Abbey sudo policy")
    elif sudo_file.exists():
        drift.append("remove Abbey sudo policy")
    drift.extend(problem for problem in problems if problem not in drift)
    actual = "absent" if not account else (
        "revoked" if password_locked and expires == "1" and account.pw_shell == "/usr/sbin/nologin" else
        "active" if account.pw_shell == "/bin/bash" and expires in {"", "-1"} and not password_locked else "restricted"
    )
    if account and not managed:
        actual = "unmanaged"
    password_state = "locked" if password_locked else "set" if password_usable else "disabled"
    summary = (f"desired={desired_state} actual={actual} "
               f"ssh={'yes' if key_lines else 'no'} "
               f"abbey_sudo={'full' if sudo_text == sudo_content(username) else 'other' if sudo_text else 'none'} "
               f"password={password_state} groups={','.join(supplementary) or '(primary only)'} "
               f"drift={'yes' if drift else 'no'}")
    return dict(exists=bool(account), managed=managed, safe=not problems, problems=problems,
                drift=drift, summary=summary, actual_state=actual,
                password_usable=password_usable, password_locked=password_locked,
                ssh_authorized=bool(key_lines), groups=supplementary,
                home_exists=home.exists(), ssh_directory_exists=ssh.is_dir())


def main():
    from ansible.module_utils.basic import AnsibleModule
    module = AnsibleModule(argument_spec=dict(
        username=dict(type="str", required=True),
        desired_state=dict(type="str", required=True, choices=["active", "revoked", "absent"]),
        public_key=dict(type="str", default=""),
        groups=dict(type="list", elements="str", default=[]),
        sudo=dict(type="str", choices=["none", "full"], default="none"),
    ), supports_check_mode=True)
    try:
        result = inspect_account(**module.params)
    except (OSError, ValueError) as exc:
        module.fail_json(msg=f"Cannot inspect contributor safely: {exc}")
    module.exit_json(changed=False, **result)


if __name__ == "__main__":
    main()
