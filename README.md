# OpenSCAD gear generator

This is a fork of [this OpenSCAD gear generator](https://www.thingiverse.com/thing:1604369), translated into English.

OpenSCAD Library for Gear Racks, Involute and Worm Gears

A library for the parametric creation of gear racks, spur-, ring-, bevel- and worm gears, as well as of assemblies.

## Parametric Gear Rack

Creates a gear rack.

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 20° helix angle, a pressure angle of 20° becomes a pressure angle of 21.17° in the transverse section.

### Format

`zahnstange(modul, laenge, hoehe, breite, eingriffswinkel=20, schraegungswinkel=0)`

#### Parameters
* `modul` = height of the tooth above the pitch line
* `laenge` = length of the rack
* `hoehe` = height from bottom to the pitch line
* `breite` = face width
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867. Should not be greater than 45°.
* `schraegungswinkel` = bevel angle perpendicular to the rack's length; 0° = straight teeth


## Parametric Involute Spur Gear

Creates an involute spur gear without profile displacement following DIN 867 / DIN 58400. 

Two gears will mesh if their modules are the same and their helix angles opposite. The centre distance of two meshing gears A and B with module m and tooth numbers z<sub>a</sub> and z<sub>b</sub> is
<sup>m</sub></sup>/<sub>2</sub>·(z<sub>a</sub> + z<sub>b</sub>)

Helical gears run more smoothly than gears with straight teeth. However, they also create axial loads which the bearings must be designed to contain. Recommendations for the helix angle depending on the module can be found in DIN 3978.

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 20° helix angle, a pressure angle of 20° becomes a pressure angle of 21.17° in the transverse section.

### Format
`stirnrad (modul, zahnzahl, breite, bohrung, eingriffswinkel=20, schraegungswinkel=0, optimiert=true)`

#### Parameters
* `modul` = gear module = height of the tooth above the pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl` = number of teeth
* `breite` = face width
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle to the rotation axis; 0° = straight teeth
* `optimiert` = if true, create holes for material/weight reduction resp. surface increase, if geometry allows


## Parametric Herringbone Involute Spur Gear

Creates a herringbone spur gear without profile displacement. Two gears will mesh if their modules are the same and their helix angles opposite. The centre distance of two meshing gears with module m and tooth numbers z<sub>a</sub> and z<sub>b</sub> is
<sup>m</sub></sup>/<sub>2</sub>·(z<sub>a</sub> + z<sub>b</sub>)

Herringbone gears run more smoothly than gears with straight teeth. They also do not create torque on the axis like helical gears do.

A helix angle, if used, should be set between between 30° and 45°. Recommendations for the helix angle depending on the module can be found in DIN 3978.

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 30° helix angle, a pressure angle of 20° becomes a pressure angle of 22.80 in the transverse section.

### Format
`pfeilrad (modul, zahnzahl, breite, bohrung, eingriffswinkel=20, schraegungswinkel=0, optimiert=true)`

#### Parameters
* `modul` = gear module = height of the tooth above the pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl` = number of teeth
* `breite` = face width
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle to the rotation axis; 0° = straight teeth
* `optimiert` = if true, create holes for material/weight reduction resp. surface increase, if geometry allows


## Parametric Gear Rack and Pinion

Creates a gear rack and pinion.

Helical gears / bevelled racks run more smoothly than gears with straight teeth. However, they also create axial loads which the bearings must be designed to contain. Recommendations for the helix angle depending on the module can be found in DIN 3978.

With a given module m and z<sub>p</sub> teeth on the pinion, the distance between the pinion's axis and the rack's pitch line is
<sup>m</sub></sup>/<sub>2</sub>·z<sub>p</sub>

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 20° helix angle, a pressure angle of 20° becomes a pressure angle of 21.17° in the transverse section.

### Format
`zahnstange(modul, laenge, hoehe, breite, eingriffswinkel=20, schraegungswinkel=0)`

#### Parameters
* `modul` = gear module = height of the tooth above the pitch line/pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `laenge_stange` = length of the rack
* `zahnzahl_ritzel` = number of teeth on the pinion
* `hoehe_stange` = height from bottom to the pitch line
* `bohrung_ritzel` = central bore diameter of the pinion
* `breite` = face width
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = bevel angle perpendicular to the rack's length resp. helix angle to the rotation axis on the pinion; 0° = straight teeth
* `zusammen_gebaut` = assembled (true) or disassembled for printing (false)


## Parametric Involute Ring Gear

Creates a herringbone ring gear without profile displacement. Helical gears run more smoothly than gears with straight teeth. However, they also create axial loads which the bearings must be designed to contain. Recommendations for the helix angle depending on the module can be found in DIN 3978.

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 20° helix angle, a pressure angle of 20° becomes a pressure angle of 21.17° in the transverse section.

### Format
`hohlrad(modul, zahnzahl, breite, randbreite, eingriffswinkel=20, schraegungswinkel=0)`

#### Parameters
* `modul` = gear module = height of the tooth above the pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl` = number of teeth
* `breite` = face width
* `randbreite` = width of the rim around the ring gear, measured from the root circle
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle to the rotation axis; 0° = straight teeth


## Parametric Herringbone Involute Ring Gear

Creates a herringbone ring gear without profile displacement. A ring and spur gear mesh if they have the same module and opposite helix angels. Herringbone gears run more smoothly than gear with straight teeth. They also do not create axial load like helical gears do.

A helix angle, if used, should be set between between 30° and 45°. Recommendations for the helix angle depending on the module can be found in DIN 3978. This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 30° helix angle, a pressure angle of 20° becomes a pressure angle of 22.80° in the transverse section.

### Format
`pfeilhohlrad(modul, zahnzahl, breite, randbreite, eingriffswinkel=20, schraegungswinkel=0)`

#### Parameters
* `modul` = gear module = height of the tooth above the pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl` = number of teeth
* `breite` = face width
* `randbreite` = width of the rim around the ring gear, measured from the root circle
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle to the rotation axis; 0° = straight teeth


## Parametric Planetary Gear using Involute Tooth Geometry and Herringbone Shape

This script calculates both the ring gear as well as, if required, the number and geometry of the planetary gears from the number of teeth on the sun and planets. For a module of <i>m</i>, <i>z<sub>s</sub></i> teeth for the sun and <i>z<sub>p</sub></i> teeth for the planets, the centre distance will be
<sup>m</sub></sup>/<sub>2</sub>·(z<sub>s</sub> + z<sub>p</sub>)

If the number of planets is set to zero (anzahl_planeten = 0) then the module will try and calculate them.

For a module of  <i>m</i>, <i>z<sub>s</sub></i> teeth for the sun, <i>z<sub>p</sub></i> teeth for the planets and a rim width of <i>b<sub>r</sub></i>, the outer diameter is m·(z<sub>s</sub>+2z<sub>p</sub>+2.333)+2b<sub>r</sub>

The helix angle should be between between 30° and 45°. Recommendations for the helix angle depending on the module can be found in DIN 3978. This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 30° helix angle, a pressure angle 20° becomes a pressure angle of 22.80° in the transverse section.

If no number of gears is given (anzahl_planeten = 0), then the script will attempt to calculate the least number of planet gears.

To avoid the gears sticking in a 3D print, particularly sticking of the planet gears to the ring gear, the gears can be printed in disassembled layout (zusammen gebaut = false). In that case, please note that herringbone teeth complicate the re-assembly. Experience shows that reassembly is still possible at 30°; however in case of reassembly problems, a lesser helix angle should be selected. Of course, one could always choose straight teeth (Schraegungswinkel = 0).

The gears can also be kept from sticking by a sufficiently large clearance ("Spiel"); a sufficient clearance also avoids meshing problems. Clearance can be left smaller if the 3D printer offers good resolution, however experience shows that it should not be less than 5%.

### Format
`planetengetriebe(modul, zahnzahl_sonne, zahnzahl_planet, breite, randbreite, bohrung, eingriffswinkel=20, schraegungswinkel=0, zusammen_gebaut=true, optimiert=true)`

#### Parameters
* `spiel` = clearance between teeth as a fraction of their width (0 = no clearance)
* `modul` = gear module = height of the tooth above the pitch circle = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl`_sonne = number of teeth on the sun gear
* `zahnzahl`_planet = number of teeth per planet gear
* `anzahl_planeten` = number of planet gears; if set to zero, the script will attempt to calculate the least number of planet gears
* `breite` = face width
* `randbreite` = width of the rim around the ring gear, measured from the root circle
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle to the rotation axis; 0° = straight teeth
* `zusammen_gebaut` = components assembled for construction (true) or disassembled (false) for 3D printing
* `optimiert` = if true, create holes for material/weight reduction resp. surface increase, if geometry allows


## Parametric Herringbone Bevel Gear with Spherical Involute Geometry

This script creates a herringbone bevel gear with spherical involute teeth geometry. Two gears will mesh if their modules are the same and their helix angles opposite. Herringbone gears run more smoothly than gear with straight teeth. They also do not create axial load like helical gears do. Recommendations for the helix angle depending on the module can be found in DIN 3978.

This script adjusts the pressure angle in the transverse section to the helix angle: e.g. with a 30° helix angle, a pressure angle of 20° becomes a pressure angle of 22.80° in the transverse section.

### Format
`pfeilkegelrad(modul, zahnzahl, teilkegelwinkel, zahnbreite, bohrung, eingriffswinkel=20, schraegungswinkel=0)`

#### Parameters
* `modul` = gear module = height of the gear teeth above the pitch cone = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl` = number of teeth
* `teilkegelwinkel` = reference cone (half-)angle
* `zahnbreite` = width of teeth from the rim in direction of the reference cone tip
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle between the teeth and the reference cone envelope line, 0° = straight teeth


## Parametric Pair of Bevel Gears

This script calculates both the gear and the pinion of a bevel gear pair, using the gears' module and their numbers of teeth. The preset angle of 90° between the axes of both gears can be varied. It is possible to calculate the pair both assembled for design as well as disassembled for printing.

### Format
`kegelradpaar(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel=90, zahnbreite, bohrung, eingriffswinkel = 20, schraegungswinkel=0, zusammen_gebaut=true)`

#### Parameters
* `modul` = gear module = height of the gear teeth above the pitch cone = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl_rad` = number of teeth on the gear
* `zahnzahl_ritzel` = number of teeth on the pinion
* `achsenwinkel` = angle between the axes of pinion and gear, standard value = 90°
* `zahnbreite` = width of the teeth from the rim in direction of the cone tip
* `bohrung_rad` = central bore diameter of the gear
* `bohrung_ritzel` = central bore diameter of the pinion
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle between the teeth and the reference cone envelope line, 0° = straight teeth
* `zusammen_gebaut` = assembled (true) oder disassembled for printing (false)


## Parametric Pair of Herringbone Bevel Gears

This script calculates both the gear and the pinion of a herringbone bevel gear pair, using the gears' module and their numbers of teeth. The preset angle of 90° between the axes of both gears can be varied. It is possible to calculate the pair both assembled for design as well as disassembled for printing.

### Format
`pfeilkegelradpaar(modul, zahnzahl_rad, zahnzsahl_ritzel, achsenwinkel=90, zahnbreite, bohrung, eingriffswinkel = 20, schraegungswinkel=0, zusammen_gebaut=true)`

#### Parameters
* `modul` = gear module = height of the gear teeth above the pitch cone = 25.4 / diametrical pitch = circular pitch / π
* `zahnzahl_rad` = number of teeth on the gear
* `zahnzahl_ritzel` = number of teeth on the pinion
* `achsenwinkel` = angle between the axes of pinion and gear, standard value = 90°
* `zahnbreite` = width of the teeth from the rim in direction of the cone tip
* `bohrung_rad` = central bore diameter of the gear
* `bohrung_ritzel` = central bore diameter of the pinion
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `schraegungswinkel` = helix angle between the teeth and the reference cone envelope line, 0° = straight teeth
* `zusammen_gebaut` = assembled (true) or disassembled for printing (false)


## Parametric Worm

Creates a cylidrical worm (archimedean spiral) following DIN 3975.

The worm's pitch circle r can be calculated out of its module m, number of threads z and lead angle γ:

r = m·z·<sup>1</sup>/<sub>2sinγ</sub>

### Format
`schnecke(modul, gangzahl, laenge, bohrung, eingriffswinkel=20, steigungswinkel=10, zusammen_gebaut=true)`

#### Parameters
* `modul` = height of the thread above the pitch circle
* `gangzahl` = number of threads
* `laenge` = length of the worm
* `bohrung` = central bore diameter
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867
* `steigungswinkel` = lead angle of worm. Positive lead angle = clockwise thread rotation
* `zusammen_gebaut` = assembled (true) or disassembled for printing (false)



##  Worm Gear Set  (Worm and Pinion)

Creates a set of one worm gear and a pinion. The pinion is a normal spur gear without globoid geometry.

### Format
`module schneckenradsatz(modul, zahnzahl, gangzahl, breite, laenge, bohrung_schnecke, bohrung_rad, eingriffswinkel=20, steigungswinkel, optimiert=true, zusammen_gebaut=true)`

### Parameter

* `modul` = gear module = and height of the gear teeth above th pitch circle / of the thread above the pitch circle
* `zahnzahl` = number of teeth on the pinion
* `gangzahl` = number of threads
* `breite` = face width on the pinion
* `laenge` = length of the worm
* `bohrung_schnecke` = central bore diameter of the worm
* `bohrung_rad` = central bore diameter of the pinion
* `eingriffswinkel` = pressure angle, standard value = 20° according to DIN 867. Shouldn't be greater than 45°
* `steigungswinkel` = lead angle of worm. Positive lead angle = clockwise thread rotation
* `optimiert` = if true, create holes for material/weight reduction resp. surface increase, if geometry allows
* `zusammen_gebaut` =  assembled (true) or disassembled for printing (false)
