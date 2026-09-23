from __future__ import annotations

import importlib.machinery
import importlib.util
import io
import sys
import tempfile
import unittest
from contextlib import redirect_stderr, redirect_stdout
from pathlib import Path
from unittest.mock import patch
import subprocess


SCRIPT = Path(__file__).parents[1] / "dconf_sync"
loader = importlib.machinery.SourceFileLoader("dconf_sync", str(SCRIPT))
spec = importlib.util.spec_from_loader(loader.name, loader)
assert spec is not None
dconf_sync = importlib.util.module_from_spec(spec)
sys.modules[loader.name] = dconf_sync
loader.exec_module(dconf_sync)


class FakeDconf:
    def __init__(self, values: dict[str, str | None] | None = None) -> None:
        self.values = values or {}
        self.writes: list[tuple[str, str]] = []

    def read(self, key: str) -> str | None:
        return self.values.get(key)

    def write(self, key: str, value: str) -> None:
        self.writes.append((key, value))


class DconfSyncTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.config = dconf_sync.Config(Path(self.temporary.name))
        self.config.settings_dir.mkdir(parents=True)
        self.config.extensions_dir.mkdir()

    def write(self, relative: str, content: str) -> Path:
        path = self.config.dconf_dir / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        return path

    def run_quietly(self, function, *arguments) -> None:
        with redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            function(*arguments)

    def test_base_paths(self) -> None:
        root = self.write("dconf.ini", "[org/example]\nkey=true\n")
        schema = self.write("dconf.d/org.gnome.Example", "[/]\nkey=true\n")
        extension = self.write("dconf.d/extensions/example", "[/]\nkey=true\n")

        self.assertEqual(self.config.base_path(root), "/")
        self.assertEqual(self.config.base_path(schema), "/org/gnome/Example/")
        self.assertEqual(
            self.config.base_path(extension),
            "/org/gnome/shell/extensions/example/",
        )

    def test_export_updates_only_existing_keys_and_preserves_formatting(self) -> None:
        path = self.write(
            "dconf.d/org.gnome.Example",
            "# retained\n[/]\nenabled=false\nname='old'\n",
        )
        backend = FakeDconf(
            {
                "/org/gnome/Example/enabled": "true",
                "/org/gnome/Example/unlisted": "'must not appear'",
            }
        )

        self.run_quietly(dconf_sync.export_all, self.config, backend)

        self.assertEqual(
            path.read_text(encoding="utf-8"),
            "# retained\n[/]\nenabled=true\nname='old'\n",
        )

    def test_nested_and_root_keys_are_applied_exactly(self) -> None:
        self.write("dconf.ini", "[desktop/example]\nroot-key=@as []\n")
        self.write(
            "dconf.d/org.gnome.Example",
            "[Profiles/abc]\npalette='Monokai'\n",
        )
        backend = FakeDconf()

        self.run_quietly(dconf_sync.apply_all, self.config, backend)

        self.assertIn(("/desktop/example/root-key", "@as []"), backend.writes)
        self.assertIn(
            ("/org/gnome/Example/Profiles/abc/palette", "'Monokai'"),
            backend.writes,
        )

    def test_private_export_is_rejected_before_any_file_changes(self) -> None:
        first = self.write("dconf.d/org.example.First", "[/]\nvalue='old'\n")
        second = self.write("dconf.d/org.example.Second", "[/]\nvalue='old'\n")
        backend = FakeDconf(
            {
                "/org/example/First/value": "'new'",
                "/org/example/Second/value": "'/home/alice/Documents'",
            }
        )

        with redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            with self.assertRaises(dconf_sync.SyncError):
                dconf_sync.export_all(self.config, backend)

        self.assertEqual(first.read_text(encoding="utf-8"), "[/]\nvalue='old'\n")
        self.assertEqual(second.read_text(encoding="utf-8"), "[/]\nvalue='old'\n")

    def shortcut_fixture(self, root: bool = False):
        prefix = dconf_sync.SHORTCUT_PREFIX
        header = "[org/gnome/settings-daemon/plugins/media-keys]" if root else "[/]"
        path = self.write(
            "dconf.ini" if root else "dconf.d/org.gnome.settings-daemon.plugins.media-keys",
            header + "\ncustom-keybindings=@as []\n",
        )
        backend = FakeDconf({
            dconf_sync.SHORTCUT_LIST: repr([prefix + "custom12/"]),
            prefix + "custom12/name": "'Raffi'",
            prefix + "custom12/command": "'raffi -u native'",
            prefix + "custom12/binding": "'<Super>d'",
            prefix + "custom99/command": "'not referenced'",
            prefix + "custom12/unrelated": "'do not capture'",
        })
        return path, backend

    def test_export_captures_only_referenced_shortcut_fields_and_is_idempotent(self):
        for root in (False, True):
            with self.subTest(root=root):
                path, backend = self.shortcut_fixture(root)
                self.run_quietly(dconf_sync.export_all, self.config, backend)
                text = path.read_text()
                settings = {s.full_key: s.value for s in dconf_sync.settings_in(text, self.config.base_path(path))}
                self.assertEqual(settings[dconf_sync.SHORTCUT_PREFIX + "custom12/command"], "'raffi -u native'")
                self.assertEqual(len(settings), 4)
                self.assertNotIn("unrelated", text)
                self.assertNotIn("custom99", text)
                self.run_quietly(dconf_sync.export_all, self.config, backend)
                self.assertEqual(text, path.read_text())
                path.unlink()

    def test_export_fills_existing_partial_section_without_duplicate_sections(self):
        path, backend = self.shortcut_fixture()
        path.write_text(path.read_text() + "\n[custom-keybindings/custom12]\nname='old'")
        self.run_quietly(dconf_sync.export_all, self.config, backend)
        text = path.read_text()
        self.assertEqual(text.count("[custom-keybindings/custom12]"), 1)
        self.assertIn("name='Raffi'", text)
        self.assertIn("command='raffi -u native'", text)

    def test_shortcut_audit_rejects_all_changes(self):
        path, backend = self.shortcut_fixture()
        original = path.read_text()
        backend.values[dconf_sync.SHORTCUT_PREFIX + "custom12/command"] = "'/home/alice/bin/run'"
        with redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            with self.assertRaises(dconf_sync.SyncError):
                dconf_sync.export_all(self.config, backend)
        self.assertEqual(path.read_text(), original)
        report = dconf_sync.compare(self.config, backend)
        self.assertTrue(any("Export blocked:" in warning for warning in report.warnings))

    def test_invalid_shortcut_paths_are_rejected_before_export(self):
        path, backend = self.shortcut_fixture()
        original = path.read_text()
        for value in ("['/org/unrelated/']", "__import__('os')", "[42]", "['" + dconf_sync.SHORTCUT_PREFIX + "../']"):
            backend.values[dconf_sync.SHORTCUT_LIST] = value
            with self.assertRaises(dconf_sync.SyncError):
                dconf_sync.export_all(self.config, backend)
            self.assertEqual(path.read_text(), original)

    def test_comparison_is_read_only_and_includes_new_and_unset(self):
        path, backend = self.shortcut_fixture()
        original = path.read_text()
        other = self.write("dconf.d/org.example.Test", "[/]\nsame=true\nmissing='keep'\nchanged=1\n")
        other_original = other.read_text()
        backend.values.update({"/org/example/Test/same": "true", "/org/example/Test/changed": "2"})
        report = dconf_sync.compare(self.config, backend)
        self.assertEqual(len(report.differences), 6)
        self.assertEqual(report.checked, 7)
        self.assertEqual(sum(d.status == "NEW" for d in report.differences), 3)
        unset = next(d for d in report.differences if d.status == "UNSET")
        self.assertIn("Export keeps", unset.effect)
        self.assertEqual(path.read_text(), original)
        self.assertEqual(other.read_text(), other_original)
        self.assertEqual(backend.writes, [])
        plain = dconf_sync.terminal_report(report, self.config, False)
        colored = dconf_sync.terminal_report(report, self.config, True)
        self.assertNotIn("\x1b[", plain)
        self.assertIn("\x1b[", colored)
        self.assertIn("UNSET", plain)

    def test_missing_new_fields_warn_and_removed_sections_are_retained(self):
        path, backend = self.shortcut_fixture()
        del backend.values[dconf_sync.SHORTCUT_PREFIX + "custom12/binding"]
        report = dconf_sync.compare(self.config, backend)
        self.assertTrue(any("cannot capture" in w for w in report.warnings))
        self.run_quietly(dconf_sync.export_all, self.config, backend)
        backend.values[dconf_sync.SHORTCUT_LIST] = "@as []"
        self.run_quietly(dconf_sync.export_all, self.config, backend)
        self.assertIn("[custom-keybindings/custom12]", path.read_text())
        self.assertIn("custom-keybindings=@as []", path.read_text())

    def test_html_escapes_values_and_terminal_neutralizes_escape_sequences(self):
        path = self.write("dconf.d/org.example.Test", "[/]\nvalue='old'\n")
        backend = FakeDconf({"/org/example/Test/value": "'<script>alert(1)</script>\x1b[31m'"})
        report = dconf_sync.compare(self.config, backend)
        rendered = dconf_sync.html_report(report, self.config)
        self.assertIn("&lt;script&gt;", rendered)
        self.assertNotIn("<script>", rendered)
        self.assertNotIn("\x1b", dconf_sync.terminal_report(report, self.config, False))

    def test_no_drift_and_unset_list(self):
        path, backend = self.shortcut_fixture()
        backend.values = {dconf_sync.SHORTCUT_LIST: "@as []"}
        report = dconf_sync.compare(self.config, backend)
        self.assertFalse(report.differences)
        self.assertIn("No drift", dconf_sync.terminal_report(report, self.config, False))
        original = path.read_text()
        backend.values = {}
        self.run_quietly(dconf_sync.export_all, self.config, backend)
        self.assertEqual(path.read_text(), original)

    def test_config_uses_separate_directory(self) -> None:
        self.assertEqual(self.config.dconf_dir, self.config.config_home / "dconf_sync")

    def test_saved_report_contains_all_managed_values_without_live_reads(self) -> None:
        self.write("dconf.ini", "[org/example]\nroot=true\n")
        self.write("dconf.d/org.example.Test", "[/]\nname='<script>test</script>'\n")
        self.write("dconf.d/extensions/example", "[/]\nenabled=false\n")
        with patch.object(dconf_sync.CommandDconf, "_run", side_effect=AssertionError("live read")):
            rendered = dconf_sync.saved_html(self.config)
        self.assertIn("3 saved keys", rendered)
        for key in ("/org/example/root", "/org/example/Test/name", "/org/gnome/shell/extensions/example/enabled"):
            self.assertIn(key, rendered)
        self.assertIn("&lt;script&gt;test&lt;/script&gt;", rendered)
        self.assertNotIn("<script>", rendered)

    def test_html_opens_private_file_and_preserves_it_if_opener_fails(self) -> None:
        for failure in (False, True):
            output = io.StringIO()
            with patch.object(dconf_sync.subprocess, "run") as run, redirect_stdout(output):
                if failure:
                    run.side_effect = subprocess.CalledProcessError(1, "xdg-open")
                    with self.assertRaisesRegex(dconf_sync.SyncError, "report saved"):
                        dconf_sync.open_html("<html>test</html>", "dconf-test-")
                else:
                    dconf_sync.open_html("<html>test</html>", "dconf-test-")
            path = Path(output.getvalue().strip())
            self.addCleanup(path.unlink, missing_ok=True)
            self.assertEqual(path.read_text(), "<html>test</html>")
            self.assertEqual(path.stat().st_mode & 0o777, 0o600)
            run.assert_called_once_with(["xdg-open", str(path)], check=True)


if __name__ == "__main__":
    unittest.main()
