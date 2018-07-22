class snowMan {
  color c3;
  color c4;
  float xposMan ;
  float yposMan ;
  float zposMan ;
  int sizeMan1 ;
  int sizeMan2 ;
  int viewHeight = 100;
  int[] jumpingStep = {10, 20,30, 40, 50, 40,30,20,10};
  int xdirect;
  int ydirect;
  int currentpos;
  // ---constructor----   
  snowMan() {
    xdirect=0;
    ydirect=0;
    currentpos=0;
    c3 = color(255) ;
    c4 = color(255, 0, 0) ;
    xposMan = random ( -3*width, 3*width);
    yposMan =random ( -3*width, 3*width);
    zposMan = 0;
    sizeMan1 = 40;
    sizeMan2 = 15;
  }
  // display snowman -- contains 4 spheres
  void display()
  { 
    noStroke();
    pushMatrix();
    fill(c3);
    translate(xposMan, yposMan, zposMan-70);
    sphere(sizeMan1);
    fill(c3);
    translate(0, 0, +2*viewHeight/5);
    sphere(sizeMan2);
    fill(c4);
    translate(8, 0, +viewHeight/18);
    sphere(3);
    fill(c4);
    translate(0, 8, +viewHeight/18);
    sphere(3);
    popMatrix();
  }

  //snowman behavoir ( jump left,right randomly , but i dont know how to kaie them jump)
  void move() {
    if(currentpos>8)
    {
      currentpos=0;
      getXY((int)random(360));
    }
    else
    {
      xposMan = xposMan + xdirect;
      yposMan = yposMan + ydirect;
      zposMan = jumpingStep[currentpos];
      
      //xposMan = constrain (xposMan, -3*width, 3*width);
      //yposMan = constrain (yposMan, -3*width, 3*width);
      //zposMan = constrain (zposMan, -3*width, 3*width);
      pushMatrix();
      translate(xposMan, yposMan, zposMan);
       
      popMatrix();
      currentpos++;      
    }
  }

  //---jump arounf function for fnow man , dont know how to make it , you can delete all of it but i want this function 
  //void jump() { 
  //  float jumpspeed = random (2, 5);
  //  pushMatrix();
  //  zposMan =1;
  //  zposMan = zposMan * jumpspeed;
  //  translate(0, 0, zposMan); 
  //  popMatrix();
  //}
  void getXY(int angle)
  {
    int scalar = (int)(random(10)+11);
    xdirect = (int)(cos(angle)*scalar);
    ydirect = (int)(sin(angle)*scalar);
  }
}