import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from PIL import Image


RING_SCAD_SNIPPET = """\
include <gears.scad>
planetary_gear(modul=1, sun_teeth=30, planet_teeth=60, number_planets=3,
               width=5, rim_width=3, bore=3, pressure_angle=20);
"""


class RingGearClearanceTest(unittest.TestCase):
    """Regression test for https://github.com/chrisspen/gears/issues/8."""

    def setUp(self) -> None:
        if shutil.which("openscad-nightly") is None:
            self.skipTest("openscad-nightly is required for this test")

    def test_planetary_gear_gap_remains_clear(self) -> None:
        """
        Render the problematic planetary gear and ensure there is whitespace
        near the center row where the ring gear should clear the planets.
        """
        image = self._render_problematic_planetary_gear()
        row_index = 221
        column_radius = 15  # focus on center-ish region
        mid_col = image.width // 2
        sample_box = (mid_col - column_radius, row_index, mid_col + column_radius, row_index + 1)
        center_slice = image.crop(sample_box)
        max_pixel = max(center_slice.getdata())

        # Expect at least one almost-white pixel where the gap should be.
        # Current bug makes this remain dark, so this assertion fails.
        self.assertGreater(
            max_pixel,
            230,
            f"Expected bright pixels near row {row_index}, found max value {max_pixel}",
        )

    @staticmethod
    def _render_problematic_planetary_gear() -> Image.Image:
        tests_dir = Path(__file__).resolve().parent
        repo_root = tests_dir.parent
        scad_source = repo_root / "gears.scad"

        with tempfile.TemporaryDirectory(dir=repo_root) as tmp_dir:
            tmp_path = Path(tmp_dir)
            scad_path = tmp_path / "ring.scad"
            png_path = tmp_path / ".." / ".cache" / "ring.png"

            scad_path.write_text(RING_SCAD_SNIPPET)
            # Keep gears.scad next to the snippet to satisfy include <> lookup.
            shutil.copy(scad_source, tmp_path / "gears.scad")

            cmd = [
                "openscad-nightly",
                str(scad_path),
                "--camera",
                "74,0,0,0,0,0,55",
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

            artifact_png = tests_dir / "ring.png"
            shutil.copy(png_path, artifact_png)

            image = Image.open(png_path).convert("L")
            return image.copy()


if __name__ == "__main__":
    unittest.main()
