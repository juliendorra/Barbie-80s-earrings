$fn = 32; 

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
cylinder_radius = 2;

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
    translate([0, 0, -cylinder_height / 2]) cylinder(h = ring_thickness/2, r = outer_ring_radius*0.6, center = true);
}

module connecting_cylinder_hollow() {
    cylinder(h = cylinder_height, r = cylinder_radius, center = true);
}

// Assembly
translate([-triangle_side / 2, -triangle_side * sqrt(3) / 6, 0]) {
    
    #difference(){
        extruded_triangle();
        translate([triangle_side / 2, triangle_side * sqrt(3) / 6, -cylinder_height / 2.4]) {
            connecting_cylinder_hollow();
        }       
        }
    
    // from bottom to top
    // 
    // 6 7
    // 3 4 5
    // 0 1 2
    //
    // [x, y, angle]
    confetti_coordinates = [
        [triangle_side / 4, triangle_side * sqrt(3) / 12, 30], // left most bottom
        [triangle_side / 2, triangle_side * sqrt(3) / 12, 20],
    
        [3 * triangle_side / 4, triangle_side * sqrt(3) / 12, 45],
        [triangle_side / 3, triangle_side * sqrt(3) / 4, 315],
        [triangle_side / 2, triangle_side * sqrt(3) / 4, 100],
    
        [3 * triangle_side / 4.5, triangle_side * sqrt(3) / 4, 120],
        [triangle_side / 2.5, triangle_side * sqrt(3) / 2.8, 70],
        [2 * triangle_side / 3.5, triangle_side * sqrt(3) / 3, 45]
    ];
    
    for (coord = confetti_coordinates) {
        x = coord[0];
        y = coord[1];
        angle = coord[2];
        translate([x, y, thickness]) rotate([0, 0, angle]) extruded_confetti();

    }
    
    translate([triangle_side / 2, triangle_side * sqrt(3) / 6, -ring_thickness]) extruded_rings();
    
    translate([triangle_side / 2, triangle_side * sqrt(3) / 6, -cylinder_height / 2.4]) connecting_cylinder();
}
