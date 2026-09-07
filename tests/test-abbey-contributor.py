#!/usr/bin/env python3
"""Offline CLI safety tests; no infrastructure or real account changes."""

import base64
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
import abbey_contributor as contributor

KEY = "ssh-ed25519 " + base64.b64encode(
    b"\x00\x00\x00\x0bssh-ed25519\x00\x00\x00\x20" + b"x" * 32
).decode()


class ContributorTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        directory = self.root / "ansible/contributors"
        (directory / "keys").mkdir(parents=True)
        (directory / "keys/testperson.pub").write_text(KEY + " fixture\n")
        self.path = directory / "testperson.yml"
        self.original = """# policy comment
username: testperson
state: active  # lifecycle
ssh_public_key: keys/testperson.pub
access:
  fixture:
    login: true
    groups: []
    sudo: none
  denied:
    login: false
"""
        self.path.write_text(self.original)

    def tearDown(self):
        self.temp.cleanup()

    def load(self, action=None):
        return contributor.load_definition(self.root, "testperson", action)

    def test_defaults_and_host_specific_access(self):
        spec = self.load()[3]
        self.assertEqual(spec["access"]["fixture"]["state"], "active")
        self.assertEqual(spec["access"]["denied"]["state"], "revoked")
        self.assertEqual(spec["access"]["denied"]["sudo"], "none")
        self.assertTrue(spec["fingerprint"].startswith("SHA256:"))
        self.assertEqual(spec["public_key"], KEY)

    def test_fingerprint_agrees_with_openssh(self):
        key = self.root / "ansible/contributors/keys/testperson.pub"
        output = subprocess.check_output(["ssh-keygen", "-lf", str(key)], text=True)
        self.assertIn(self.load()[3]["fingerprint"], output)

    def test_transitions_do_not_edit_definition_during_loading(self):
        self.assertEqual(self.load("revoke")[3]["state"], "revoked")
        self.assertEqual(self.load("purge")[3]["state"], "absent")
        self.assertEqual(self.path.read_text(), self.original)

    def test_duplicate_and_unknown_fields_fail_closed(self):
        for suffix in ("state: revoked\n", "password: secret\n", "profile: admin\n"):
            with self.subTest(suffix=suffix):
                self.path.write_text(self.original + suffix)
                with self.assertRaises(contributor.DefinitionError):
                    self.load()

    def test_invalid_entitlements_fail_closed(self):
        for old, new in (
            ("login: true", 'login: "yes"'),
            ("sudo: none", "sudo: NOPASSWD"),
            ("groups: []", "groups: [sudo]"),
            ("groups: []", "groups: [wheel]"),
            ("groups: []", "groups: [docker, docker]"),
            ("fixture:", "all:"),
            ("fixture:", "'fixture:*':"),
            ("state: active", "state: unknown"),
            ("username: testperson", "username: mismatch"),
        ):
            with self.subTest(new=new):
                self.path.write_text(self.original.replace(old, new))
                with self.assertRaises(contributor.DefinitionError):
                    self.load()

    def test_key_validation_and_path_escape(self):
        key = self.root / "ansible/contributors/keys/testperson.pub"
        for content in ("-----BEGIN OPENSSH PRIVATE KEY-----\nSECRET", KEY + "\n" + KEY,
                        "ssh-rsa AAAA", "ssh-ed25519 AAAA", "ssh-ed25519 !!!"):
            key.write_text(content)
            with self.assertRaises(contributor.DefinitionError):
                self.load()
        for reference in ("../private", "/tmp/key.pub", "keys/../../escape.pub", "keys/{{injected}}.pub"):
            self.path.write_text(self.original.replace("keys/testperson.pub", reference))
            with self.assertRaises(contributor.DefinitionError):
                self.load()

    def test_lost_key_does_not_block_revocation_or_purge(self):
        (self.root / "ansible/contributors/keys/testperson.pub").unlink()
        with self.assertRaises(contributor.DefinitionError):
            self.load()
        self.assertEqual(self.load("revoke")[3]["public_key"], "")
        self.assertEqual(self.load("purge")[3]["public_key"], "")

    def test_atomic_state_update_preserves_comments_and_rejects_concurrent_edit(self):
        contributor.save_state(self.path, self.original, "revoked")
        updated = self.path.read_text()
        self.assertEqual(updated, self.original.replace("state: active", "state: revoked"))
        with self.assertRaises(contributor.DefinitionError):
            contributor.save_state(self.path, self.original, "absent")
        # A no-op state transition must still detect an edited key/entitlement snapshot.
        with self.assertRaises(contributor.DefinitionError):
            contributor.save_state(self.path, self.original, "active")

    def test_reserved_and_invalid_names(self):
        for name in ("root", "bcooke", "../testperson", "a;whoami", "-x", "A", ""):
            with self.assertRaises(contributor.DefinitionError):
                contributor.load_definition(self.root, name)

    def invoke(self, argv, failure=False, known=None):
        calls = []
        def fake_run(command, **kwargs):
            if command[0] == "ansible-inventory":
                hosts = known if known is not None else ["fixture", "denied"]
                return subprocess.CompletedProcess(command, 0, json.dumps({
                    "all": {"hosts": hosts}, "_meta": {"hostvars": {}}
                }), "")
            variables = json.loads(Path(command[command.index("--extra-vars") + 1][1:]).read_text())
            calls.append((command, variables))
            return subprocess.CompletedProcess(command, 7 if failure and "--syntax-check" not in command else 0)
        args = contributor.parser().parse_args(argv)
        with patch.object(contributor.shutil, "which", return_value="/fixture/bin/tool"), patch.object(
            contributor.subprocess, "run", side_effect=fake_run
        ):
            code = contributor.run(args, self.root)
        return code, calls

    def test_plan_status_and_check_are_read_only(self):
        for argv in (["plan", "testperson"], ["plan", "testperson", "--action", "revoke"],
                     ["status", "testperson"], ["revoke", "testperson", "--check"],
                     ["purge", "testperson", "--confirm", "testperson", "--check"]):
            code, calls = self.invoke(argv)
            self.assertEqual(code, 0)
            self.assertTrue(all("--check" in cmd for cmd, _ in calls))
            self.assertEqual(self.path.read_text(), self.original)
            self.assertFalse((self.root / ".abbey").exists())

    def test_apply_uses_explicit_hosts_and_ssh_even_on_other_controller(self):
        code, calls = self.invoke(["apply", "testperson"])
        self.assertEqual(code, 0)
        variables = calls[-1][1]
        self.assertEqual(variables["abbey_contributor_targets"], ["denied", "fixture"])
        self.assertEqual(variables["ansible_connection"], "ssh")
        self.assertFalse(variables["abbey_contributor_remove_home"])

    def test_failed_run_keeps_intent_and_propagates_exit(self):
        code, _ = self.invoke(["revoke", "testperson"], failure=True)
        self.assertEqual(code, 7)
        self.assertIn("state: revoked", self.path.read_text())
        self.assertEqual(self.load()[3]["state"], "revoked")

    def test_purge_confirmation_and_deletion_flag(self):
        with self.assertRaises(contributor.DefinitionError):
            self.invoke(["purge", "testperson", "--confirm", "wrong"])
        with self.assertRaises(contributor.DefinitionError):
            self.invoke(["plan", "testperson", "--remove-home"])
        self.assertEqual(self.path.read_text(), self.original)
        _, calls = self.invoke(["purge", "testperson", "--confirm", "testperson", "--remove-home"])
        self.assertEqual(calls[-1][1]["abbey_contributor"]["state"], "absent")
        self.assertTrue(calls[-1][1]["abbey_contributor_remove_home"])

    def test_unknown_inventory_host_fails_before_saving_intent(self):
        with self.assertRaises(contributor.DefinitionError):
            self.invoke(["revoke", "testperson"], known=["fixture"])
        self.assertEqual(self.path.read_text(), self.original)

    def test_public_cli_help_and_invalid_arguments(self):
        for argv in ([], ["--help"], ["plan", "--help"], ["purge", "--help"]):
            run = subprocess.run([str(ROOT / "tools/bin/abbey"), "contributor", *argv],
                                 text=True, capture_output=True, cwd="/tmp")
            self.assertEqual(run.returncode, 0, run.stderr)
            self.assertIn("usage:", run.stdout)
        for argv in (["unknown"], ["apply"], ["purge", "testperson"],
                     ["status", "testperson", "--remove-home"]):
            run = subprocess.run([str(ROOT / "tools/bin/abbey"), "contributor", *argv],
                                 text=True, capture_output=True)
            self.assertNotEqual(run.returncode, 0)


if __name__ == "__main__":
    unittest.main()
