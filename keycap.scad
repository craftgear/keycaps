use <stem.scad>;

$fs = 0.1;
$fa = 5;

debug = false;

module rounded_cube(size, r) {
  divide_unit = 0.5;
  hull() {
      cube([size[0] - radius*2, size[1] - r*2, size[2]] - r, center = true);
      translate([ - ( size[0]/2 - r ), - ( size[1]/2 - r ), 0])
          sphere(r = radius, h = 0.1, center=true);
      translate([size[0]/2 - r, - ( size[1]/2 - r ) , 0])
          sphere(r = radius, h = 0.1, center=true);
      translate([- ( size[0]/2 - r ), size[1]/2 - r  , 0])
          sphere(r = radius, h = 0.1, center=true);
      translate([ size[0]/2 - r, size[1]/2 - r  , 0])
          sphere(r = radius, h = 0.1, center=true);
  }
}


module rounded_square(width, height, radius) {
  thickness = 0.01;
  divide_unit = 0.5;
  
  union() {
	  cube([width - radius * 2, height - radius * 2, thickness], center = true);
      translate([-( width/2 - radius ), - ( height/2 - radius ), 0])
          cylinder(r = radius, h = thickness, center=true);
      translate([width/2 - radius, - ( height/2 - radius ) , 0])
          cylinder(r = radius, h =thickness, center=true);
      translate([- ( width/2 - radius ), height/2 - radius  , 0])
          cylinder(r = radius, h =thickness, center=true);
      translate([ width/2 - radius, height/2 - radius  , 0])
          cylinder(r = radius, h =thickness, center=true);
  }
}



module outer_shape(top_side, bottom_side, height) {
  tilt = 14;
  dish_depth = 2;
	
  hull() {
    translate([0,0,height]) {
      rounded_cube([top_side, top_side, top_shape_thickness], 2);
    };
    rounded_square(bottom_side, bottom_side, 2.5);
  };
}

module inner_shape(top_side, bottom_side, stem_height, wall_thickness) {
  hull() {
    translate([0,0,stem_height]) {
      rounded_cube([top_side, top_side , 0.0001], 2.5);
    };
    rounded_square(bottom_side - wall_thickness * 2, bottom_side - wall_thickness * 2, 0.0001, 2.5);
  }
}

module keycap(height) {
	top_square_side = 14;
	bottom_square_side = 18;
	wall_thickness = 1.5;
    stem_height = height / 2;
	difference() {
      outer_shape(top_square_side, bottom_square_side, height);
      inner_shape(top_square_side , bottom_square_side, stem_height, wall_thickness);
      if(debug) {
        translate([bottom_square_side / 2, bottom_square_side / 2,0])
          cube([bottom_square_side , bottom_square_side, 20], center = true);
      }
	};
}

keycap(4);
stem(4);


