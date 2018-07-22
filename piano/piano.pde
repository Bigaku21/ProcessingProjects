import processing.sound.*;
                  //importing libraries


boolean play = true;          //true - moving, false - stops             
int rows = 5;   
SinOsc[] osc = new SinOsc[rows];
int cols = 16;
int current;

/* array which says if the tile was selected like 
   [o][o][o][x][o][o]
   [o][o][o][x][o][o]
   [o][x][o][o][o][o]
*/
boolean selected[][];        

float [] notes = {880, 990, 1110, 1320, 1480}; // five notes available to play


void setup() {

  size(1000,400);                              //enough for all buttons
  background(0);                               //doesnt matter, since i use rectangle as a background
  current = 0;                                 //which coloumn is current
  selected = new boolean[rows][cols];          //initiate(create array)
  for (int i=0; i<rows; i++) 
  {
    for (int j=0; j<cols; j++) 
    {
      selected[i][j] = false;                 // fill it with fasles, since no tiles should be selected at the start of the programm
    }
  }
  for(int i=0; i<rows; i++)
  {
   osc[i] = new SinOsc(this);                  // create audio object
  }
  create_table();                              // draw table at start
}

void draw()                                    // will be used to do step by step action
{ 
  
                                           
                                
  if(play)                                     // if play == false - move and play, othervise stand
  {
    int val=(current+cols-1)%cols;             // necessary to avoid offset (can comment and see what happened)
    create_table();
    current=(current+1)%cols;                  // increments current until 16, and after become 0 again
    for(int i=0; i<rows; i++)                  // checks if any of the tiles in this coloumn were selected and plays them
    {
      if(selected[i][val])
      {                                        // switches off aditional delay at line 65, because there is delay after play() and we dont want to have two of them
        osc[i].play(notes[i],1);               // plays actual frequencies                                    // delay to hear enoug of this music, before it stops in the new draw loop                                               
      }
    }
    delay(500);
    for(int i=0; i<rows; i++)                  // checks if any of the tiles in this coloumn were selected and plays them
    {
      if(selected[i][val])
      {
        osc[i].stop();                         // stops music after given delay
      }
    }    

    
  }
}

void create_table()                            // redraws all the elements
{ 
  fill(52,204,255);                            // background rectangle
  rect (-5, -4, 1005, 404);
  for(int j=0; j<cols; j++) {                  // draws sound tiles in different colors 
    for(int i=0; i<rows; i++) {
      if(selected [i][j])                      // if the current tile was selected
      {
        if(current == j)
        {
          fill(50, 205,50);                    // current row needs to be green? 
        }
        else
        {
          fill(106,90,205);                    // this row is not current, so it needs to be purple
        }
         
      }
      else                                     // if tile is not selected
      {
        if(current == j)                       // if it is current coloumn and needs to be red?  
        {
          fill(255,17,0);                      
        }
        else                                   // else if it is not current coloumn and needs to be white?
        {
          fill(255);
        }
      }
      rect ((j*60)+20, (i*60)+20, 40, 40);     //draws rectangle itself
    }
  }
  fill(255,255,0);                             // now need to draw yellow buttons
  for(int i=0; i<3; i++) 
  {
    rect (175+(i*275), 330, 100, 40);          // three of rectangles of lenght 100 and space between 175: 175|100|175|100|175
  }

}

void mousePressed()                            // if mouse is pressed
{
  int X = mouseX-20;                           // 
  int Y = mouseY-20;                           // for ease of calculation

  if((X%60)<41 && (Y%60)<41 && X<940 && Y <280)// if it has a coordinate of a tile
  {    
    int col = X/60;                            // figures out which column
    int row = Y/60;                            // figures out which row
    selected[row][col]=!(selected[row][col]);  // changes this tile to its opposite (changes selected to unselected and reverse)
    current--;                                 
    create_table();                            // redraws the table on click so you can see square without delay
    current++;
  }
  else if(mouseX>174&&mouseX<274&&mouseY>330&&mouseY<370)
  {
    play=true;                                 // if it is the left yellow button, starts music
  }
  else if(mouseX>449&&mouseX<549&&mouseY>330&&mouseY<370)
  {
    play=false;                                // if it is the middle yellow button, stops music
  }
  else if(mouseX>724&&mouseX<824&&mouseY>330&&mouseY<370)
  {
    current=0;
    create_table();
    current=1;
                                // if it is the right yellow button, resets music    
  }
  
}