#!/usr/bin/env python3
"""Destructive fixtures confined to a disposable, network-isolated Linux container."""

import copy
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

REPO = Path("/repo")
USER = "abbeytest"
HOME = Path("/home") / USER
TEMP = Path(tempfile.mkdtemp(prefix="abbey-contributor-"))
assert os.geteuid() == 0 and Path("/.dockerenv").exists(), "Run only through the disposable container test."
ENV = os.environ.copy()
config = TEMP / "ansible.cfg"
config.write_text("""[defaults]
roles_path = /repo/ansible/roles
library = /repo/ansible/library
retry_files_enabled = False
interpreter_python = /usr/bin/python3
""")
ENV["ANSIBLE_CONFIG"] = str(config)
inventory = TEMP / "inventory.yml"
inventory.write_text("""all:
  hosts:
    fixture:
      ansible_connection: local
      ansible_user: root
""")
subprocess.run(["ssh-keygen", "-q", "-t", "ed25519", "-N", "", "-f", str(TEMP / "key")], check=True)
KEY = " ".join((TEMP / "key.pub").read_text().split()[:2])
policy = {"login": True, "groups": [], "sudo": "none", "state": "active"}
spec = {"username": USER, "state": "active", "public_key": KEY, "access": {"fixture": policy}}
passed = 0


def check(condition, label):
    global passed
    assert condition, label
    passed += 1
    print(f"PASS {label}", flush=True)


def run(state="active", *, check_mode=False, sudo="none", groups=None, login=True,
        remove_home=False, confirmation=True, expect_failure=False, status=False, extra_host=False):
    data = copy.deepcopy(spec)
    data["state"] = state
    data["access"]["fixture"].update(
        state=state if login or state == "absent" else "revoked",
        sudo=sudo, groups=groups or [], login=login
    )
    if extra_host:
        data["access"]["blocked"] = dict(policy, groups=["missingfixturegroup"])
    variables = {
        "abbey_contributor": data,
        "abbey_contributor_targets": list(data["access"]),
        "abbey_contributor_remove_home": remove_home,
        "abbey_contributor_purge_confirm": USER if confirmation else "",
        "abbey_contributor_status_only": status,
    }
    varfile = TEMP / "vars.json"
    varfile.write_text(json.dumps(variables))
    command = ["ansible-playbook", "-i", str(inventory), str(REPO / "ansible/playbooks/contributor.yml"),
               "-e", f"@{varfile}"]
    if check_mode or status:
        command.append("--check")
    result = subprocess.run(command, env=ENV, text=True, capture_output=True)
    (TEMP / "latest.log").write_text(result.stdout + result.stderr)
    if bool(result.returncode) != expect_failure:
        print(result.stdout, result.stderr, flush=True)
        raise AssertionError(f"Unexpected playbook result ({result.returncode}); {state=}, {check_mode=}")
    return result.stdout


def snapshot():
    paths = [Path(p) for p in ("/etc/passwd", "/etc/shadow", "/etc/group", "/etc/gshadow",
                               f"/etc/sudoers.d/abbey-{USER}")]
    if HOME.exists():
        paths += [HOME] + sorted(HOME.rglob("*"))
    result = {}
    for path in paths:
        if path.exists():
            st = path.stat()
            result[str(path)] = (st.st_uid, st.st_gid, st.st_mode,
                                hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else "directory")
    return result


def exists():
    return subprocess.run(["id", USER], capture_output=True).returncode == 0


def ssh():
    return subprocess.run(
        ["ssh", "-p", "2222", "-i", str(TEMP / "key"), "-o", "IdentitiesOnly=yes",
         "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null",
         "-o", "BatchMode=yes", f"{USER}@127.0.0.1", "id -un"],
        text=True, capture_output=True
    )


sshd_config = TEMP / "sshd_config"
sshd_config.write_text(f"""Port 2222
ListenAddress 127.0.0.1
HostKey /etc/ssh/ssh_host_ed25519_key
PidFile {TEMP}/sshd.pid
UsePAM yes
PasswordAuthentication no
KbdInteractiveAuthentication no
StrictModes yes
LogLevel VERBOSE
""")
sshd = subprocess.Popen(["/usr/sbin/sshd", "-D", "-e", "-f", str(sshd_config)],
                        stdout=subprocess.DEVNULL, stderr=(TEMP / "sshd.log").open("w"))
try:
    before = snapshot()
    run(check_mode=True)
    check(snapshot() == before and not exists(), "plan predicts a new account without changing account databases or home")
    run(login=False)
    check(not exists(), "login=false does not create an account")
    run(sudo="full", expect_failure=True)
    check(not exists(), "full sudo fails before account creation without a local password")

    inventory.write_text(inventory.read_text() + "    blocked:\n      ansible_connection: local\n      ansible_user: root\n")
    run(extra_host=True, expect_failure=True)
    check(not exists(), "all-host preflight blocks every write when a later target has an invalid group")

    subprocess.run(["useradd", "-m", USER], check=True)
    before = snapshot()
    run(expect_failure=True)
    check(snapshot() == before, "unmanaged account adoption fails without modifying it")
    subprocess.run(["userdel", "-r", USER], check=True, capture_output=True)

    output = run()
    check(exists() and (HOME / ".ssh/authorized_keys").is_file(), "apply creates account, home, and public authorization")
    check(not Path(f"/etc/sudoers.d/abbey-{USER}").exists(), "default sudo creates no privilege grant")
    check("changed=0" in run(), "second apply is idempotent")
    auth = ssh()
    check(auth.returncode == 0 and auth.stdout.strip() == USER, "dedicated ED25519 key can log in with disabled password")
    (HOME / "keep.txt").write_text("preserved contributor work\n")
    preserved = (HOME / "keep.txt").read_bytes()

    # Simulate approved host group membership, then exercise exact replacement.
    subprocess.run(["groupadd", "fixturegroup"], check=True)
    run(groups=["fixturegroup"])
    check("fixturegroup" in subprocess.check_output(["id", "-nG", USER], text=True), "approved existing group is installed")
    before = snapshot()
    output = run(status=True)
    check(snapshot() == before and "drift=yes" in output, "status reports group drift without changing files")

    # Local password setup is deliberately outside Abbey; only a fixture password is used.
    subprocess.run(["chpasswd"], input=f"{USER}:AbbeyFixturePassword42!\n", text=True, check=True)
    run(sudo="full", groups=["fixturegroup"])
    subprocess.run(["visudo", "-cf", f"/etc/sudoers.d/abbey-{USER}"], check=True)
    denied = subprocess.run(["su", "-s", "/bin/sh", USER, "-c", "sudo -k; sudo -n true"],
                            capture_output=True)
    check(denied.returncode != 0, "full sudo does not allow passwordless execution")
    allowed = subprocess.run(["su", "-s", "/bin/sh", USER, "-c", "sudo -S -p '' id -u"],
                             input="AbbeyFixturePassword42!\n", text=True, capture_output=True)
    check(allowed.returncode == 0 and allowed.stdout.strip() == "0", "full sudo accepts the contributor's own password")
    check("changed=0" in run(sudo="full", groups=["fixturegroup"]), "full sudo apply is idempotent")

    before = snapshot()
    run("revoked", check_mode=True)
    check(snapshot() == before, "revoke check mode changes no account or access files")
    run("revoked")
    check(exists() and (HOME / "keep.txt").read_bytes() == preserved, "revoke preserves the account and contributor work")
    check(not (HOME / ".ssh/authorized_keys").exists() and not Path(f"/etc/sudoers.d/abbey-{USER}").exists(),
          "revoke removes public authorization and Abbey sudo")
    check(subprocess.check_output(["id", "-nG", USER], text=True).strip() == USER,
          "revoke removes every supplementary membership")
    check(ssh().returncode != 0, "revoked account cannot authenticate over SSH")
    check("changed=0" in run("revoked"), "second revoke is idempotent")

    run(sudo="full", groups=["fixturegroup"])
    check(ssh().returncode == 0 and (HOME / "keep.txt").read_bytes() == preserved,
          "apply restores the revoked account and retains work")
    output = run(status=True, sudo="full", groups=["fixturegroup"])
    check("drift=no" in output and "changed=0" in output, "status reports converged restored account")

    before = snapshot()
    run("absent", confirmation=False, expect_failure=True)
    check(snapshot() == before, "direct playbook purge refuses missing confirmation")
    run("absent", check_mode=True, remove_home=True)
    check(snapshot() == before, "destructive purge plan changes no files")
    run("absent")
    check(not exists() and (HOME / "keep.txt").read_bytes() == preserved, "purge preserves the home by default")
    check("changed=0" in run("absent"), "repeated preserving purge is idempotent")
    run(expect_failure=True)
    check(not exists() and (HOME / "keep.txt").read_bytes() == preserved, "recreation refuses to adopt an orphaned home")
    run("absent", remove_home=True, expect_failure=True)
    check((HOME / "keep.txt").read_bytes() == preserved, "remove-home refuses an already orphaned home")

    # Explicit fixture recovery; production workflow requires the administrator to archive/recover it.
    HOME.rename(TEMP / "archived-home")
    run()
    (HOME / "delete.txt").write_text("disposable fixture")
    run("absent", remove_home=True)
    check(not exists() and not HOME.exists(), "explicit remove-home purges the account and home")
    check((TEMP / "archived-home/keep.txt").read_bytes() == preserved, "explicit purge leaves archived data untouched")

    # A symlinked home must never become a root-owned write destination.
    HOME.symlink_to(TEMP / "archived-home", target_is_directory=True)
    run(expect_failure=True)
    check(not exists(), "symlinked home fails closed")
    HOME.unlink()
    print(f"Passed: {passed} isolated lifecycle assertions", flush=True)
finally:
    sshd.terminate()
    sshd.wait(timeout=10)
