import controlP5.*;

Particle [] chain;
ControlP5 cp5;

//Global Variables
float k  = 0.4;  //spring constant
float mass = 1000.0; //mass
float rest = 1.0; //resting position
float damping = 0.79;
int numOfPParticle = 5;
int selectedIndex = -1;
float gravity;
void setup()
{
  background(200,200,0);
  gravity = 5;
  frameRate(24);  
  size(1200, 800);
  setSliders();
  smooth();
  //noStroke();
  chain = new Particle[numOfPParticle];
  for (int i = 1; i<chain.length-1; i++)
  {
    chain[i] = new Particle(false,i,numOfPParticle);
  }
  chain[0] = new Particle(true,0,numOfPParticle);
  chain[numOfPParticle-1] = new Particle(true, numOfPParticle-1,numOfPParticle);
}

void draw()
{
  background(200,200,0);
  
  //1 - react (add acceleration to velocity and check boundary conditions
  for (int i = 0; i<chain.length; i++)
  {
    chain[i].setGravity(gravity);
    chain[i].react(chain, i);
  }

  //2 - add velocity to position
  for (int i = 0; i<chain.length; i++)
  {
    chain[i].move();
  }

  //3 - draw spring
  for (int i = 0; i<chain.length-1; i++)
  {
    chain[i].drawSpring(chain, i);
  }

  //4 - draw particles
  for (int i = 1; i<chain.length-1; i++)
  {
    chain[i].drawParticle(false);
  }
  chain[0].drawParticle(true);
  chain[numOfPParticle-1].drawParticle(true);
  if (mousePressed) {
    if (selectedIndex != -1)
      chain[selectedIndex].position = new PVector(mouseX, mouseY);
  }
}



void mousePressed()
{
  PVector mPos = new PVector(mouseX, mouseY);
  if (mouseButton == LEFT) {
    for (int i=0; i<chain.length; i++) {
      if (PVector.dist(mPos, chain[i].position)<=20)
      {
        selectedIndex = i;
        if(selectedIndex!=0&&selectedIndex!=numOfPParticle-1)
          chain[i].toggleAttached();
      }
    }
  } else if (mouseButton == RIGHT)
  {
    setup();
  }
}
void mouseReleased() {
  if(selectedIndex != -1&&(selectedIndex!=0&&selectedIndex!=numOfPParticle-1))
    chain[selectedIndex].toggleAttached();
  selectedIndex = -1;
  
}