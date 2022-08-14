//import("WhammyBarJointv2.stl");

//PARAMS//

//Back plate (bit with just plate and cylinder

bp_x1 = 39; //full length
bp_x2 = 35.5; //length without thin bits on end
bp_y = 32; //width

//heights are of the whole piece at given point
bp_h1 = 1.4; //thinnest part on edges
bp_h2 = 2.4; //most of the piece
bp_h3 = 3; //little raised circular bit before the cylinder
bp_h4 = 9.3; // protruding cylinder


bp_od1 = 9; //radius of little circle bit
bp_od2 = 6; //outer radius protruding cylinder
bp_id = 3; // inner radius of through hole
bp_hole_x = bp_x1/2;
bp_hole_y = 12.3;

//front plate (looks like the back plate with more bits on it)
fp_id1 = 6;
fp_od1 = 10.8;

fp_h1 = 9;

fp_screw_id = 1.9;
fp_screw_od = 4;
fp_screw_space_x = 29;
fp_screw_x1 = bp_hole_x + fp_screw_space_x/2;
fp_screw_x2 = bp_hole_x - fp_screw_space_x/2;
fp_screw_y = bp_hole_y + fp_od1/2;
fp_screw_h = 14;

fp_under_cyl_h = 7.2;
fp_under_cyl_id = 1.8;
fp_under_cyl_od = 4;
fp_under_cyl_x1 = bp_x1-5.5;
fp_under_cyl_y1 = bp_hole_y + fp_id1/2;
fp_under_cyl_x2 = 8;
fp_under_cyl_y2 = fp_under_cyl_y1 + fp_under_cyl_od;

fp_under_rect_h = 7;
fp_under_rect_x = bp_hole_x;
fp_under_rect_y = fp_under_cyl_y2 + fp_under_cyl_od;
fp_under_rect_l = 4.21;
fp_under_rect_w = 1.6;

//front plate attachment thing, kinda looks like a koala

fpa_od1 = 13;
fpa_id1 = 8;

fpa_d1 = 24;
fpa_d2 = 38;
fpa_y1 = 16;

fpa_rect_x = 5.5;
fpa_rect_y = 3;

fpa_h1 = 2.54; //most of the plate
fpa_h2 = 7.4; //cylinder protrusion

fpa_slot_w = 2.4;
fpa_slot_r = 16;

//spring holder (arm thingy, need two of them)
//pain in the ass to measure, at least they are the same

sh_id = 9;
sh_od = 13;
sh_id2 = 2.54; //smaller hole

sh_h1 = 2.54; //thickness at circle bit
sh_h2 = 2.54; //thickness at other end

sh_htot = 3.8; // overall zmax-zmin, there's some overlap
sh_hoverlap = sh_h1 + sh_h2 - sh_htot;

sh_polygon = [[-3,0],[16,0],[17,-3.5],[16,-4.5],[9.5,-3.5],[8,-7.2],[2.5,-6]];

sh_x2 = 25.3 - sh_od/2;
sh_y2 = 4.5;

module back_plate() {
  difference(){
    union(){ 
      translate([0,0,bp_h2-bp_h1]){
      cube([bp_x1,bp_y,bp_h1]);
      translate([(bp_x1-bp_x2)/2,0,bp_h1-bp_h2])
        cube([bp_x2,bp_y,bp_h2]);
      }
      translate([bp_hole_x,bp_hole_y,0]){
        cylinder(h=bp_h3, d=bp_od1, $fn=50, center=false);
        cylinder(h=bp_h4, d=bp_od2, $fn=50, center=false);
      }
    }
    translate([bp_hole_x,bp_hole_y,0]){
      cylinder(h=bp_h4, d=bp_id, $fn=50, center=false);
    }
  }
}


module spring_holder() {
  difference(){
    union() {
      
      difference(){
        cylinder(sh_htot,d=sh_od,$fn=50);
        cylinder(sh_htot,d=sh_id,$fn=50);
      }
      translate([sh_od/2-3,sh_od/2,0])
      linear_extrude(sh_htot) {
        polygon(sh_polygon);
      }
    }
    translate([sh_x2,sh_y2,0])
      cylinder(h=sh_htot, d=sh_id2, $fn=50);
    translate([0,0,sh_h1])
      cylinder(sh_htot,d=sh_od,$fn=50);
    difference() {
    translate([sh_od/2-3,sh_od/2,-sh_h1])
      linear_extrude(sh_htot) {
        polygon(sh_polygon);
      }
      cylinder(sh_htot,d=sh_od,$fn=50);
    }
    
  }
}

module front_plate_attachment() {
  difference() {
    union() {
      hull() {
        cylinder(h=fpa_h1,d=fpa_d1);
        difference(){
          cylinder(h=fpa_h1,d=fpa_d2);
          translate([-50,-100,0])
            cube([100,100,100]);
          translate([-50,16,0])
            cube([100,100,100]);
        }
      }
      cylinder(h=fpa_h2,d=fpa_od1,$fn=50);
    }
    translate([(fpa_od1+fpa_rect_x)/2,0,0])
      cube([fpa_rect_x,fpa_rect_y,2*fpa_h1],center=true);
    translate([-(fpa_od1+fpa_rect_x)/2,0,0])
      cube([fpa_rect_x,fpa_rect_y,2*fpa_h1],center=true);
    rotate_extrude(angle=40, $fn=50)
      translate([fpa_slot_r,0,0])
          square([fpa_slot_w,2*fpa_h1],center=true);
    mirror([1,0,0])
      rotate_extrude(angle=40, $fn=50)
        translate([fpa_slot_r,0,0])
            square([fpa_slot_w,2*fpa_h1],center=true);
    cylinder(h=fpa_h2,d=fpa_id1,$fn=50);
  }
}

module front_plate() {
  difference(){
    union() {
      cube([bp_x1,bp_y,bp_h1]);
      translate([(bp_x1-bp_x2)/2,0,0])
        cube([bp_x2,bp_y,bp_h2]);
      translate([bp_hole_x, bp_hole_y,0])
        cylinder(d=fp_od1,h=fp_h1,$fn=50);
      translate([fp_screw_x1,fp_screw_y,0]){
        difference(){
          cylinder(h=fp_screw_h,d=fp_screw_od,$fn=50);
          cylinder(h=fp_screw_h,d=fp_screw_id,$fn=50);
        }
      }
      translate([fp_screw_x2,fp_screw_y,0]){
        difference(){
          cylinder(h=fp_screw_h,d=fp_screw_od,$fn=50);
          cylinder(h=fp_screw_h,d=fp_screw_id,$fn=50);
        }
      }
      translate([fp_under_cyl_x1,fp_under_cyl_y1,-fp_under_cyl_h+bp_h2]){
        difference(){
          cylinder(h=fp_under_cyl_h,d=fp_under_cyl_od,$fn=50);
          cylinder(h=fp_under_cyl_h,d=fp_under_cyl_id,$fn=50);
        }
      }
      translate([fp_under_cyl_x2,fp_under_cyl_y2,-fp_under_cyl_h+bp_h2]){
        difference(){
          cylinder(h=fp_under_cyl_h,d=fp_under_cyl_od,$fn=50);
          cylinder(h=fp_under_cyl_h,d=fp_under_cyl_id,$fn=50);
        }
      }
      translate([fp_under_rect_x-fp_under_rect_l/2,fp_under_rect_y-fp_under_rect_w/2,-fp_under_rect_h+bp_h2]){
        cube([fp_under_rect_l,fp_under_rect_w,fp_under_rect_h]);
      }
    }
      translate([bp_hole_x, bp_hole_y,0])
        cylinder(d=fp_id1,h=fp_h1,$fn=50);    
  }
}

//back_plate();
//front_plate();
spring_holder();
//front_plate_attachment();