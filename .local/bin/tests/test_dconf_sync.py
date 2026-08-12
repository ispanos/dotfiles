from __future__ import annotations

import importlib.machinery
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


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

        dconf_sync.export_all(self.config, backend)

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

        dconf_sync.apply_all(self.config, backend)

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

        with self.assertRaises(dconf_sync.SyncError):
            dconf_sync.export_all(self.config, backend)

        self.assertEqual(first.read_text(encoding="utf-8"), "[/]\nvalue='old'\n")
        self.assertEqual(second.read_text(encoding="utf-8"), "[/]\nvalue='old'\n")


if __name__ == "__main__":
    unittest.main()
