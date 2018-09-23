$fn = 96;

/* Bibliothek für Evolventen-Zahnräder, Schnecken und Zahnstangen

Enthält die Module
- rack(modul, length, hoehe, width, pressure_angle=20, schraegungswinkel=0)
- spur_gear(modul, tooth_number, width, bohrung, pressure_angle=20, schraegungswinkel=0, optimized=true)
- arrow_gear(modul, tooth_number, width, bohrung, pressure_angle=20, schraegungswinkel=0, optimized=true)
- rack_und_rad (modul, laenge_stange, zahnzahl_rad, hoehe_stange, bohrung_rad, width, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true, optimized=true)
- ring_gear(modul, tooth_number, width, randbreite, pressure_angle=20, schraegungswinkel=0)
- arrow_ring_gear(modul, tooth_number, width, randbreite, pressure_angle=20, schraegungswinkel=0)
- planetary_gear(modul, zahnzahl_sonne, zahnzahl_planet, anzahl_planeten, width, randbreite, bohrung, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true, optimized=true)
- bevel_gear(modul, tooth_number,  teilkegelwinkel, zahnbreite, bohrung, pressure_angle=20, schraegungswinkel=0)
- bevel_arrow_gear(modul, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle=20, schraegungswinkel=0)
- bevel_gear_pair(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel=90, zahnbreite, bohrung, pressure_angle = 20, schraegungswinkel=0, zusammen_gebaut=true)
- bevel_arrow_gear_pair(modul, zahnzahl_rad, zahnzsahl_ritzel, achsenwinkel=90, zahnbreite, bohrung, pressure_angle = 20, schraegungswinkel=0, zusammen_gebaut=true)
- worm(modul, gangzahl, length, bohrung, pressure_angle=20, steigungswinkel=10, zusammen_gebaut=true)
- worm_gear(modul, tooth_number, gangzahl, width, length, bohrung_schnecke, bohrung_rad, pressure_angle=20, steigungswinkel=0, optimized=true, zusammen_gebaut=true)

Beispiele für jedes Modul befinden sich auskommentiert am Ende dieser Datei

Autor:      Dr Jörg Janssen
Stand:      1. Juni 2018
Version:    2.2
Lizenz:     Creative Commons - Attribution, Non Commercial, Share Alike

Erlaubte Module nach DIN 780:
0.05 0.06 0.08 0.10 0.12 0.16
0.20 0.25 0.3  0.4  0.5  0.6
0.7  0.8  0.9  1    1.25 1.5
2    2.5  3    4    5    6
8    10   12   16   20   25
32   40   50   60

*/


// Allgemeine Variablen
pi = 3.14159;
rad = 57.29578;
spiel = 0.05;   // Spiel zwischen Zähnen

/*  Wandelt Radian in Grad um */
function grad(pressure_angle) = pressure_angle*rad;

/*  Wandelt Grad in Radian um */
function radian(pressure_angle) = pressure_angle/rad;

/*  Wandelt 2D-Polarkoordinaten in kartesische um
    Format: radius, phi; phi = Winkel zur x-Achse auf xy-Ebene */
function pol_zu_kart(polvect) = [
    polvect[0]*cos(polvect[1]),  
    polvect[0]*sin(polvect[1])
];

/*  Kreisevolventen-Funktion:
    Gibt die Polarkoordinaten einer Kreisevolvente aus
    r = Radius des Grundkreises
    rho = Abrollwinkel in Grad */
function ev(r,rho) = [
    r/cos(rho),
    grad(tan(rho)-radian(rho))
];

/*  Kugelevolventen-Funktion
    Gibt den Azimutwinkel einer Kugelevolvente aus
    theta0 = Polarwinkel des Kegels, an dessen Schnittkante zur Großkugel die Evolvente abrollt
    theta = Polarwinkel, für den der Azimutwinkel der Evolvente berechnet werden soll */
function kugelev(theta0,theta) = 1/sin(theta0)*acos(cos(theta)/cos(theta0))-acos(tan(theta0)/tan(theta));

/*  Wandelt Kugelkoordinaten in kartesische um
    Format: radius, theta, phi; theta = Winkel zu z-Achse, phi = Winkel zur x-Achse auf xy-Ebene */
function kugel_zu_kart(vect) = [
    vect[0]*sin(vect[1])*cos(vect[2]),  
    vect[0]*sin(vect[1])*sin(vect[2]),
    vect[0]*cos(vect[1])
];

/*  prüft, ob eine Zahl gerade ist
    = 1, wenn ja
    = 0, wenn die Zahl nicht gerade ist */
function istgerade(zahl) =
    (zahl == floor(zahl/2)*2) ? 1 : 0;

/*  größter gemeinsamer Teiler
    nach Euklidischem Algorithmus.
    Sortierung: a muss größer als b sein */
function ggt(a,b) = 
    a%b == 0 ? b : ggt(b,a%b);

/*  Polarfunktion mit polarwinkel und zwei variablen */
function spirale(a, r0, phi) =
    a*phi + r0; 

/*  Kopiert und dreht einen Körper */
module kopiere(vect, zahl, abstand, winkel){
    for(i = [0:zahl-1]){
        translate(v=vect*abstand*i)
            rotate(a=i*winkel, v = [0,0,1])
                children(0);
    }
}

/*  rack
    modul = Höhe des Zahnkopfes über der Wälzgeraden
    length = Länge der rack
    hoehe = Höhe der rack bis zur Wälzgeraden
    width = Breite eines Zahns
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Zahnstangen-Querachse; 0° = Geradverzahnung */
module rack(modul, length, hoehe, width, pressure_angle = 20, schraegungswinkel = 0) {

    // Dimensions-Berechnungen
    modul=modul*(1-spiel);
    c = modul / 6;                                              // Kopfspiel
    mx = modul/cos(schraegungswinkel);                          // Durch Schrägungswinkel verzerrtes modul in x-Richtung
    a = 2*mx*tan(pressure_angle)+c*tan(pressure_angle);       // Flankenbreite
    b = pi*mx/2-2*mx*tan(pressure_angle);                      // Kopfbreite
    x = width*tan(schraegungswinkel);                          // Verschiebung der Oberseite in x-Richtung durch Schrägungswinkel
    nz = ceil((length+abs(2*x))/(pi*mx));                       // Anzahl der Zähne
    
    translate([-pi*mx*(nz-1)/2-a-b/2,-modul,0]){
        intersection(){                                         // Erzeugt ein Prisma, das in eine Quadergeometrie eingepasst wird
            kopiere([1,0,0], nz, pi*mx, 0){
                polyhedron(
                    points=[[0,-c,0], [a,2*modul,0], [a+b,2*modul,0], [2*a+b,-c,0], [pi*mx,-c,0], [pi*mx,modul-hoehe,0], [0,modul-hoehe,0], // Unterseite
                        [0+x,-c,width], [a+x,2*modul,width], [a+b+x,2*modul,width], [2*a+b+x,-c,width], [pi*mx+x,-c,width], [pi*mx+x,modul-hoehe,width], [0+x,modul-hoehe,width]],   // Oberseite
                    faces=[[6,5,4,3,2,1,0],                     // Unterseite
                        [1,8,7,0],
                        [9,8,1,2],
                        [10,9,2,3],
                        [11,10,3,4],
                        [12,11,4,5],
                        [13,12,5,6],
                        [7,13,6,0],
                        [7,8,9,10,11,12,13],                    // Oberseite
                    ]
                );
            };
            translate([abs(x),-hoehe+modul-0.5,-0.5]){
                cube([length,hoehe+modul+1,width+1]);          // Quader, der das Volumen der rack umfasst
            }   
        };
    };  
}

/*  Stirnrad
    modul = Höhe des Zahnkopfes über dem Teilkreis
    tooth_number = Anzahl der Radzähne
    width = Zahnbreite
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse; 0° = Geradverzahnung
    optimized = Löcher zur Material-/Gewichtsersparnis bzw. Oberflächenvergößerung erzeugen, wenn Geometrie erlaubt */
module spur_gear(modul, tooth_number, width, bohrung, pressure_angle = 20, schraegungswinkel = 0, optimized = true) {

    // Dimensions-Berechnungen  
    d = modul * tooth_number;                                           // Teilkreisdurchmesser
    r = d / 2;                                                      // Teilkreisradius
    alpha_stirn = atan(tan(pressure_angle)/cos(schraegungswinkel));// Schrägungswinkel im Stirnschnitt
    db = d * cos(alpha_stirn);                                      // Grundkreisdurchmesser
    rb = db / 2;                                                    // Grundkreisradius
    da = (modul <1)? d + modul * 2.2 : d + modul * 2;               // Kopfkreisdurchmesser nach DIN 58400 bzw. DIN 867
    ra = da / 2;                                                    // Kopfkreisradius
    c =  (tooth_number <3)? 0 : modul/6;                                // Kopfspiel
    df = d - 2 * (modul + c);                                       // Fußkreisdurchmesser
    rf = df / 2;                                                    // Fußkreisradius
    rho_ra = acos(rb/ra);                                           // maximaler Abrollwinkel;
                                                                    // Evolvente beginnt auf Grundkreis und endet an Kopfkreis
    rho_r = acos(rb/r);                                             // Abrollwinkel am Teilkreis;
                                                                    // Evolvente beginnt auf Grundkreis und endet an Kopfkreis
    phi_r = grad(tan(rho_r)-radian(rho_r));                         // Winkel zum Punkt der Evolvente auf Teilkreis
    gamma = rad*width/(r*tan(90-schraegungswinkel));               // Torsionswinkel für Extrusion
    schritt = rho_ra/16;                                            // Evolvente wird in 16 Stücke geteilt
    tau = 360/tooth_number;                                             // Teilungswinkel
    
    r_loch = (2*rf - bohrung)/8;                                    // Radius der Löcher für Material-/Gewichtsersparnis
    rm = bohrung/2+2*r_loch;                                        // Abstand der Achsen der Löcher von der Hauptachse
    z_loch = floor(2*pi*rm/(3*r_loch));                             // Anzahl der Löcher für Material-/Gewichtsersparnis
    
    optimized = (optimized && r >= width*1.5 && d > 2*bohrung);    // ist Optimierung sinnvoll?

    // Zeichnung
    union(){
        rotate([0,0,-phi_r-90*(1-spiel)/tooth_number]){                     // Zahn auf x-Achse zentrieren;
                                                                        // macht Ausrichtung mit anderen Rädern einfacher

            linear_extrude(height = width, twist = gamma){
                difference(){
                    union(){
                        zahnbreite = (180*(1-spiel))/tooth_number+2*phi_r;
                        circle(rf);                                     // Fußkreis 
                        for (rot = [0:tau:360]){
                            rotate (rot){                               // "Zahnzahl-mal" kopieren und drehen
                                polygon(concat(                         // Zahn
                                    [[0,0]],                            // Zahnsegment beginnt und endet im Ursprung
                                    [for (rho = [0:schritt:rho_ra])     // von null Grad (Grundkreis)
                                                                        // bis maximalen Evolventenwinkel (Kopfkreis)
                                        pol_zu_kart(ev(rb,rho))],       // Erste Evolventen-Flanke

                                    [pol_zu_kart(ev(rb,rho_ra))],       // Punkt der Evolvente auf Kopfkreis

                                    [for (rho = [rho_ra:-schritt:0])    // von maximalen Evolventenwinkel (Kopfkreis)
                                                                        // bis null Grad (Grundkreis)
                                        pol_zu_kart([ev(rb,rho)[0], zahnbreite-ev(rb,rho)[1]])]
                                                                        // Zweite Evolventen-Flanke
                                                                        // (180*(1-spiel)) statt 180 Grad,
                                                                        // um Spiel an den Flanken zu erlauben
                                    )
                                );
                            }
                        }
                    }           
                    circle(r = rm+r_loch*1.49);                         // "Bohrung"
                }
            }
        }
        // mit Materialersparnis
        if (optimized) {
            linear_extrude(height = width){
                difference(){
                        circle(r = (bohrung+r_loch)/2);
                        circle(r = bohrung/2);                          // Bohrung
                    }
                }
            linear_extrude(height = (width-r_loch/2 < width*2/3) ? width*2/3 : width-r_loch/2){
                difference(){
                    circle(r=rm+r_loch*1.51);
                    union(){
                        circle(r=(bohrung+r_loch)/2);
                        for (i = [0:1:z_loch]){
                            translate(kugel_zu_kart([rm,90,i*360/z_loch]))
                                circle(r = r_loch);
                        }
                    }
                }
            }
        }
        // ohne Materialersparnis
        else {
            linear_extrude(height = width){
                difference(){
                    circle(r = rm+r_loch*1.51);
                    circle(r = bohrung/2);
                }
            }
        }
    }
}

/*  Pfeilrad; verwendet das Modul "spur_gear"
    modul = Höhe des Zahnkopfes über dem Teilkreis
    tooth_number = Anzahl der Radzähne
    width = Zahnbreite
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse, Standardwert = 0° (Geradverzahnung)
    optimized = Löcher zur Material-/Gewichtsersparnis */
module arrow_gear(modul, tooth_number, width, bohrung, pressure_angle = 20, schraegungswinkel=0, optimized=true){

    width = width/2;
    d = modul * tooth_number;                                           // Teilkreisdurchmesser
    r = d / 2;                                                      // Teilkreisradius
    c =  (tooth_number <3)? 0 : modul/6;                                // Kopfspiel

    df = d - 2 * (modul + c);                                       // Fußkreisdurchmesser
    rf = df / 2;                                                    // Fußkreisradius

    r_loch = (2*rf - bohrung)/8;                                    // Radius der Löcher für Material-/Gewichtsersparnis
    rm = bohrung/2+2*r_loch;                                        // Abstand der Achsen der Löcher von der Hauptachse
    z_loch = floor(2*pi*rm/(3*r_loch));                             // Anzahl der Löcher für Material-/Gewichtsersparnis
    
    optimized = (optimized && r >= width*3 && d > 2*bohrung);      // ist Optimierung sinnvoll?

    translate([0,0,width]){
        union(){
            spur_gear(modul, tooth_number, width, 2*(rm+r_loch*1.49), pressure_angle, schraegungswinkel, false);      // untere Hälfte
            mirror([0,0,1]){
                spur_gear(modul, tooth_number, width, 2*(rm+r_loch*1.49), pressure_angle, schraegungswinkel, false);  // obere Hälfte
            }
        }
    }
    // mit Materialersparnis
    if (optimized) {
        linear_extrude(height = width*2){
            difference(){
                    circle(r = (bohrung+r_loch)/2);
                    circle(r = bohrung/2);                          // Bohrung
                }
            }
        linear_extrude(height = (2*width-r_loch/2 < 1.33*width) ? 1.33*width : 2*width-r_loch/2){ //width*4/3
            difference(){
                circle(r=rm+r_loch*1.51);
                union(){
                    circle(r=(bohrung+r_loch)/2);
                    for (i = [0:1:z_loch]){
                        translate(kugel_zu_kart([rm,90,i*360/z_loch]))
                            circle(r = r_loch);
                    }
                }
            }
        }
    }
    // ohne Materialersparnis
    else {
        linear_extrude(height = width*2){
            difference(){
                circle(r = rm+r_loch*1.51);
                circle(r = bohrung/2);
            }
        }
    }
}

/*  rack und -Rad
    modul = Höhe des Zahnkopfes über dem Teilkreis
    laenge_stange = Laenge der rack
    zahnzahl_rad = Anzahl der Radzähne
    hoehe_stange = Höhe der rack bis zur Wälzgeraden
    bohrung_rad = Durchmesser der Mittelbohrung des Stirnrads
    width = Breite eines Zahns
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse, Standardwert = 0° (Geradverzahnung) */
module zahnstange_und_rad (modul, laenge_stange, zahnzahl_rad, hoehe_stange, bohrung_rad, width, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true, optimized=true) {

    abstand = zusammen_gebaut? modul*zahnzahl_rad/2 : modul*zahnzahl_rad;

    rack(modul, laenge_stange, hoehe_stange, width, pressure_angle, -schraegungswinkel);
    translate([0,abstand,0])
        rotate(a=360/zahnzahl_rad)
            spur_gear (modul, zahnzahl_rad, width, bohrung_rad, pressure_angle, schraegungswinkel, optimized);
}

/*  Hohlrad
    modul = Höhe des Zahnkopfes über dem Teilkreis
    tooth_number = Anzahl der Radzähne
    width = Zahnbreite
    randbreite = Breite des Randes ab Fußkreis
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse, Standardwert = 0° (Geradverzahnung) */
module ring_gear(modul, tooth_number, width, randbreite, pressure_angle = 20, schraegungswinkel = 0) {

    // Dimensions-Berechnungen  
    ha = (tooth_number >= 20) ? 0.02 * atan((tooth_number/15)/pi) : 0.6;    // Verkürzungsfaktor Zahnkopfhöhe
    d = modul * tooth_number;                                           // Teilkreisdurchmesser
    r = d / 2;                                                      // Teilkreisradius
    alpha_stirn = atan(tan(pressure_angle)/cos(schraegungswinkel));// Schrägungswinkel im Stirnschnitt
    db = d * cos(alpha_stirn);                                      // Grundkreisdurchmesser
    rb = db / 2;                                                    // Grundkreisradius
    c = modul / 6;                                                  // Kopfspiel
    da = (modul <1)? d + (modul+c) * 2.2 : d + (modul+c) * 2;       // Kopfkreisdurchmesser
    ra = da / 2;                                                    // Kopfkreisradius
    df = d - 2 * modul * ha;                                        // Fußkreisdurchmesser
    rf = df / 2;                                                    // Fußkreisradius
    rho_ra = acos(rb/ra);                                           // maximaler Evolventenwinkel;
                                                                    // Evolvente beginnt auf Grundkreis und endet an Kopfkreis
    rho_r = acos(rb/r);                                             // Evolventenwinkel am Teilkreis;
                                                                    // Evolvente beginnt auf Grundkreis und endet an Kopfkreis
    phi_r = grad(tan(rho_r)-radian(rho_r));                         // Winkel zum Punkt der Evolvente auf Teilkreis
    gamma = rad*width/(r*tan(90-schraegungswinkel));               // Torsionswinkel für Extrusion
    schritt = rho_ra/16;                                            // Evolvente wird in 16 Stücke geteilt
    tau = 360/tooth_number;                                             // Teilungswinkel

    // Zeichnung
    rotate([0,0,-phi_r-90*(1+spiel)/tooth_number])                      // Zahn auf x-Achse zentrieren;
                                                                    // macht Ausrichtung mit anderen Rädern einfacher
    linear_extrude(height = width, twist = gamma){
        difference(){
            circle(r = ra + randbreite);                            // Außenkreis
            union(){
                zahnbreite = (180*(1+spiel))/tooth_number+2*phi_r;
                circle(rf);                                         // Fußkreis 
                for (rot = [0:tau:360]){
                    rotate (rot) {                                  // "Zahnzahl-mal" kopieren und drehen
                        polygon( concat(
                            [[0,0]],
                            [for (rho = [0:schritt:rho_ra])         // von null Grad (Grundkreis)
                                                                    // bis maximaler Evolventenwinkel (Kopfkreis)
                                pol_zu_kart(ev(rb,rho))],
                            [pol_zu_kart(ev(rb,rho_ra))],
                            [for (rho = [rho_ra:-schritt:0])        // von maximaler Evolventenwinkel (Kopfkreis)
                                                                    // bis null Grad (Grundkreis)
                                pol_zu_kart([ev(rb,rho)[0], zahnbreite-ev(rb,rho)[1]])]
                                                                    // (180*(1+spiel)) statt 180,
                                                                    // um Spiel an den Flanken zu erlauben
                            )
                        );
                    }
                }
            }
        }
    }

    echo("Außendurchmesser Hohlrad = ", 2*(ra + randbreite));
    
}

/*  Pfeil-Hohlrad; verwendet das Modul "ring_gear"
    modul = Höhe des Zahnkopfes über dem Teilkegel
    tooth_number = Anzahl der Radzähne
    width = Zahnbreite
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse, Standardwert = 0° (Geradverzahnung) */
module arrow_ring_gear(modul, tooth_number, width, randbreite, pressure_angle = 20, schraegungswinkel = 0) {

    width = width / 2;
    translate([0,0,width])
        union(){
        ring_gear(modul, tooth_number, width, randbreite, pressure_angle, schraegungswinkel);       // untere Hälfte
        mirror([0,0,1])
            ring_gear(modul, tooth_number, width, randbreite, pressure_angle, schraegungswinkel);   // obere Hälfte
    }
}

/*  Planetengetriebe; verwendet die Module "arrow_gear" und "arrow_ring_gear"
    modul = Höhe des Zahnkopfes über dem Teilkegel
    zahnzahl_sonne = Anzahl der Zähne des Sonnenrads
    zahnzahl_planet = Anzahl der Zähne eines Planetenrads
    anzahl_planeten = Anzahl der Planetenräder. Wenn null, rechnet die Funktion die Mindestanzahl aus.
    width = Zahnbreite
    randbreite = Breite des Randes ab Fußkreis
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel zur Rotationsachse, Standardwert = 0° (Geradverzahnung)
    zusammen_gebaut = 
    optimized = Löcher zur Material-/Gewichtsersparnis bzw. Oberflächenvergößerung erzeugen, wenn Geometrie erlaubt
    zusammen_gebaut = Komponenten zusammengebaut für Konstruktion oder auseinander zum 3D-Druck */
module planetary_gear(modul, zahnzahl_sonne, zahnzahl_planet, anzahl_planeten, width, randbreite, bohrung, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true, optimized=true){

    // Dimensions-Berechnungen
    d_sonne = modul*zahnzahl_sonne;                                     // Teilkreisdurchmesser Sonne
    d_planet = modul*zahnzahl_planet;                                   // Teilkreisdurchmesser Planeten
    achsabstand = modul*(zahnzahl_sonne +  zahnzahl_planet) / 2;        // Abstand von Sonnenrad-/Hohlradachse und Planetenachse
    zahnzahl_hohlrad = zahnzahl_sonne + 2*zahnzahl_planet;              // Anzahl der Zähne des Hohlrades
    d_hohlrad = modul*zahnzahl_hohlrad;                                 // Teilkreisdurchmesser Hohlrad

    drehen = istgerade(zahnzahl_planet);                                // Muss das Sonnenrad gedreht werden?
        
    n_max = floor(180/asin(modul*(zahnzahl_planet)/(modul*(zahnzahl_sonne +  zahnzahl_planet))));
                                                                        // Anzahl Planetenräder: höchstens so viele, wie ohne
                                                                        // Überlappung möglich

    // Zeichnung
    rotate([0,0,180/zahnzahl_sonne*drehen]){
        arrow_gear (modul, zahnzahl_sonne, width, bohrung, pressure_angle, -schraegungswinkel, optimized);      // Sonnenrad
    }

    if (zusammen_gebaut){
        if(anzahl_planeten==0){
            list = [ for (n=[2 : 1 : n_max]) if ((((zahnzahl_hohlrad+zahnzahl_sonne)/n)==floor((zahnzahl_hohlrad+zahnzahl_sonne)/n))) n];
            anzahl_planeten = list[0];                                      // Ermittele Anzahl Planetenräder
             achsabstand = modul*(zahnzahl_sonne + zahnzahl_planet)/2;      // Abstand von Sonnenrad-/Hohlradachse
            for(n=[0:1:anzahl_planeten-1]){
                translate(kugel_zu_kart([achsabstand,90,360/anzahl_planeten*n]))
                    rotate([0,0,n*360*d_sonne/d_planet])
                        arrow_gear (modul, zahnzahl_planet, width, bohrung, pressure_angle, schraegungswinkel); // Planetenräder
            }
       }
       else{
            achsabstand = modul*(zahnzahl_sonne + zahnzahl_planet)/2;       // Abstand von Sonnenrad-/Hohlradachse
            for(n=[0:1:anzahl_planeten-1]){
                translate(kugel_zu_kart([achsabstand,90,360/anzahl_planeten*n]))
                rotate([0,0,n*360*d_sonne/(d_planet)])
                    arrow_gear (modul, zahnzahl_planet, width, bohrung, pressure_angle, schraegungswinkel); // Planetenräder
            }
        }
    }
    else{
        planetenabstand = zahnzahl_hohlrad*modul/2+randbreite+d_planet;     // Abstand Planeten untereinander
        for(i=[-(anzahl_planeten-1):2:(anzahl_planeten-1)]){
            translate([planetenabstand, d_planet*i,0])
                arrow_gear (modul, zahnzahl_planet, width, bohrung, pressure_angle, schraegungswinkel); // Planetenräder
        }
    }

    arrow_ring_gear (modul, zahnzahl_hohlrad, width, randbreite, pressure_angle, schraegungswinkel); // Hohlrad

}

/*  Kegelrad
    modul = Höhe des Zahnkopfes über dem Teilkegel; Angabe für die Aussenseite des Kegels
    tooth_number = Anzahl der Radzähne
    teilkegelwinkel = (Halb)winkel des Kegels, auf dem das jeweils andere Hohlrad abrollt
    zahnbreite = Breite der Zähne von der Außenseite in Richtung Kegelspitze
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel, Standardwert = 0° */
module bevel_gear(modul, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle = 20, schraegungswinkel=0) {

    // Dimensions-Berechnungen
    d_aussen = modul * tooth_number;                                    // Teilkegeldurchmesser auf der Kegelgrundfläche,
                                                                    // entspricht der Sehne im Kugelschnitt
    r_aussen = d_aussen / 2;                                        // Teilkegelradius auf der Kegelgrundfläche 
    rg_aussen = r_aussen/sin(teilkegelwinkel);                      // Großkegelradius für Zahn-Außenseite, entspricht der Länge der Kegelflanke;
    rg_innen = rg_aussen - zahnbreite;                              // Großkegelradius für Zahn-Innenseite  
    r_innen = r_aussen*rg_innen/rg_aussen;
    alpha_stirn = atan(tan(pressure_angle)/cos(schraegungswinkel));// Schrägungswinkel im Stirnschnitt
    delta_b = asin(cos(alpha_stirn)*sin(teilkegelwinkel));          // Grundkegelwinkel     
    da_aussen = (modul <1)? d_aussen + (modul * 2.2) * cos(teilkegelwinkel): d_aussen + modul * 2 * cos(teilkegelwinkel);
    ra_aussen = da_aussen / 2;
    delta_a = asin(ra_aussen/rg_aussen);
    c = modul / 6;                                                  // Kopfspiel
    df_aussen = d_aussen - (modul +c) * 2 * cos(teilkegelwinkel);
    rf_aussen = df_aussen / 2;
    delta_f = asin(rf_aussen/rg_aussen);
    rkf = rg_aussen*sin(delta_f);                                   // Radius des Kegelfußes
    hoehe_f = rg_aussen*cos(delta_f);                               // Höhe des Kegels vom Fußkegel
    
    echo("Teilkegeldurchmesser auf der Kegelgrundfläche = ", d_aussen);
    
    // Größen für Komplementär-Kegelstumpf
    hoehe_k = (rg_aussen-zahnbreite)/cos(teilkegelwinkel);          // Höhe des Komplementärkegels für richtige Zahnlänge
    rk = (rg_aussen-zahnbreite)/sin(teilkegelwinkel);               // Fußradius des Komplementärkegels
    rfk = rk*hoehe_k*tan(delta_f)/(rk+hoehe_k*tan(delta_f));        // Kopfradius des Zylinders für 
                                                                    // Komplementär-Kegelstumpf
    hoehe_fk = rk*hoehe_k/(hoehe_k*tan(delta_f)+rk);                // Hoehe des Komplementär-Kegelstumpfs

    echo("Höhe Kegelrad = ", hoehe_f-hoehe_fk);
    
    phi_r = kugelev(delta_b, teilkegelwinkel);                      // Winkel zum Punkt der Evolvente auf Teilkegel
        
    // Torsionswinkel gamma aus Schrägungswinkel
    gamma_g = 2*atan(zahnbreite*tan(schraegungswinkel)/(2*rg_aussen-zahnbreite));
    gamma = 2*asin(rg_aussen/r_aussen*sin(gamma_g/2));
    
    schritt = (delta_a - delta_b)/16;
    tau = 360/tooth_number;                                             // Teilungswinkel
    start = (delta_b > delta_f) ? delta_b : delta_f;
    spiegelpunkt = (180*(1-spiel))/tooth_number+2*phi_r;

    // Zeichnung
    rotate([0,0,phi_r+90*(1-spiel)/tooth_number]){                      // Zahn auf x-Achse zentrieren;
                                                                    // macht Ausrichtung mit anderen Rädern einfacher
        translate([0,0,hoehe_f]) rotate(a=[0,180,0]){
            union(){
                translate([0,0,hoehe_f]) rotate(a=[0,180,0]){                               // Kegelstumpf                          
                    difference(){
                        linear_extrude(height=hoehe_f-hoehe_fk, scale=rfk/rkf) circle(rkf*1.001); // 1 promille Überlappung mit Zahnfuß
                        translate([0,0,-1]){
                            cylinder(h = hoehe_f-hoehe_fk+2, r = bohrung/2);                // Bohrung
                        }
                    }   
                }
                for (rot = [0:tau:360]){
                    rotate (rot) {                                                          // "Zahnzahl-mal" kopieren und drehen
                        union(){
                            if (delta_b > delta_f){
                                // Zahnfuß
                                flankenpunkt_unten = 1*spiegelpunkt;
                                flankenpunkt_oben = kugelev(delta_f, start);
                                polyhedron(
                                    points = [
                                        kugel_zu_kart([rg_aussen, start*1.001, flankenpunkt_unten]),    // 1 promille Überlappung mit Zahn
                                        kugel_zu_kart([rg_innen, start*1.001, flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_innen, start*1.001, spiegelpunkt-flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_aussen, start*1.001, spiegelpunkt-flankenpunkt_unten]),                               
                                        kugel_zu_kart([rg_aussen, delta_f, flankenpunkt_unten]),
                                        kugel_zu_kart([rg_innen, delta_f, flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_innen, delta_f, spiegelpunkt-flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_aussen, delta_f, spiegelpunkt-flankenpunkt_unten])                                
                                    ],
                                    faces = [[0,1,2],[0,2,3],[0,4,1],[1,4,5],[1,5,2],[2,5,6],[2,6,3],[3,6,7],[0,3,7],[0,7,4],[4,6,5],[4,7,6]],
                                    convexity =1
                                );
                            }
                            // Zahn
                            for (delta = [start:schritt:delta_a-schritt]){
                                flankenpunkt_unten = kugelev(delta_b, delta);
                                flankenpunkt_oben = kugelev(delta_b, delta+schritt);
                                polyhedron(
                                    points = [
                                        kugel_zu_kart([rg_aussen, delta, flankenpunkt_unten]),
                                        kugel_zu_kart([rg_innen, delta, flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_innen, delta, spiegelpunkt-flankenpunkt_unten+gamma]),
                                        kugel_zu_kart([rg_aussen, delta, spiegelpunkt-flankenpunkt_unten]),                             
                                        kugel_zu_kart([rg_aussen, delta+schritt, flankenpunkt_oben]),
                                        kugel_zu_kart([rg_innen, delta+schritt, flankenpunkt_oben+gamma]),
                                        kugel_zu_kart([rg_innen, delta+schritt, spiegelpunkt-flankenpunkt_oben+gamma]),
                                        kugel_zu_kart([rg_aussen, delta+schritt, spiegelpunkt-flankenpunkt_oben])                                   
                                    ],
                                    faces = [[0,1,2],[0,2,3],[0,4,1],[1,4,5],[1,5,2],[2,5,6],[2,6,3],[3,6,7],[0,3,7],[0,7,4],[4,6,5],[4,7,6]],
                                    convexity =1
                                );
                            }
                        }
                    }
                }   
            }
        }
    }
}

/*  Pfeil-Kegelrad; verwendet das Modul "bevel_gear"
    modul = Höhe des Zahnkopfes über dem Teilkreis
    tooth_number = Anzahl der Radzähne
    teilkegelwinkel, zahnbreite
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel, Standardwert = 0° */
module bevel_arrow_gear(modul, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle = 20, schraegungswinkel=0){

    // Dimensions-Berechnungen
    
    zahnbreite = zahnbreite / 2;
    
    d_aussen = modul * tooth_number;                                // Teilkegeldurchmesser auf der Kegelgrundfläche,
                                                                // entspricht der Sehne im Kugelschnitt
    r_aussen = d_aussen / 2;                                    // Teilkegelradius auf der Kegelgrundfläche 
    rg_aussen = r_aussen/sin(teilkegelwinkel);                  // Großkegelradius, entspricht der Länge der Kegelflanke;
    c = modul / 6;                                              // Kopfspiel
    df_aussen = d_aussen - (modul +c) * 2 * cos(teilkegelwinkel);
    rf_aussen = df_aussen / 2;
    delta_f = asin(rf_aussen/rg_aussen);
    hoehe_f = rg_aussen*cos(delta_f);                           // Höhe des Kegels vom Fußkegel

    // Torsionswinkel gamma aus Schrägungswinkel
    gamma_g = 2*atan(zahnbreite*tan(schraegungswinkel)/(2*rg_aussen-zahnbreite));
    gamma = 2*asin(rg_aussen/r_aussen*sin(gamma_g/2));
    
    echo("Teilkegeldurchmesser auf der Kegelgrundfläche = ", d_aussen);
    
    // Größen für Komplementär-Kegelstumpf
    hoehe_k = (rg_aussen-zahnbreite)/cos(teilkegelwinkel);      // Höhe des Komplementärkegels für richtige Zahnlänge
    rk = (rg_aussen-zahnbreite)/sin(teilkegelwinkel);           // Fußradius des Komplementärkegels
    rfk = rk*hoehe_k*tan(delta_f)/(rk+hoehe_k*tan(delta_f));    // Kopfradius des Zylinders für 
                                                                // Komplementär-Kegelstumpf
    hoehe_fk = rk*hoehe_k/(hoehe_k*tan(delta_f)+rk);            // Hoehe des Komplementär-Kegelstumpfs
    
    modul_innen = modul*(1-zahnbreite/rg_aussen);

        union(){
        bevel_gear(modul, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle, schraegungswinkel);        // untere Hälfte
        translate([0,0,hoehe_f-hoehe_fk])
            rotate(a=-gamma,v=[0,0,1])
                bevel_gear(modul_innen, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle, -schraegungswinkel); // obere Hälfte
    }
}

/*  Spiral-Kegelrad; verwendet das Modul "bevel_gear"
    modul = Höhe des Zahnkopfes über dem Teilkreis
    tooth_number = Anzahl der Radzähne
    hoehe = Höhe des Zahnrads
    bohrung = Durchmesser der Mittelbohrung
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel, Standardwert = 0° */
module spiralkegelrad(modul, tooth_number, teilkegelwinkel, zahnbreite, bohrung, pressure_angle = 20, schraegungswinkel=30){

    schritte = 16;

    // Dimensions-Berechnungen
    
    b = zahnbreite / schritte;  
    d_aussen = modul * tooth_number;                                // Teilkegeldurchmesser auf der Kegelgrundfläche,
                                                                // entspricht der Sehne im Kugelschnitt
    r_aussen = d_aussen / 2;                                    // Teilkegelradius auf der Kegelgrundfläche 
    rg_aussen = r_aussen/sin(teilkegelwinkel);                  // Großkegelradius, entspricht der Länge der Kegelflanke;
    rg_mitte = rg_aussen-zahnbreite/2;

    echo("Teilkegeldurchmesser auf der Kegelgrundfläche = ", d_aussen);

    a=tan(schraegungswinkel)/rg_mitte;
    
    union(){
    for(i=[0:1:schritte-1]){
        r = rg_aussen-i*b;
        schraegungswinkel = a*r;
        modul_r = modul-b*i/rg_aussen;
        translate([0,0,b*cos(teilkegelwinkel)*i])
            
            rotate(a=-schraegungswinkel*i,v=[0,0,1])
                bevel_gear(modul_r, tooth_number, teilkegelwinkel, b, bohrung, pressure_angle, schraegungswinkel);   // obere Hälfte
        }
    }
}

/*  Kegelradpaar mit beliebigem Achsenwinkel; verwendet das Modul "bevel_gear"
    modul = Höhe des Zahnkopfes über dem Teilkegel; Angabe für die Aussenseite des Kegels
    zahnzahl_rad = Anzahl der Radzähne am Rad
    zahnzahl_ritzel = Anzahl der Radzähne am Ritzel
    achsenwinkel = Winkel zwischen den Achsen von Rad und Ritzel
    zahnbreite = Breite der Zähne von der Außenseite in Richtung Kegelspitze
    bohrung_rad = Durchmesser der Mittelbohrung des Rads
    bohrung_ritzel = Durchmesser der Mittelbohrungen des Ritzels
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel, Standardwert = 0°
    zusammen_gebaut = Komponenten zusammengebaut für Konstruktion oder auseinander zum 3D-Druck */
module bevel_gear_pair(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel=90, zahnbreite, bohrung_rad, bohrung_ritzel, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true){
 
    // Dimensions-Berechnungen
    r_rad = modul*zahnzahl_rad/2;                           // Teilkegelradius des Rads
    delta_rad = atan(sin(achsenwinkel)/(zahnzahl_ritzel/zahnzahl_rad+cos(achsenwinkel)));   // Kegelwinkel des Rads
    delta_ritzel = atan(sin(achsenwinkel)/(zahnzahl_rad/zahnzahl_ritzel+cos(achsenwinkel)));// Kegelwingel des Ritzels
    rg = r_rad/sin(delta_rad);                              // Radius der Großkugel
    c = modul / 6;                                          // Kopfspiel
    df_ritzel = pi*rg*delta_ritzel/90 - 2 * (modul + c);    // Fußkegeldurchmesser auf der Großkugel 
    rf_ritzel = df_ritzel / 2;                              // Fußkegelradius auf der Großkugel
    delta_f_ritzel = rf_ritzel/(pi*rg) * 180;               // Kopfkegelwinkel
    rkf_ritzel = rg*sin(delta_f_ritzel);                    // Radius des Kegelfußes
    hoehe_f_ritzel = rg*cos(delta_f_ritzel);                // Höhe des Kegels vom Fußkegel
    
    echo("Kegelwinkel Rad = ", delta_rad);
    echo("Kegelwinkel Ritzel = ", delta_ritzel);
 
    df_rad = pi*rg*delta_rad/90 - 2 * (modul + c);          // Fußkegeldurchmesser auf der Großkugel 
    rf_rad = df_rad / 2;                                    // Fußkegelradius auf der Großkugel
    delta_f_rad = rf_rad/(pi*rg) * 180;                     // Kopfkegelwinkel
    rkf_rad = rg*sin(delta_f_rad);                          // Radius des Kegelfußes
    hoehe_f_rad = rg*cos(delta_f_rad);                      // Höhe des Kegels vom Fußkegel

    echo("Höhe Rad = ", hoehe_f_rad);
    echo("Höhe Ritzel = ", hoehe_f_ritzel);
    
    drehen = istgerade(zahnzahl_ritzel);
    
    // Zeichnung
    // Rad
    rotate([0,0,180*(1-spiel)/zahnzahl_rad*drehen])
        bevel_gear(modul, zahnzahl_rad, delta_rad, zahnbreite, bohrung_rad, pressure_angle, schraegungswinkel);
    
    // Ritzel
    if (zusammen_gebaut)
        translate([-hoehe_f_ritzel*cos(90-achsenwinkel),0,hoehe_f_rad-hoehe_f_ritzel*sin(90-achsenwinkel)])
            rotate([0,achsenwinkel,0])
                bevel_gear(modul, zahnzahl_ritzel, delta_ritzel, zahnbreite, bohrung_ritzel, pressure_angle, -schraegungswinkel);
    else
        translate([rkf_ritzel*2+modul+rkf_rad,0,0])
            bevel_gear(modul, zahnzahl_ritzel, delta_ritzel, zahnbreite, bohrung_ritzel, pressure_angle, -schraegungswinkel);
 }

/*  Pfeil-Kegelradpaar mit beliebigem Achsenwinkel; verwendet das Modul "bevel_arrow_gear"
    modul = Höhe des Zahnkopfes über dem Teilkegel; Angabe für die Aussenseite des Kegels
    zahnzahl_rad = Anzahl der Radzähne am Rad
    zahnzahl_ritzel = Anzahl der Radzähne am Ritzel
    achsenwinkel = Winkel zwischen den Achsen von Rad und Ritzel
    zahnbreite = Breite der Zähne von der Außenseite in Richtung Kegelspitze
    bohrung_rad = Durchmesser der Mittelbohrung des Rads
    bohrung_ritzel = Durchmesser der Mittelbohrungen des Ritzels
    pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
    schraegungswinkel = Schrägungswinkel, Standardwert = 0°
    zusammen_gebaut = Komponenten zusammengebaut für Konstruktion oder auseinander zum 3D-Druck */
module bevel_arrow_gear_pair(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel=90, zahnbreite, bohrung_rad, bohrung_ritzel, pressure_angle = 20, schraegungswinkel=10, zusammen_gebaut=true){
 
    r_rad = modul*zahnzahl_rad/2;                           // Teilkegelradius des Rads
    delta_rad = atan(sin(achsenwinkel)/(zahnzahl_ritzel/zahnzahl_rad+cos(achsenwinkel)));   // Kegelwinkel des Rads
    delta_ritzel = atan(sin(achsenwinkel)/(zahnzahl_rad/zahnzahl_ritzel+cos(achsenwinkel)));// Kegelwingel des Ritzels
    rg = r_rad/sin(delta_rad);                              // Radius der Großkugel
    c = modul / 6;                                          // Kopfspiel
    df_ritzel = pi*rg*delta_ritzel/90 - 2 * (modul + c);    // Fußkegeldurchmesser auf der Großkugel 
    rf_ritzel = df_ritzel / 2;                              // Fußkegelradius auf der Großkugel
    delta_f_ritzel = rf_ritzel/(pi*rg) * 180;               // Kopfkegelwinkel
    rkf_ritzel = rg*sin(delta_f_ritzel);                    // Radius des Kegelfußes
    hoehe_f_ritzel = rg*cos(delta_f_ritzel);                // Höhe des Kegels vom Fußkegel
    
    echo("Kegelwinkel Rad = ", delta_rad);
    echo("Kegelwinkel Ritzel = ", delta_ritzel);
 
    df_rad = pi*rg*delta_rad/90 - 2 * (modul + c);          // Fußkegeldurchmesser auf der Großkugel 
    rf_rad = df_rad / 2;                                    // Fußkegelradius auf der Großkugel
    delta_f_rad = rf_rad/(pi*rg) * 180;                     // Kopfkegelwinkel
    rkf_rad = rg*sin(delta_f_rad);                          // Radius des Kegelfußes
    hoehe_f_rad = rg*cos(delta_f_rad);                      // Höhe des Kegels vom Fußkegel

    echo("Höhe Rad = ", hoehe_f_rad);
    echo("Höhe Ritzel = ", hoehe_f_ritzel);
    
    drehen = istgerade(zahnzahl_ritzel);
    
    // Rad
    rotate([0,0,180*(1-spiel)/zahnzahl_rad*drehen])
        bevel_arrow_gear(modul, zahnzahl_rad, delta_rad, zahnbreite, bohrung_rad, pressure_angle, schraegungswinkel);
    
    // Ritzel
    if (zusammen_gebaut)
        translate([-hoehe_f_ritzel*cos(90-achsenwinkel),0,hoehe_f_rad-hoehe_f_ritzel*sin(90-achsenwinkel)])
            rotate([0,achsenwinkel,0])
                bevel_arrow_gear(modul, zahnzahl_ritzel, delta_ritzel, zahnbreite, bohrung_ritzel, pressure_angle, -schraegungswinkel);
    else
        translate([rkf_ritzel*2+modul+rkf_rad,0,0])
            bevel_arrow_gear(modul, zahnzahl_ritzel, delta_ritzel, zahnbreite, bohrung_ritzel, pressure_angle, -schraegungswinkel);

}

/*
Archimedean screw.
modul = Höhe des Schneckenkopfes über dem Teilzylinder
gangzahl = Anzahl der Gänge (Zähne) der Schnecke
length = Länge der Schnecke
bohrung = Durchmesser der Mittelbohrung
pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
steigungswinkel = Steigungswinkel der Schnecke, entspricht 90° minus Schrägungswinkel. Positiver Steigungswinkel = rechtsdrehend.
zusammen_gebaut = Komponenten zusammengebaut für Konstruktion oder auseinander zum 3D-Druck */
module worm(modul, gangzahl, length, bohrung, pressure_angle=20, steigungswinkel, zusammen_gebaut=true){

    // Dimensions-Berechnungen
    c = modul / 6;                                              // Kopfspiel
    r = modul*gangzahl/(2*sin(steigungswinkel));                // Teilzylinder-Radius
    rf = r - modul - c;                                         // Fußzylinder-Radius
    a = modul*gangzahl/(90*tan(pressure_angle));               // Spiralparameter
    tau_max = 180/gangzahl*tan(pressure_angle);                // Winkel von Fuß zu Kopf in der Normalen
    gamma = -rad*length/((rf+modul+c)*tan(steigungswinkel));    // Torsionswinkel für Extrusion
    
    schritt = tau_max/16;
    
    // Zeichnung: extrudiere mit Verwindung eine Flaeche, die von zwei archimedischen Spiralen eingeschlossen wird
    if (zusammen_gebaut) {
        rotate([0,0,tau_max]){
            linear_extrude(height = length, center = false, convexity = 10, twist = gamma){
                difference(){
                    union(){
                        for(i=[0:1:gangzahl-1]){
                            polygon(
                                concat(                         
                                    [[0,0]],
                                    
                                    // ansteigende Zahnflanke
                                    [for (tau = [0:schritt:tau_max])
                                        pol_zu_kart([spirale(a, rf, tau), tau+i*(360/gangzahl)])],
                                        
                                    // Zahnkopf
                                    [for (tau = [tau_max:schritt:180/gangzahl])
                                        pol_zu_kart([spirale(a, rf, tau_max), tau+i*(360/gangzahl)])],
                                    
                                    // absteigende Zahnflanke
                                    [for (tau = [180/gangzahl:schritt:(180/gangzahl+tau_max)])
                                        pol_zu_kart([spirale(a, rf, 180/gangzahl+tau_max-tau), tau+i*(360/gangzahl)])]
                                )
                            );
                        }
                        circle(rf);
                    }
                    circle(bohrung/2); // Mittelbohrung
                }
            }
        }
    }
    else {
        difference(){
            union(){
                translate([1,r*1.5,0]){
                    rotate([90,0,90])
                        worm(modul, gangzahl, length, bohrung, pressure_angle, steigungswinkel, zusammen_gebaut=true);
                }
                translate([length+1,-r*1.5,0]){
                    rotate([90,0,-90])
                        worm(modul, gangzahl, length, bohrung, pressure_angle, steigungswinkel, zusammen_gebaut=true);
                    }
                }
            translate([length/2+1,0,-(r+modul+1)/2]){
                    cube([length+2,3*r+2*(r+modul+1),r+modul+1], center = true);
                }
        }
    }
}

/*
Calculates a worm wheel set. The worm wheel is an ordinary spur gear without globoidgeometry.
modul = Height of the screw head above the partial cylinder or the tooth head above the pitch circle
tooth_number = Number of wheel teeth
gangzahl = Number of gears (teeth) of the screw
width = Zahnbreite
length = Länge der Schnecke
bohrung_schnecke = Durchmesser der Mittelbohrung der Schnecke
bohrung_rad = Durchmesser der Mittelbohrung des Stirnrads
pressure_angle = Eingriffswinkel, Standardwert = 20° gemäß DIN 867. Sollte nicht größer als 45° sein.
steigungswinkel = Pitch angle of the worm corresponds to 90 ° bevel angle. Positive slope angle = clockwise.
optimized = Holes for material / weight savings
zusammen_gebaut =  Components assembled for construction or apart for 3D printing */
module worm_gear(modul, tooth_number, gangzahl, width, length, bohrung_schnecke, bohrung_rad, pressure_angle=20, steigungswinkel, optimized=true, zusammen_gebaut=true, show_spur=1, show_worm=1){
    
    c = modul / 6;                                              // Kopfspiel
    r_schnecke = modul*gangzahl/(2*sin(steigungswinkel));       // Teilzylinder-Radius Schnecke
    r_rad = modul*tooth_number/2;                                   // Teilkegelradius Stirnrad
    rf_schnecke = r_schnecke - modul - c;                       // Fußzylinder-Radius
    gamma = -90*width*sin(steigungswinkel)/(pi*r_rad);         // Rotationswinkel Stirnrad
    zahnabstand = modul*pi/cos(steigungswinkel);                // Zahnabstand im Transversalschnitt
    x = istgerade(gangzahl)? 0.5 : 1;

    if (zusammen_gebaut) {
        if(show_worm)
        translate([r_schnecke,(ceil(length/(2*zahnabstand))-x)*zahnabstand,0])
            rotate([90,180/gangzahl,0])
                worm(modul, gangzahl, length, bohrung_schnecke, pressure_angle, steigungswinkel, zusammen_gebaut);

        if(show_spur)
        translate([-r_rad,0,-width/2])
            rotate([0,0,gamma])
                spur_gear (modul, tooth_number, width, bohrung_rad, pressure_angle, -steigungswinkel, optimized);
    }
    else {  
        if(show_worm)
        worm(modul, gangzahl, length, bohrung_schnecke, pressure_angle, steigungswinkel, zusammen_gebaut);

        if(show_spur)
        translate([-2*r_rad,0,0])
            spur_gear (modul, tooth_number, width, bohrung_rad, pressure_angle, -steigungswinkel, optimized);
    }
}

// rack(modul=1, length=30, hoehe=5, width=5, pressure_angle=20, schraegungswinkel=20);

//spur_gear (modul=1, tooth_number=30, width=5, bohrung=4, pressure_angle=20, schraegungswinkel=20, optimized=true);

//arrow_gear (modul=1, tooth_number=30, width=5, bohrung=4, pressure_angle=20, schraegungswinkel=30, optimized=true);

//zahnstange_und_rad (modul=1, laenge_stange=50, zahnzahl_rad=30, hoehe_stange=4, bohrung_rad=4, width=5, pressure_angle=20, schraegungswinkel=0, zusammen_gebaut=true, optimized=true);

//ring_gear (modul=1, tooth_number=30, width=5, randbreite=3, pressure_angle=20, schraegungswinkel=20);

// arrow_ring_gear (modul=1, tooth_number=30, width=5, randbreite=3, pressure_angle=20, schraegungswinkel=30);

//planetary_gear(modul=1, zahnzahl_sonne=16, zahnzahl_planet=9, anzahl_planeten=5, width=5, randbreite=3, bohrung=4, pressure_angle=20, schraegungswinkel=30, zusammen_gebaut=true, optimized=true);

//bevel_gear(modul=1, tooth_number=30,  teilkegelwinkel=45, zahnbreite=5, bohrung=4, pressure_angle=20, schraegungswinkel=20);

// bevel_arrow_gear(modul=1, tooth_number=30, teilkegelwinkel=45, zahnbreite=5, bohrung=4, pressure_angle=20, schraegungswinkel=30);

// bevel_gear_pair(modul=1, zahnzahl_rad=30, zahnzahl_ritzel=11, achsenwinkel=100, zahnbreite=5, bohrung=4, pressure_angle = 20, schraegungswinkel=20, zusammen_gebaut=true);

// bevel_arrow_gear_pair(modul=1, zahnzahl_rad=30, zahnzahl_ritzel=11, achsenwinkel=100, zahnbreite=5, bohrung=4, pressure_angle = 20, schraegungswinkel=30, zusammen_gebaut=true);

// worm(modul=1, gangzahl=2, length=15, bohrung=4, pressure_angle=20, steigungswinkel=10, zusammen_gebaut=true);

worm_gear(modul=1, tooth_number=30, gangzahl=2, width=8, length=20, bohrung_schnecke=4, bohrung_rad=4, pressure_angle=20, steigungswinkel=10, optimized=1, zusammen_gebaut=1, show_spur=1, show_worm=1);
