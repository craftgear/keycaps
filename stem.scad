$fs=0.01;

module stem_cutout(stem_height) {
    stem_cross_length = 4.0;
    stem_cross_horizontal = 1.25;
    stem_cross_vertical = 1.10;
    
    module horizontal() {
        translate([0,0,stem_height/2])
        cube([stem_cross_horizontal, stem_cross_length,15], center=true);
    }
    
    module vertical () {
        translate([0,0,stem_height/2])
        cube([stem_cross_length, stem_cross_vertical,15], center=true);
    }

    union() {
        horizontal();
        vertical();
    };
}

module stem(stem_height) {
    stem_diameter=5.5;
    difference() {
        cylinder(d=stem_diameter, h=stem_height);
        stem_cutout(stem_height);
    };
}

stem(15);