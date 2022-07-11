points_2 = [
[0,0],
[11.5,4.45],
[26.575,1.55],
[21.5,9],
[22,10.3],
[22,14.9],
[18.5,18.3],
[11.05,16.9],
[-(9.625+0.2*sqrt(2)),26.5+0.2*sqrt(2)]
];

strum_midline_x = 10;
strum_midline_y = 10.3+(14.9-10.3)/2;
  
points = [for (i=points_2) [i.x-strum_midline_x, i.y-strum_midline_y]];

points_x = [for (i=points) i[0]];
points_y = [for (i=points) i[1]];
  
echo(points_2);

body_height = 3;
rounding_r = 1;


 //how far the neck extends into the body
neck_in_body = 3.7;
neck_len_1 = 23.3;
frets_len = 11.8;
neck_thickness = 3;
w1 = 4.4;
w2 = 3.7;
w3 = 3.5;
neck_start_x = 12;
face_screw_vertices = [0,1,2,3,6,8];
body_chop_x = 5;

bds = [min(points_x),max(points_x),min(points_y),max(points_y)];
w = max(points_x) - min(points_x) + 2*rounding_r;
h = max(points_y) - min(points_y) + 2*rounding_r;
back_edge_angle = atan(points[8].x/points[8].y);

buttons_c_to_c = 2.4;
choc_travel = 2.8;
strum_v_space = 1.9;

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
                linear_extrude(height=0.5){
                    offset(r=0.5){
                        polygon(points);                  
                    }
                }
            translate([-2,12,0.2]){
                rotate([0,0,20]){
                    union(){
                        minkowski(){
                            cube([3.7,8.5,0.3],center=false);
                            translate([0,0,0.3]){
                                sphere(0.3,$fn=10);
                            }
                        }
                        translate([3.7/2,8.5/2,0]){
                            cylinder(0.3,1,$fn=30,center=true);
                            cylinder(0.5,1/4,$fn=20,center=true);
                            translate([1,-2.5,0]){
                                cylinder(0.5,1/2,$fn=20,center=true);
                            }
                            translate([-1,-2.5,0]){
                                cylinder(0.5,1/2,$fn=20,center=true);
                            }
                            translate([0,2.5,0]){
                                cylinder(0.5,3/4,$fn=20,center=true);
                            }
                        }
                    }
                }
            }
            rotate([0,0,20]){
                translate([2,3,0]){
                    cube([3.4,1.6,3]);
                }
            }
        }
        translate([-3.5,-1.5,0.5]){
            difference(){
                union(){
                    minkowski(){
                        cube([7,3,0.3]);
                        translate([0,0,-0.3]){
                            sphere(0.3,$fn=10);
                        }
                    }
                    translate([3.5,1.5,0]){
                        translate([2.5,0,0]){
                            rotate([0,90,0]){
                                cylinder(1,0.8,0.3,$fn=20);
                            }
                        }
                        translate([-2.5,0,0]){
                            rotate([0,-90,0]){
                                cylinder(1,0.8,0.3,$fn=20);
                            }
                        }
                    }
                }
                translate([0,0,-1]){
                    cube([30,30,2],center=true);
                }
            }
        }
    }
      union(){
          cube([5,1.8,4],center=true);
      }    
  }
}
 
module body_solid_rounded(){
  minkowski(){
    linear_extrude(height=body_height){
        polygon(points);
    }
    sphere(1,$fn=10);
  }
}

module bottom_shell(){
    difference(){
        body_solid_rounded();
        translate([0,0,-0.51]){
            linear_extrude(height=body_height+1.51){
                offset(r=0.5){
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
//        sphere(1,$fn=10);
//      }
//      minkowski(){
//        linear_extrude(height=body_height+2){
//          polygon(points);
//        }
//        sphere(0.4,$fn=10);
//      }
//    }
//}


module neck_1_top(l,w1,w2){
  d = 0.3;
  
  
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
      translate([2.7,0,0]){
        neck_1_top(neck_len_1-2.7,w1,w2);
      }
      translate([0,-w1/2,0]){
        cube([2.7,w1,0.3]);
      }
    }
    rotate([0,180,90]){
      resize([t/2+0.15,0,0],[true,false,false]){
        halfcylinder(0.01,t,$fn=40);
      }
    }
  }
}

module neck_shell(l,t,w1,w2){
  difference() {
    neck_bottom(neck_len_1,2.7,w1-t/2,w2-t/2);
    neck_bottom(neck_len_1,2.4,w1-t/2-0.3,w2-t/2-0.3);    
  }
}

module frets_top(l,w1,w2){
  d = 0.3;
  fret_spacing = 0.6;
  fret_h = 2.44; //2.36 measured
  fret_w = 1.75;
  
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
        cube([fret_w,fret_h,0.6]);
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
      resize([t/2+0.15,0,0],[true,false,false]){
        halfcylinder(0.01,t,$fn=40);
      }
    }
  }
}

module frets_shell(l,t,w1,w2){
  difference() {
    frets_bottom(frets_len,2.7,w1-t/2,w2-t/2);
    frets_bottom(frets_len,2.4,w1-t/2-0.3,w2-t/2-0.3);    
  }
}

module screw_post(size){
  difference(){
    cylinder(h=body_height+rounding_r,d=size,center=false);
    cylinder(h=body_height+rounding_r,d=size-0.5,center=false);
  }
}

module body_shell_final(){
  union(){
    difference(){
      bottom_shell();
      translate([0,0,body_height+0.5]){
          top_plate();
      }
      for (i = face_screw_vertices){
        translate(points[i]){
          cylinder(h=body_height+rounding_r/2,d=1,$fn=20,center=false);
        }
      }
    }
    translate([0,0,-0.5]){
      for (i = face_screw_vertices){
        translate(points[i]){
          screw_post(1, $fn=20);
        }
      }
    }
    intersection(){
      union(){
        dx = points_x[1] - points_x[0];
        dy = points_y[1] - points_y[0];
        theta = atan(dy/dx);
        translate([3.5,0.5,-0.5]){
          cube([body_height, body_height+0.5, body_height+1]);
        }
        dx2 = points_x[8] - points_x[7];
        dy2 = points_y[8] - points_y[7];
        theta2 = atan(dy2/dx2);
        tx = points_x[7]-5.5*cos(theta2);
        ty = points_y[7]-5.5*sin(theta2)-2;
        translate([3.5,ty,-0.5]){
          cube([body_height, body_height+1, body_height+1]);
        }
    }
    body_solid_rounded();
  }
}
}


module face_plate_final(){
  translate([0,0,body_height+0.3]){
   difference(){
     top_plate();
     for (i=face_screw_vertices) {
       translate(points[i]){
        cylinder(h=0.5,d=0.3,$fn=20,center=false);
         translate([0,0,0.2]){
           cylinder(h=0.4,d=0.5,$fn=20,center=false);
         }
       }
     }
   }
 }
}

module vim3(){
  scale([0.1,0.1,0.1]){
    translate([ -41.245 , -29.049 , -6.649 ]){
      translate([ 197.337 , -16.756 , -46.643 ]){
        import("VIM3-simplified.stl");
      }
    }
  }
}

module chocswitch(){
  scale([0.1,0.1,0.1]){
    import("ChocSwitch.stl");
  }
}

//body_split
intersection(){
  translate([body_chop_x,-50,-50]){
    cube(100);
  }
  body_shell_final();
}
 
translate([0,0,0]){
  difference(){
    body_shell_final();
    translate([body_chop_x,-50,-50]){
      cube(100);
    }   
  }
}

translate([0,7,0]){
  rotate([0,0,-back_edge_angle-90]){
    vim3();
  }
}


//face_plate_split
intersection(){
  translate([body_chop_x,-50,-50]){
    cube(100);
  }
  face_plate_final();
}

translate([-5,0,0]){
  difference(){
    face_plate_final();
    translate([body_chop_x,-50,-50]){
      cube(100);
    }   
  }
}


color("green"){
  translate([neck_start_x-neck_in_body,0,body_height+rounding_r/2+0.3]){
    neck_1_top(neck_len_1,w1,w2);
  }
}
color("red"){
  translate([neck_start_x-neck_in_body,0,neck_thickness+rounding_r/2+0.3]){
    neck_shell(neck_len_1,neck_thickness,w1,w2);
  }
}

color("orange"){
  translate([neck_start_x+neck_len_1-neck_in_body,0,neck_thickness+rounding_r/2+0.3]){
  frets_shell(frets_len,neck_thickness,w2,w3);
  }
}

color("purple"){
  translate([neck_start_x+neck_len_1-neck_in_body,0,body_height+rounding_r/2+0.3]){
    frets_top(frets_len,w2,w3);
  }
}
