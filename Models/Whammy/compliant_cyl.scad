module gap_o(r1,r2,h,ang_m,ang_g) {
  material_w = ((r1+r2)/2*3.1415927)*ang_m / 180;
  rotate_extrude(angle=ang_g, $fn=20)translate([r2+material_w,0,0]) square([r1-r2,h]);
}

module gap_i(r1,r2,h,ang_m,ang_g){
  material_w = ((r1+r2)/2*3.1415927)*ang_m / 180;
  rotate_extrude(angle=ang_g, $fn=20)translate([r2-material_w,0,0]) square([r1-r2,h]);  
}

module gap_pair(r1,r2,h,ang_m,ang_g){
  gap_o(r1,r2,h,ang_m,ang_g);
  rotate([0,0,ang_m+ang_g]) gap_i(r1,r2,h,ang_m,ang_g);
  }


module ring(r1,r2,h) {
  difference(){
    cylinder(h=h,r=r1);
    cylinder(h=h,r=r2);
  }
}

module ring_segment(r1,r2,h,theta) {
  rotate_extrude(angle=theta) translate([r2,0,0]) square([r1-r2,h]);
}

module compliant_cyl(r1,r2,h,ang_m,ang_g){
  n = 180/(ang_m+ang_g);
  echo(n);
  difference(){
    ring(r1,r2,h);
    rotate([0,0,-ang_g/2]){
      for (i=[0:(n-1)]) {
          rotate([0,0,i*2*(ang_m+ang_g)]) gap_pair(r1,r2,h,ang_m,ang_g);
      }
    }
  }
}

module compliant_line(x,y,z,t,gap){
  l = gap+t;
  n = x/l;
  difference(){
    cube([x,y,z]);
    for (i=[1:n]){
      translate([i*l-t,(-1)^i*t,0]) cube([t,y,z]);
    }
  }
}

module compliant_arc(r1,r2,h,ang_m,ang_g,theta) {
  intersection(){
    ring_segment(r1,r2,h,theta);
    compliant_cyl(r1,r2,h,ang_m,ang_g);
  }
}
