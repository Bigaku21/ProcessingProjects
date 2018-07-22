PMatrix3D eye = new PMatrix3D();
//camera height
int viewHeight = 60;
// make 50 trees , 40 snowman , 500 naow flake
Tree[] trees = new Tree[50];         
snowMan[] snowman = new snowMan[40];
Snow[] snow = new Snow[500];
int totalSnow = 0;
boolean record;
int img;


void setup()
{
  img =0;
  record = false;
  size(500, 500, P3D);
  fill(255);
  //translate eye position to view height 
  eye.translate(100, 0, viewHeight);

// creat trees , snow man , snow 
  for (int i = 0; i < trees.length; i ++ ) { 
    trees[i] = new Tree();
  }
  for (int j = 0; j < snowman.length; j ++ ) { 
    snowman[j] = new snowMan();
  }
  for (int k = 0; k < snow.length; k ++ ) { 
    snow[k] = new Snow();
  }
}

void draw()
{  
  lights();
  background(0);

  // translate camera to 'eye' by inv .
  camera(500, 0, viewHeight*1.5, 0, 0, 0, 0, 0, -1);
  PMatrix3D camera = new PMatrix3D();
  camera.translate(100, 0, 100);
  PMatrix3D inv = new PMatrix3D(eye);
  inv.invert();
  camera.apply(inv);
  applyMatrix(camera);
  // draw grid and translate position
  drawGrid();
  translate(100, 0, 100);
  //-------------------tree-------------
  for (int i = 0; i < trees.length; i ++ ) { 
    trees[i].display();
  }
  //-----------snow man behaviour-------------
  for (int j = 0; j < snowman.length; j ++ ) { 
    snowman[j].move();   
    snowman[j].display();
  }
  //--------snow behaviour------------
  //---------makes snow falls continously------
  snow[totalSnow] = new Snow();
  totalSnow ++ ;
  if (totalSnow >= snow.length) {
    totalSnow = 0;
  }
  //-----------snow behaviour - fall -----------
  for (int k = 0; k < snow.length; k ++ ) { 
    snow[k].move();
    snow[k].display();
  }
  if(keyPressed)
  {
    if (keyCode == LEFT) eye.rotateZ(-0.1);
    if (keyCode == RIGHT) eye.rotateZ(0.1);
    if (keyCode == UP) eye.translate(-10, 0, 0);
    if (keyCode == DOWN) eye.translate(10, 0, 0);
  }
  if(record)
  {
    saveFrame("images"+img+"/####.png");
  }
}


void drawGrid()
{

  int horizon = width*10;
  int sep = 100;

  stroke(255);
  for (int i=-100; i<100; i++)
  {
    line(-horizon, i*sep, horizon, i*sep);
    line(i*sep, -horizon, i*sep, horizon);
  }
// draw horizontal and vertical lines in different color  define center
  stroke(255, 0, 0);
  line(-horizon, 0, horizon, 0);
  stroke(0, 255, 0);
  line(0, -horizon, 0, horizon);
}


void keyPressed()
{
  smooth();
  if (key=='r'||key=='R') record = true;
  if (key=='p'||key=='P') 
  {
    record = false;
    img++;
  }
  if (keyCode == SHIFT) cameraAgent();
}

void cameraAgent(){
  // dont know what to do here 
}