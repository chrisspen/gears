include <../gears.scad>

// Toggle to render the demo with per-gear colors for easier PNG lookup.
show_colors = true;

// Color palette by gear type (high-contrast, distinct).
COLOR_PLANETARY = [0.90, 0.15, 0.15];
COLOR_RACK = [0.10, 0.55, 0.95];
COLOR_MOUNTABLE_RACK = [0.10, 0.70, 0.55];
COLOR_HERRINGBONE_RACK = [0.80, 0.45, 0.10];
COLOR_SPUR = [0.60, 0.15, 0.75];
COLOR_RACK_AND_PINION = [0.90, 0.75, 0.10];
COLOR_BEVEL = [0.15, 0.75, 0.25];
COLOR_BEVEL_HERRINGBONE = [0.55, 0.45, 0.10];
COLOR_WORM = [0.10, 0.65, 0.65];
COLOR_WORM_GEAR = [0.95, 0.40, 0.70];

// Legend (gear_type => color)
// planetary_gear => COLOR_PLANETARY
// rack => COLOR_RACK
// mountable_rack => COLOR_MOUNTABLE_RACK
// herringbone_rack => COLOR_HERRINGBONE_RACK
// spur_gear => COLOR_SPUR
// rack_and_pinion => COLOR_RACK_AND_PINION
// bevel_gear => COLOR_BEVEL
// bevel_herringbone_gear => COLOR_BEVEL_HERRINGBONE
// worm => COLOR_WORM
// worm_gear => COLOR_WORM_GEAR

// planetary_gear
color(show_colors ? COLOR_PLANETARY : undef)
planetary_gear(modul=1, sun_teeth=30, planet_teeth=60, number_planets=3,
               width=5, rim_width=3, bore=3, pressure_angle=20);

translate([0,-85,0])
color(show_colors ? COLOR_RACK : undef)
rack(modul=1, length=60, height=5, width=20, pressure_angle=20, helix_angle=0);

translate([50,-85,0])
rotate([0,0,20])
color(show_colors ? COLOR_MOUNTABLE_RACK : undef)
mountable_rack(modul=1, length=60, height=5, width=20, pressure_angle=20, helix_angle=0, profile=3, head="PH",fastners=3);

translate([-50,-85,5])
rotate([0,0,-60])
rotate([90,0,0])
color(show_colors ? COLOR_HERRINGBONE_RACK : undef)
herringbone_rack(modul=1, length=60, height=5, width=20, pressure_angle=20, helix_angle=45);

//mountable_herringbone_rack(modul=1, length=60, height=5, width=20, pressure_angle=20, helix_angle=45, profile=3, head="PH",fastners=3);

translate([-85,-50,0])
color(show_colors ? COLOR_SPUR : undef)
spur_gear (modul=1, tooth_number=30, width=5, bore=4, pressure_angle=20, helix_angle=20, optimized=true);

//herringbone_gear (modul=1, tooth_number=30, width=5, bore=4, pressure_angle=20, helix_angle=30, optimized=true);

translate([95,-50,0])
rotate([0,0,20])
color(show_colors ? COLOR_RACK_AND_PINION : undef)
rack_and_pinion (modul=1, rack_length=50, gear_teeth=30, rack_height=4, gear_bore=4, width=5, pressure_angle=20, helix_angle=0, together_built=true, optimized=true);

//ring_gear (modul=1, tooth_number=30, width=5, rim_width=3, pressure_angle=20, helix_angle=20);

//herringbone_ring_gear (modul=1, tooth_number=30, width=5, rim_width=3, pressure_angle=20, helix_angle=30);

//planetary_gear(modul=1, sun_teeth=16, planet_teeth=9, number_planets=5, width=5, rim_width=3, bore=4, pressure_angle=20, helix_angle=30, together_built=true, optimized=true);

//planetary_gear(modul=2, sun_teeth=16, planet_teeth=9, number_planets=5, width=5, rim_width=3, bore=4, pressure_angle=20, helix_angle=30, together_built=true, optimized=false);

translate([30,-48,0])
color(show_colors ? COLOR_BEVEL : undef)
bevel_gear(modul=1, tooth_number=30,  partial_cone_angle=45, tooth_width=5, bore=4, pressure_angle=20, helix_angle=20);

translate([-52,0,0])
color(show_colors ? COLOR_BEVEL_HERRINGBONE : undef)
bevel_herringbone_gear(modul=1, tooth_number=30, partial_cone_angle=45, tooth_width=5, bore=4, pressure_angle=20, helix_angle=30);

//bevel_gear_pair(modul=1, gear_teeth=30, pinion_teeth=11, axis_angle=100, tooth_width=5, gear_bore=4, pinion_bore=4, pressure_angle = 20, helix_angle=20, together_built=true);

/*
bevel_herringbone_gear_pair(
    modul=1,
    gear_teeth=114,
    pinion_teeth=11,
    axis_angle=90,
    tooth_width=5,
    gear_bore=0,
    pinion_bore=4,
    pressure_angle=20,
    helix_angle=20,
    together_built=true);
*/

translate([92,0,0])
color(show_colors ? COLOR_WORM : undef)
worm(modul=1, thread_starts=2, length=15, bore=4, pressure_angle=20, lead_angle=10, together_built=true);

translate([120,20,0])
rotate([0,0,-20])
color(show_colors ? COLOR_WORM_GEAR : undef)
worm_gear(modul=1, tooth_number=30, thread_starts=2, width=8, length=20, worm_bore=4, gear_bore=4, pressure_angle=20, lead_angle=10, optimized=1, together_built=1, show_spur=1, show_worm=1);
