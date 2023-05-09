$fn = 32; 

// Triangle parameters

thickness = 4.5;
circle_radius = 1.2;
triangle_side = 30 - circle_radius;

// Confetti parameters
confetti_length = 5.2;
confetti_circle_radius = 0.9;

// Rings parameters
outer_ring_radius = 16;
ring_thickness = 5.5;

outer_ring_radius_smaller = 5.5;
ring_thickness_smaller = 4.5;


// Cylinder parameters
cylinder_height = ring_thickness_smaller*1.8;
cylinder_radius = 2;

// Functions and modules
module equilateral_triangle(side) {
    
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
        translate([-confetti_length / 2 + confetti_circle_radius, 0]) circle(r = confetti_circle_radius);
        translate([confetti_length / 2 - confetti_circle_radius, 0]) circle(r = confetti_circle_radius);
    }
}


module extruded_confetti() {
    linear_extrude(height = thickness/3) confetti();
}

module extruded_rings() {
    
    scale([1, 1, 0.8]){
        
        rotate_extrude(convexity = 10) translate([outer_ring_radius_smaller, 0, 0]) circle(r = ring_thickness_smaller / 2);
    
        translate([0, outer_ring_radius+ ring_thickness_smaller*1.2 + outer_ring_radius_smaller / 2, 0]) {
    
        rotate_extrude(convexity = 10) translate([outer_ring_radius, 0, 0]) circle(r = ring_thickness / 2);
 
    }
  }
    
}


module connecting_cylinder() {
    cylinder(h = cylinder_height, r = cylinder_radius, center = true);
    translate([0, 0, -cylinder_height / 2]) cylinder(h = ring_thickness/3, r = outer_ring_radius_smaller*1.1, center = true);
}

module connecting_cylinder_hollow() {
    cylinder(h = cylinder_height, r = cylinder_radius, center = true);
}

// Assembly

module extruded_triangle_with_confettis(){
    
    // from bottom to top
    // [x, y, angle]
    confetti_coordinates = [
    
    
        [triangle_side / 1.25, triangle_side * sqrt(3) / 14, 315], 
        [triangle_side / 2.2, triangle_side * sqrt(3) / 14, 315],
        [triangle_side / 5, triangle_side * sqrt(3) / 21, 0],



         [3 * triangle_side / 4.9, triangle_side * sqrt(3) / 6, 45],
         [triangle_side / 2.3, triangle_side * sqrt(3) / 4.5, 90],    
         [triangle_side / 4, triangle_side * sqrt(3) / 5.8, 230],

    
        [2 * triangle_side / 3.5, triangle_side * sqrt(3) / 3.5, 315],
        
        [triangle_side / 2.1, triangle_side * sqrt(3) / 2.5, 45],


    ];
    
    extruded_triangle();

    for (coord = confetti_coordinates) {
    x = coord[0];
    y = coord[1];
    angle = coord[2];
    translate([x, y, thickness]) rotate([0, 0, angle]) #extruded_confetti();

    }
    
    }



// Assembled object


connection_point = [triangle_side / 2, triangle_side * sqrt(3) / 9, -cylinder_height *0.2];

module assembled_earrings() {
      
   # difference(){
        extruded_triangle_with_confettis();
        translate(connection_point) {
            connecting_cylinder_hollow();
        }       
        }

    
    translate(connection_point) {
        connecting_cylinder();
        
        translate([0, outer_ring_radius_smaller- ring_thickness_smaller/1.2, connection_point[2]/2]) extruded_rings();
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

     translate([triangle_side/2, 50, 0]) {
            extruded_rings();
        }

     translate([triangle_side/2,, 120, 0]) {
            connecting_cylinder();
        }
    }


translate([-triangle_side / 2, -triangle_side * sqrt(3) / 6, 0]) {
assembled_earrings();
}

 translate([50, 0, 0]) {
parts_earrings();
 }