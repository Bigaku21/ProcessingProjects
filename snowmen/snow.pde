class Snow {
  float x, y, z ;
  color c ;
  float speed;
  float snowDrop;
  // ---constructor----  
  Snow() {

    x = random ( -2*width, 2*width);
    y = random ( -2*width, 2*width);
    z = 600;
    speed = random(0.5, 2) ;
    c = color(225) ;
  }
  // display behaviour  
  void display () {
    fill (c);
    noStroke();
    //  start from random points 600 above
    pushMatrix();
    translate(x, y, z);
    sphere(2);
    popMatrix();
  }
// movement of snow falling down by keep translating z 
  void move() {
    z = z - speed;
    translate(0, 0, -speed);
  }
}