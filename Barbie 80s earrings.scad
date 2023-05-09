$fn = 32; 

// Triangle parameters
triangle_side = 30;
thickness = 3.5;

// Confetti parameters
confetti_length = 4;
confetti_width = 1;
circle_radius = 0.5;

// Ring parameters
outer_ring_radius = 14;
outer_ring_radius_smaller = 7;
ring_thickness = 5.5;

// Cylinder parameters
cylinder_height = ring_thickness*1.4;
cylinder_radius = 2;

// Functions and modules
module equilateral_triangle(side) {
  //  polygon(points=[[0, 0], [side, 0], [side / 2, side * sqrt(3) / 2]]);
    
    hull(){      
        translate([0, 0]) circle(r = circle_radius);
        
        translate([side, 0]) circle(r = circle_radius);

         translate([side / 2, side * sqrt(3) / 2]) circle(r = circle_radius);
    }
  
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
    
    scale([1, 1, 0.8]){
        
                rotate_extrude(convexity = 10) translate([outer_ring_radius_smaller, 0, 0]) circle(r = ring_thickness / 2);
    
    translate([0, outer_ring_radius+ ring_thickness*1.3 + outer_ring_radius_smaller / 2, 0]) {
    
        rotate_extrude(convexity = 10) translate([outer_ring_radius, 0, 0]) circle(r = ring_thickness / 2);
 
    }
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

module extruded_triangle_with_confettis(){
    
    // from bottom to top
    // [x, y, angle]
    confetti_coordinates = [
      
        [triangle_side / 2.5, triangle_side * sqrt(3) / 2.8, 60],
        [2 * triangle_side / 3.5, triangle_side * sqrt(3) / 3, 45],

        [triangle_side / 3, triangle_side * sqrt(3) / 4, 315],
        [triangle_side / 2, triangle_side * sqrt(3) / 4, 100],
        [3 * triangle_side / 4.5, triangle_side * sqrt(3) / 4, 80],

        [triangle_side / 4, triangle_side * sqrt(3) / 12, 45],
        [triangle_side / 2, triangle_side * sqrt(3) / 12, 20],
        [3 * triangle_side / 4, triangle_side * sqrt(3) / 12, 70],

    ];
    
    extruded_triangle();

    for (coord = confetti_coordinates) {
    x = coord[0];
    y = coord[1];
    angle = coord[2];
    translate([x, y, thickness]) rotate([0, 0, angle]) extruded_confetti();

    }
    
    }



// Assembled object


connection_point = [triangle_side / 2, triangle_side * sqrt(3) / 9, -cylinder_height / 2.4];

module assembled_earrings() {
      
    difference(){
        extruded_triangle_with_confettis();
        translate(connection_point) {
            connecting_cylinder_hollow();
        }       
        }

    
    translate(connection_point) {
        #connecting_cylinder();
        
        translate([0, outer_ring_radius_smaller- ring_thickness/1.2, 0]) extruded_rings();
    }
}


// Separated pieces

module parts_earrings() {
     
    difference(){
        extruded_triangle_with_confettis();
        translate(connection_point) {
            connecting_cylinder_hollow();
        }       
        }

        translate([50, 50, 0]) {
            extruded_rings();
        }

        translate([50, 100, 0]) {
            connecting_cylinder();
        }
    }


translate([-triangle_side / 2, -triangle_side * sqrt(3) / 6, 0]) {
assembled_earrings();
}

 translate([50, 0, 0]) {
parts_earrings();
 }