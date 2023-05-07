// Triangle parameters
triangle_side = 30;
thickness = 2;

// Confetti parameters
confetti_length = 4;
confetti_width = 1;
circle_radius = 0.5;

// Ring parameters
outer_ring_radius = 10;
inner_ring_radius = 5;
ring_thickness = 2;

// Cylinder parameters
cylinder_height = 5;
cylinder_radius = 1;

// Functions and modules
module equilateral_triangle(side) {
    polygon(points=[[0, 0], [side, 0], [side / 2, side * sqrt(3) / 2]]);
}

module extruded_triangle() {
    linear_extrude(height = thickness) equilateral_triangle(triangle_side);
}

module confetti() {
    hull() {
        translate([-confetti_length / 2 + circle_radius, 0]) circle(r = circle_radius);
        translate([confetti_length / 2 - circle_radius, 0]) circle(r = circle_radius);
    }
}


module extruded_confetti() {
    linear_extrude(height = thickness/3) confetti();
}

module extruded_rings() {

        rotate_extrude(convexity = 10) translate([outer_ring_radius*0.5, 0, 0]) circle(r = ring_thickness / 2);
    
    translate([outer_ring_radius*1.5+ ring_thickness / 2, 0, 0]) {
    
        rotate_extrude(convexity = 10) translate([outer_ring_radius, 0, 0]) circle(r = ring_thickness / 2);
 
    }
    
}


module connecting_cylinder() {
    cylinder(h = cylinder_height, r = cylinder_radius, center = true);
}

// Assembly
translate([-triangle_side / 2, -triangle_side * sqrt(3) / 6, 0]) {
    #extruded_triangle();
    
    confetti_coordinates = [
      [triangle_side / 2, triangle_side * sqrt(3) / 6],
        [triangle_side / 4, triangle_side * sqrt(3) / 4],
        [3 * triangle_side / 4, triangle_side * sqrt(3) / 4],
        [triangle_side / 6, triangle_side * sqrt(3) / 6],
        [triangle_side / 2, triangle_side * sqrt(3) / 6],
        [5 * triangle_side / 6, triangle_side * sqrt(3) / 6],
        [triangle_side / 3, triangle_side * sqrt(3) / 3],
        [2 * triangle_side / 3, triangle_side * sqrt(3) / 3]
    ];
    
    for (coord = confetti_coordinates) {
        x = coord[0];
        y = coord[1];
        translate([x, y, thickness]) rotate([0, 0, 45]) extruded_confetti();

    }
    
    translate([triangle_side / 2, triangle_side * sqrt(3) / 6, -ring_thickness]) extruded_rings();
    
    translate([triangle_side / 2, triangle_side * sqrt(3) / 6, -cylinder_height / 2]) connecting_cylinder();
}
