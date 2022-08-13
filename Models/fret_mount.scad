h = 1.6;
l = 141;
w = 27;

screw_spacing = 128;
screw_pos = (l-screw_spacing)/2;
screw_r = 2;

sw_w = 15;
button_spacing = 24;
button_n = 5;

all_buttons_len = (button_n-1) * button_spacing + sw_w;
button_start = (l - all_buttons_len)/2;

button_centre_y = (w-sw_w)/2;

module choc_holes() {
  mid_hole_r = 3.4;
  side_hole_r = 1.9;
  pin_hole_r = 1.2;
  
  sw_w = 15;
  
  pin1_x = sw_w/2;
  pin1_y = sw_w/2 - 5.9;
  
  pin2_x = sw_w/2 - 5;
  pin2_y = sw_w/2 - 3.8;
  
  side_hole_x = (sw_w-11)/2;
  side_hole_y = sw_w/2;
  
  translate([sw_w/2,sw_w/2])
    cylinder(center=true,h=5,d=mid_hole_r,$fn=20);
  translate([pin1_x,pin1_y])
    cylinder(center=true,h=5,d=pin_hole_r,$fn=20);
  translate([pin2_x,pin2_y])
    cylinder(center=true,h=5,d=pin_hole_r,$fn=20);
  translate([side_hole_x,side_hole_y])
    cylinder(center=true,h=5,d=side_hole_r,$fn=20);
  translate([side_hole_x,side_hole_y])
    cylinder(center=true,h=5,d=side_hole_r,$fn=20);
  translate([side_hole_x+11,side_hole_y])
    cylinder(center=true,h=5,d=side_hole_r,$fn=20);
}





difference(){
cube([l,w,h]);
for (i=[0:button_n-1]) {
  translate([button_start + i*button_spacing,button_centre_y])
    choc_holes();
  }
  translate([screw_pos,w/2,0])
    cylinder(center=true,h=5,r=screw_r,$fn=20);
  translate([l-screw_pos,w/2,0])
    cylinder(center=true,h=5,r=screw_r,$fn=20);
}

