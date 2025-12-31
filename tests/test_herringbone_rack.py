import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from PIL import Image


HERRINGBONE_RACK_SCAD_SNIPPET = """\
include <gears.scad>
modul = 1;
gear_teeth = 30;
width = 10;
rack_length = 80;
rack_height = 6;
helix_angle = 30;

distance = modul * gear_teeth / 2;

intersection(){
    rotate([0,180,0])
        translate([.2, -20, -10])
            herringbone_rack(modul=1, length=60, height=5, width=20, pressure_angle=20, helix_angle=30);
    translate([0, -4.5, -20/2])
        rotate([0,0,4])
            herringbone_gear (modul=1, tooth_number=gear_teeth, width=20, bore=4, pressure_angle=20, helix_angle=30, optimized=true);
}
"""


class HerringboneRackMeshTest(unittest.TestCase):
    """Regression test for https://github.com/chrisspen/gears/issues/16."""

    def setUp(self) -> None:
        if shutil.which("openscad-nightly") is None:
            self.skipTest("openscad-nightly is required for this test")

    def test_herringbone_rack_mesh_does_not_intersect(self) -> None:
        image = self._render_intersection()
        pixels = list(image.getdata())
        dark_pixels = sum(1 for pixel in pixels if pixel < 220)

        self.assertLess(
            dark_pixels,
            100,
            "Expected minimal intersection between herringbone rack and gear",
        )

    @staticmethod
    def _render_intersection() -> Image.Image:
        tests_dir = Path(__file__).resolve().parent
        repo_root = tests_dir.parent
        scad_source = repo_root / "gears.scad"

        with tempfile.TemporaryDirectory(dir=repo_root) as tmp_dir:
            tmp_path = Path(tmp_dir)
            scad_path = tmp_path / "herringbone_mesh.scad"
            png_path = tmp_path / ".." / ".cache" / "herringbone_mesh.png"

            scad_path.write_text(HERRINGBONE_RACK_SCAD_SNIPPET)
            shutil.copy(scad_source, tmp_path / "gears.scad")

            cmd = [
                "openscad-nightly",
                str(scad_path),
                "--viewall",
                "--projection",
                "ortho",
                "-o",
                str(png_path),
            ]
            try:
                subprocess.run(cmd, check=True, capture_output=True)
            except subprocess.CalledProcessError as exc:  # pragma: no cover - diagnostic aid
                raise AssertionError(
                    f"openscad-nightly failed with code {exc.returncode}\n"
                    f"stdout: {exc.stdout.decode()}\n"
                    f"stderr: {exc.stderr.decode()}"
                ) from exc

            image = Image.open(png_path).convert("L")
            return image.copy()


if __name__ == "__main__":
    unittest.main()
