use <stem.scad>;


 $fs = 0.1;
 $fa = 5;

module rounded_cube(size, r) {
  divide_unit = 0.5;
	hull() {
		cube([size[0] - radius*2, size[1] - r*2, size[2]] - r, center = true);
        translate([ - ( size[0]/2 - r ), - ( size[1]/2 - r ), 0])
            sphere(r = radius, h = 0.1, $fs = divide_unit);
        translate([size[0]/2 - r, - ( size[1]/2 - r ) , 0])
            sphere(r = radius, h = 0.1, $fs = divide_unit);
        translate([- ( size[0]/2 - r ), size[1]/2 - r  , 0])
            sphere(r = radius, h = 0.1, $fs = divide_unit);
        translate([ size[0]/2 - r, size[1]/2 - r  , 0])
            sphere(r = radius, h = 0.1, $fs = divide_unit);
	}
}


module rounded_square(size, r) {
  divide_unit = 0.5;
	hull() {
		cube([size[0] - radius * 2, size[1] - r * 2, size[2]], center = true);
        translate([ - ( size[0]/2 - r ), - ( size[1]/2 - r ), 0])
            cylinder(r = radius, h = 0.1, $fs = divide_unit);
        translate([size[0]/2 - r, - ( size[1]/2 - r ) , 0])
            cylinder(r = radius, h = 0.1, $fs = divide_unit);
        translate([- ( size[0]/2 - r ), size[1]/2 - r  , 0])
            cylinder(r = radius, h = 0.1, $fs = divide_unit);
        translate([ size[0]/2 - r, size[1]/2 - r  , 0])
            cylinder(r = radius, h = 0.1, $fs = divide_unit);
	}
}



module outer_shape(top_side, bottom_side, height) {
  tilt = 14;
  dish_depth = 2;
	
  module trapezoid() {
       hull() {
        translate([0,0,height]) {
          rounded_cube([top_side, top_side, top_shape_thickness], 2);
        };
        rounded_square([bottom_side, bottom_side, 0.01], 2.5);
      };
  }
	
  trapezoid();
}

module inner_shape(top_side, bottom_side, height, wall_thickness) {
	hull() {
		translate([0,0,height - wall_thickness]) {
			rounded_cube([top_side - wall_thickness * 1.5, top_side - wall_thickness * 1.5 , 0.01], 5);
		};
		rounded_square([bottom_side - wall_thickness * 2, bottom_side - wall_thickness * 2, 0.01], 2.5);
	}
}

module keycap(height, width_multiplier = 1) {
	top_square_side = 14;
	bottom_square_side = 18;
	wall_thickness = 1.5;
    stem_height = 4;
	difference() {
      outer_shape(top_square_side * width_multiplier, bottom_square_side, height);
      inner_shape(bottom_square_side * width_multiplier, bottom_square_side, stem_height, wall_thickness);
      translate([bottom_square_side / 2, bottom_square_side / 2,0])
      cube([bottom_square_side * width_multiplier, bottom_square_side, 20], center = true);
	};
}

keycap(8);

