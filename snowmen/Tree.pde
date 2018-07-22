class Tree {
   color c1;
   color c2;
   float xposTree ;
   float yposTree ;
   int sizeTree1 ;
   int sizeTree2 ;
   int viewHeight = 100;
 // ---constructor----  
Tree( ){
     c1 = color(145, 100, 15);
     c2 = color(70, 220, 100);
     xposTree = random ( -5*width, 5*width);
     yposTree =  random ( -5*width, 5*width);
     sizeTree1 =  (int)random ( 5, 15) ;
     sizeTree2 =(int)random ( 25, 50) ;
   }
   // --------display position--------
void display()
{
  noStroke();
  pushMatrix();
    fill(c1);
    translate(xposTree, yposTree, -viewHeight/2);
    box(sizeTree1, sizeTree1, viewHeight);
    fill(c2);
   translate(0 ,0 , +viewHeight/2);
    sphere(sizeTree2);
  popMatrix();
}
}