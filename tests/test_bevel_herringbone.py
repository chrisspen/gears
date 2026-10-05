import math
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


MODUL = 1
TOOTH_NUMBER = 30
PARTIAL_CONE_ANGLE = 45
TOOTH_WIDTH = 5

BEVEL_HERRINGBONE_SCAD_SNIPPET = f"""\
include <gears.scad>
bevel_herringbone_gear(modul={MODUL}, tooth_number={TOOTH_NUMBER}, partial_cone_angle={PARTIAL_CONE_ANGLE},
                       tooth_width={TOOTH_WIDTH}, bore=4, pressure_angle=20, helix_angle=30);
"""


class BevelHerringboneAlignmentTest(unittest.TestCase):
    """Regression test for https://github.com/chrisspen/gears/issues/29."""

    def setUp(self) -> None:
        if shutil.which("openscad-nightly") is None:
            self.skipTest("openscad-nightly is required for this test")

    def test_rings_share_cone_apex(self) -> None:
        """
        Both rings of the herringbone are built on spheres around the cone apex,
        so the teeth of the inner ring must end on the same sphere on which the
        teeth of the outer ring end. A misplaced inner ring pokes through it.
        """
        cone_angle = math.radians(PARTIAL_CONE_ANGLE)
        r_outside = MODUL * TOOTH_NUMBER / 2
        rg_outside = r_outside / math.sin(cone_angle)
        rf_outside = r_outside - (MODUL + MODUL / 6) * math.cos(cone_angle)
        delta_f = math.asin(rf_outside / rg_outside)
        height_f = rg_outside * math.cos(delta_f)
        rg_seam = rg_outside - TOOTH_WIDTH / 2

        overshoot = 0.0
        seam_vertices = 0
        for x, y, z in self._render_vertices():
            dz = height_f - z
            distance = math.sqrt(x * x + y * y + dz * dz)
            # Only look at the teeth, which lie above the root cone.
            if math.acos(dz / distance) < delta_f + math.radians(0.2):
                continue
            if abs(distance - rg_seam) < 0.05:
                seam_vertices += 1
                overshoot = max(overshoot, distance - rg_seam)

        self.assertGreater(seam_vertices, 0, "Expected tooth vertices where the two rings meet")
        self.assertLess(
            overshoot,
            1e-3,
            f"Inner ring is offset from the outer ring by {overshoot:.4f} where they meet",
        )

    @staticmethod
    def _render_vertices() -> set:
        tests_dir = Path(__file__).resolve().parent
        repo_root = tests_dir.parent
        scad_source = repo_root / "gears.scad"

        with tempfile.TemporaryDirectory(dir=repo_root) as tmp_dir:
            tmp_path = Path(tmp_dir)
            scad_path = tmp_path / "bevel_herringbone.scad"
            stl_path = tmp_path / "bevel_herringbone.stl"

            scad_path.write_text(BEVEL_HERRINGBONE_SCAD_SNIPPET)
            shutil.copy(scad_source, tmp_path / "gears.scad")

            cmd = [
                "openscad-nightly",
                str(scad_path),
                "--backend=manifold",
                "--export-format",
                "asciistl",
                "-o",
                str(stl_path),
            ]
            try:
                subprocess.run(cmd, check=True, capture_output=True)
            except subprocess.CalledProcessError as exc:  # pragma: no cover - diagnostic aid
                raise AssertionError(
                    f"openscad-nightly failed with code {exc.returncode}\n"
                    f"stdout: {exc.stdout.decode()}\n"
                    f"stderr: {exc.stderr.decode()}"
                ) from exc

            vertices = re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", stl_path.read_text())
            return {tuple(float(value) for value in vertex) for vertex in vertices}


if __name__ == "__main__":
    unittest.main()
