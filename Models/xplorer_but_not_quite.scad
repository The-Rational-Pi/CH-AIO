points_2 = [
[0,0],
[115,44.5],
[265.75,15.5],
[215,90],
[220,103],
[220,149],
[185,183],
[110.5,169],
[-(96.25+2*sqrt(2)),265+2*sqrt(2)]
];



strum_midline_x = 100;
strum_midline_y = 103+(149-103)/2;
  
points = [for (i=points_2) [i.x-strum_midline_x, i.y-strum_midline_y]];

points_x = [for (i=points) i[0]];
points_y = [for (i=points) i[1]];
  
echo(points_2);

body_height = 30;
rounding_r = 10;
shell_thickness = 3;


//how far the neck extends into the body
neck_in_body = 37;
neck_len_1 = 233;
frets_len = 118;
neck_thickness = 30;
w1 = 44;
w2 = 37;
w3 = 35;
neck_start_x = 120;
face_screw_vertices = [0,1,2,3,6,8];
body_chop_x = -50;

bds = [min(points_x),max(points_x),min(points_y),max(points_y)];
w = max(points_x) - min(points_x) + 2*rounding_r;
h = max(points_y) - min(points_y) + 2*rounding_r;
back_edge_angle = atan((points[8].x-points[0].x)/(points[8].y-points[0].x));

buttons_c_to_c = 24;
choc_travel = 28;
strum_v_space = 19;

bbox=[[bds[0],bds[2]],[bds[1],bds[2]],[bds[1],bds[3]],[bds[0],bds[3]]];

module hemisphere(r) {
  difference(){
    sphere(r);
    translate([0,0,-r]){
      cube(2*r,center=true);
    }
  }
}

module halfcylinder(h,r) {
  difference(){
    rotate([90,0,0]){
      cylinder(h=h,r=r);
    }
    translate([0,0,-r]){
      cube(2*r,center=true);
    }
  }
}

module top_plate(){
difference(){
    union(){
        difference(){
                linear_extrude(height=5){
                    offset(r=5){
                        polygon(points);                  
                    }
                }
            translate([-20-strum_midline_x,120-strum_midline_y,2]){
                rotate([0,0,20]){
                    union(){
                        minkowski(){
                            cube([37,85,3],center=false);
                            translate([0,0,3]){
                                sphere(3,$fn=10);
                            }
                        }
                        translate([37/2,85/2,0]){
                            cylinder(3,1,$fn=30,center=true);
                            cylinder(5,2.5,$fn=20,center=true);
                            translate([10,-25,0]){
                                cylinder(5,5,$fn=20,center=true);
                            }
                            translate([-10,-25,0]){
                                cylinder(5,5,$fn=20,center=true);
                            }
                            translate([0,25,0]){
                                cylinder(5,7.5,$fn=20,center=true);
                            }
                        }
                    }
                }
            }
            translate([10-strum_midline_x,15-strum_midline_y,0]){
              rotate([0,0,20]){                
                    cube([34,16,30]);
                }
            }
        }
        translate([-35,-15,5]){
            difference(){
                union(){
                    minkowski(){
                        cube([70,30,3]);
                        translate([0,0,-3]){
                            sphere(3,$fn=10);
                        }
                    }
                    translate([35,15,0]){
                        translate([25,0,0]){
                            rotate([0,90,0]){
                                cylinder(10,8,3,$fn=20);
                            }
                        }
                        translate([-25,0,0]){
                            rotate([0,-90,0]){
                                cylinder(10,8,3,$fn=20);
                            }
                        }
                    }
                }
                translate([0,0,-10]){
                    cube([300,300,20],center=true);
                }
            }
        }
    }
      union(){
          cube([50,18,40],center=true);
      }    
  }
}
 
module body_solid_rounded(){
  minkowski(){
    linear_extrude(height=body_height){
        polygon(points);
    }
    sphere(10,$fn=10);
  }
}

module bottom_shell(){
    difference(){
        body_solid_rounded();
        translate([0,0,-5.1]){
            linear_extrude(height=body_height+15.1){
                offset(r=5){
                    polygon(points);
                }
            }
        }
    }
}
//module bottom_shell(){
//  difference(){
//      minkowski(){
//        linear_extrude(height=body_height){
//          polygon(points);
//        }
//        sphere(10,$fn=10);
//      }
//      minkowski(){
//        linear_extrude(height=body_height+20){
//          polygon(points);
//        }
//        sphere(4,$fn=10);
//      }
//    }
//}


module neck_1_top(l,w1,w2){
  d = 3;
  
  linear_extrude(d){
    polygon([
      [0,-w1/2],
      [l,-w2/2],
      [l,w2/2],
      [0,w1/2]
    ]);
  }
}

module neck_bottom(l,t,w1,w2){
  minkowski(){
    union(){
      translate([27,0,0]){
        neck_1_top(neck_len_1-27,w1,w2);
      }
      translate([0,-w1/2,0]){
        cube([27,w1,3]);
      }
    }
    rotate([0,180,90]){
      resize([t/2+1.5,0,0],[true,false,false]){
        halfcylinder(0.01,t,$fn=40);
      }
    }
  }
}

module neck_shell(l,t,w1,w2){
  difference() {
    neck_bottom(neck_len_1,27,w1-t/2,w2-t/2);
    neck_bottom(neck_len_1,24,w1-t/2-3,w2-t/2-3);    
  }
}

module frets_top(l,w1,w2){
  d = 03;
  fret_spacing = 06;
  fret_h = 24.4; //2.36 measured
  fret_w = 17.5;
  
  difference(){
    linear_extrude(d){
    polygon([
      [0,-w1/2],
      [l,-w2/2],
      [l,w2/2],
      [0,w1/2]
    ]);
    }
    for (i=[0:4]) {
      translate([i*fret_w + (i+1/2)*fret_spacing,-fret_h/2,0]){
        cube([fret_w,fret_h,6]);
      }
    }
  }  
}

module frets_bottom(l,t,w1,w2){
  minkowski(){
    union(){
      neck_1_top(l,w1,w2);
    }
    rotate([0,180,90]){
      resize([t/2+1.5,0,0],[true,false,false]){
        halfcylinder(0.01,t,$fn=40);
      }
    }
  }
}

module frets_shell(l,t,w1,w2){
  difference() {
    frets_bottom(frets_len,27,w1-t/2,w2-t/2);
    frets_bottom(frets_len,24,w1-t/2-shell_thickness,w2-t/2-shell_thickness);    
  }
}

module screw_post(size){
  difference(){
    cylinder(h=body_height+rounding_r,d=size,center=false);
    cylinder(h=body_height+rounding_r,d=size-5,center=false);
  }
}

module body_shell_final(){
  union(){
    difference(){
      bottom_shell();
      translate([0,0,body_height+5]){
          top_plate();
      }
      for (i = face_screw_vertices){
        translate(points[i]){
          cylinder(h=body_height+rounding_r/2,d=1,$fn=20,center=false);
        }
      }
    }
    translate([0,0,-5]){
      for (i = face_screw_vertices){
        translate(points[i]){
          screw_post(10, $fn=20);
        }
      }
    }
    intersection(){
      union(){
        dx = points_x[1] - points_x[0];
        dy = points_y[1] - points_y[0];
        theta = atan(dy/dx);
        translate([-65,-121,-5]){
          cube([body_height, body_height+5, body_height+10]);
        }
        dx2 = points_x[8] - points_x[7];
        dy2 = points_y[8] - points_y[7];
        theta2 = atan(dy2/dx2);
        tx = points_x[7]-55*cos(theta2);
        ty = points_y[7]-55*sin(theta2)-20;
        translate([-65,ty,-5]){
          cube([body_height, body_height+10, body_height+10]);
        }
    }
    body_solid_rounded();
  }
}
}


module face_plate_final(){
  translate([0,0,body_height+3]){
   difference(){
     top_plate();
     for (i=face_screw_vertices) {
       translate(points[i]){
        cylinder(h=5,d=3,$fn=20,center=false);
         translate([0,0,2]){
           cylinder(h=4,d=5,$fn=20,center=false);
         }
       }
     }
   }
 }
}

module vim3(){
  translate([ -41.245 , -29.049 , -6.649 ]){
    translate([ 197.337 , -16.756 , -46.643 ]){
      import("VIM3-simplified.stl");
    }
  }
}

module chocswitch(){
  import("ChocSwitch.stl");
}

//body_split
intersection(){
  translate([body_chop_x,-500,-500]){
    cube(1000);
  }
  body_shell_final();
}
 
translate([0,0,0]){
  difference(){
    body_shell_final();
    translate([body_chop_x,-500,-500]){
      cube(1000);
    }   
  }
}

translate([-100,0,0]){
  rotate([0,0,-back_edge_angle-90]){
    vim3();
  }
}

translate([80,-100,0])
rotate([0,0,790])
cube([90.5,62,22.2]);

//
////face_plate_split
//intersection(){
//  translate([body_chop_x,-500,-500]){
//    cube(1000);
//  }
//  face_plate_final();
//}
//
////translate([-50,0,0]){
//  difference(){
//    face_plate_final();
//    translate([body_chop_x,-500,-500]){
//      cube(1000);
//    }   
//  }
////}


color("green"){
  translate([neck_start_x-neck_in_body,0,body_height+rounding_r/2+shell_thickness]){
    neck_1_top(neck_len_1,w1,w2);
  }
}
color("red"){
  translate([neck_start_x-neck_in_body,0,neck_thickness+rounding_r/2+shell_thickness]){
    neck_shell(neck_len_1,neck_thickness,w1,w2);
  }
}

color("orange"){
  translate([neck_start_x+neck_len_1-neck_in_body,0,neck_thickness+rounding_r/2+shell_thickness]){
  frets_shell(frets_len,neck_thickness,w2,w3);
  }
}

color("purple"){
  translate([neck_start_x+neck_len_1-neck_in_body,0,body_height+rounding_r/2+shell_thickness]){
    frets_top(frets_len,w2,w3);
  }
}
