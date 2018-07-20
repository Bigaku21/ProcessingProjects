////////////////////////////////////////////////////////////
// Imports 
////////////////////////////////////////////////////////////
import java.io.IOException;
////////////////////////////////////////////////////////////
// Variables 
////////////////////////////////////////////////////////////

int stage;           // For outputing results
int maxImages = 50;  // Total # of images
PImage ldn;          // Original picture to compare
PImage ldn20x15;     // Small picture to compare


float [] times;      // Storing the times required for 
                     // every type of calculations in average
                     
PImage[] images;     // Stores original size images
PImage[] smallImages;// Stores original size images
float [][] results;  // Stores results received from comparison

////////////////////////////////////////////////////////////
// Public methods
////////////////////////////////////////////////////////////

void setup()
{
  size(1600,850);
  background(135);
  // Initialization of all the variables and arrays
  
  stage = 0; 
  times      = new float[8];            
  results    = new float[8][maxImages];
  images     = new PImage[maxImages];
  smallImages= new PImage[maxImages];
  // Loading londons picture to PImage variable to work with it 
  ldn = loadImage( "Aerial_images/LDN.jpg" );
  ldn20x15=resizeTo20X15(ldn);
  
  // Loading original pictures and its resized copies into arrays
  for (int i = 0; i < 50; i++) 
  {
    images[i] = loadImage( "Aerial_images/Image_" + (i+1) + ".jpg" );
    for(int j = 0; j < 8; j++)
      results[j][i]=0;
    smallImages[i]= resizeTo20X15(images[i].copy());
  }
  
  // Filling array of time recordings with zeros
  for(int i = 0; i < 8; i++)
    times[i] = 0;
    
  // Loads pixels of comparison images first
  ldn.loadPixels();
  ldn20x15.loadPixels();
  int startTime;
  // Goes through every image in both normal and small images and 
  // compares them to london pictures of the same sizes
  for(int i = 0; i < 50; i++)
  {     
    println(i*2+"%");                                  // Shows percentage of completed analysis 
    images[i].loadPixels();                            // Loads current image pixels
    startTime=millis();                                // Substracts staring time of the algorithm 
    results[0][i] = colorDifference(images[i],ldn);    // Applies first comprison algorithm to the current picture and saves result in the result array
    times[0] += millis() - startTime;                   // Adds ending time of an algorithm to get difference between beggining and end(time of excecution) 
    startTime=millis();
    results[1][i] = meanBrightness(images[i]) - meanBrightness(ldn);  // Gets difference of brightness between current image and image of london and saves result in the result array
    times[1] += millis() - startTime;
    startTime = millis();
    results[2][i] = normCrossCor(images[i],ldn);       // Applies third comprison algorithm to the current picture and saves result in the result array 
    times[2] += millis() - startTime;   
    startTime = millis();
    results[3][i] = normCrossCorColor(images[i],ldn);  // Applies forth comprison algorithm to the current picture and saves result in the result array 
    times[3] += millis() - startTime;
    smallImages[i].loadPixels();                       // Loads image pixels for smaller version of current picture
    
    // Does same actions for smaller images 
    startTime = millis();
    results[4][i] = colorDifference(smallImages[i],ldn20x15); 
    times[4] += millis()-startTime;
    startTime = millis();
    results[5][i] = meanBrightness(smallImages[i]) - meanBrightness(ldn20x15);
    times[5] += millis() - startTime;
    startTime = millis();
    results[6][i] = normCrossCor(smallImages[i],ldn20x15); 
    times[6] += millis() - startTime; 
    startTime = millis();
    results[7][i] = normCrossCorColor(smallImages[i],ldn20x15); 
    times[7] += millis() - startTime;
    
  }
  // Devides sum of all times required for algorithm excecution to the amount of images to get an average time of processing
  for(int i = 0; i < 6; i++)
    times[i]/=50;
  println("100%");
}
/*
* Is used to output the results of comparisson between given pictures and the picture of London. 
* By changing variable "state", screen state changes as well, showing results from the next technique.  
*/
void draw()
{
  int nr;         // Will be used to store number of a winning image temporary
  PImage tmp;     // Will be used to temporary store copy of an image, to not damage original picture by applying grayscale filter
  String message; // Will be used to temporary store part of the message to make more variance in the output 
  switch(stage)
  {
    case 0: // Shows result for the first comparisson tecnique
      background(135);
      nr = findClosest(results[0]); // Finds the winner result int the array
      
      // Places texts
      text("Winner picture of color difference calculations. Average time of calculations is "+times[0]+"ms.  (Click to change)", width/2-300, 60); 
      text("Original picture", width/2-450, 100); 
      text("Winner with number "+ (nr+1), width/2+350, 100);
      if(times[4]==0)  // if the calculation time was smaller than a milisecond
        message = "too insignifficant";
      else 
        message = times[4]+"ms";
      text("Resized picture comparison. Average time of calculations is "+message, width/2-180, 750);
      // Places winner image and londons picture next to each other for visual comparisson
      image(ldn, 0, 120);                
      image(images[nr], width/2, 120);
      // Same actions for small picturs
      nr = findClosest((results[4]));
      text("Original picture resized", width/2-200, 785); 
      text("Winner with number "+ (nr+1), width/2+100, 785);
      image(ldn20x15, width/2-200, 795);    
      image(smallImages[nr], width/2+100, 795);
    break;
    case 1: // Shows result for the second comparisson tecnique
      background(135);
      nr = findClosest(results[1]);      
      text("Winner picture of average brightness calculations . Average time of calculations is "+times[1]+"ms (Click to change)",width/2-300, 60); 
      text("Original picture", width/2-450, 100); 
      text("Winner with number "+ (nr+1), width/2+350, 100);
      if(times[5]==0)
        message = "too insignifficant";
      else 
        message = times[5]+"ms";
      text("Resized picture comparison. Average time of calculations is "+message, width/2-180, 750);
      // Applies grayscale filter for both winner image and londons image
      tmp=ldn.copy();
      tmp.filter(GRAY);
      image(tmp, 0, 120);
      tmp=images[nr].copy();
      tmp.filter(GRAY);
      image(tmp, width/2, 120);
      nr = findClosest((results[5]));
      text("Original picture resized", width/2-200, 785); 
      text("Winner with number "+ (nr+1), width/2+100, 785);
      tmp=ldn20x15.copy();
      tmp.filter(GRAY);
      image(tmp, width/2-200, 795);    
      tmp=smallImages[nr].copy();
      tmp.filter(GRAY);
      image(tmp, width/2+100, 795);
    break;
    case 2:  // Shows result for the third comparisson tecnique
      background(135);
      nr = findBiggest(results[2]);    
      text("Winner picture of cross correlation calculations on brightness histogram. Average time of calculations is "+times[2]+"ms. Similarity: "+(results[2][nr]*100)+"% (Click to change)",width/2-400, 60); 
      text("Original picture", width/2-450, 100); 
      text("Winner with number "+ (nr+1), width/2+350, 100);           
      tmp=ldn.copy();
      tmp.filter(GRAY);
      image(tmp, 0, 120);      
      tmp=images[nr].copy();
      tmp.filter(GRAY);
      image(tmp, width/2, 120);
      
      nr = findBiggest((results[6]));
      if(times[6]==0)
        message = "too insignifficant";
      else 
        message = times[6]+"ms";
      text("Resized picture comparison. Average time of calculations is "+message+". Similarity: "+(results[6][nr]*100)+"%", width/2-250, 750);
      text("Original picture resized", width/2-200, 785); 
      text("Winner with number "+ (nr+1), width/2+100, 785);
      tmp=ldn20x15.copy();
      tmp.filter(GRAY);
      image(tmp, width/2-200, 795);    
      tmp=smallImages[nr].copy();
      tmp.filter(GRAY);
      image(tmp, width/2+100, 795);
      
    break;
    case 3:  // Shows result for the forth comparisson tecnique
      background(135);
      nr = findBiggest(results[3]);
      text("Winner picture of cross correlation calculations on color histogram. Average time of calculations is "+times[3]+"ms. Similarity: "+(results[3][nr]*100)+"% (Click to change)",width/2-400, 60); 
      text("Original picture", width/2-450, 100); 
      text("Winner with number "+ (nr+1), width/2+350, 100);         
      image(ldn, 0, 120);      
      image(images[nr], width/2, 120);
      
      nr = findBiggest((results[7]));
      if(times[7]==0)
        message = "too insignifficant";
      else 
        message = times[7]+"ms";
      text("Resized picture comparison. Average time of calculations is "+message+". Similarity: "+(results[7][nr]*100)+"%", width/2-250, 750);
      text("Original picture resized", width/2-200, 785); 
      text("Winner with number "+ (nr+1), width/2+100, 785);
      image(ldn20x15, width/2-200, 795);    
      image(smallImages[nr], width/2+100, 795);    
    break;
    default:
    break;
  }
}

/*
* Changes the result shown when mouse is clicked
*/
void mousePressed()
{
  stage=(stage+1)%4;
  draw();
}
////////////////////////////////////////////////////////////
// Private methods 
////////////////////////////////////////////////////////////

/*
* Calculates color differnce in pixel-to-pixel comparisson for the two given images.
* Sqauare root of sum of squared differences of every color.
* param  image:     Image to be compared
* param  compareTo: Image to be compared to
* return sum - Sum of all the pixel color differences
*/
private float colorDifference(PImage image, PImage compareTo)
{
  if(image.pixels.length!=compareTo.pixels.length)
   return 1000000000;
  float sum=0;
  
  for(int i=0; i<image.pixels.length; i++)
  {
    sum+=sqrt(sq( red  (image.pixels[i]) - red  (compareTo.pixels[i]) ) +
              sq( green(image.pixels[i]) - green(compareTo.pixels[i]) ) +
              sq( blue (image.pixels[i]) - blue (compareTo.pixels[i]) ));
  }
  return sum;
  
}

/*
* Calculates normalized cross-correlation of brightness histogram between the two given images
* param  image:     Image to be compared
* param  compareTo: Image to be compared to
* return percentage:Value of similarity in percentage
*/
private float normCrossCor(PImage image, PImage compareTo)
{
  if(image.pixels.length!=compareTo.pixels.length)
   return -1;
  int[] hist1 = new int[256];   // Will store first pictures brightness values
  int[] hist2 = new int[256];   // Will store second pictures brightness values
  for (int i = 0; i < 256; i++) // fills arrays with zeros, to avoid null pointer excepripns
  {
    hist1[i] = 0;
    hist2[i] = 0;
  }
  // Calculate the histogram
  for (int i = 0; i < image.pixels.length; i++) 
  {
      int bright = int(brightness(image.pixels[i]));
      hist1[bright]++; 
      int bright2 = int(brightness(compareTo.pixels[i]));
      hist2[bright2]++; 
  }
  float percentage;
  float firstSqSum = 0;  // Stores sum of values for the future formula
  float secondSqSum = 0; // Stores sum of values for the future formula
  float crossCor = 0;    // Stores sum of values for the future formula
  // Goes throughout all the pixels and aplies actions to all of them
  for(int i = 0; i < hist1.length; i++)
  {
    firstSqSum += sq(hist1[i]);
    secondSqSum += sq(hist2[i]);
    crossCor += hist1[i] * hist2[i];
  }
  percentage = crossCor/sqrt(secondSqSum * firstSqSum); // Formula
  return percentage; 
}

/*
* Calculates normalized cross-correlation of color histogram between the two given images
* param  image:     Image to be compared
* param  compareTo: Image to be compared to
* return percentage:Value of similarity in percentage
*/
private float normCrossCorColor(PImage image, PImage compareTo)
{
  if(image.pixels.length!=compareTo.pixels.length)
   return -1;
  int[][] hist1 = new int[3][256];   // Will store first pictures brightness values
  int[][] hist2 = new int[3][256];   // Will store second pictures brightness values
  // Fills arrays with zeros, to avoid null pointer excepripns
  for (int i = 0; i < 256; i++)      
  {
    for(int j = 0; j < 3; j++)
    {
      hist1[j][i] = 0;
      hist2[j][i] = 0;
    }
  }
  int tmp;
  // Calculate the histograms for three colors
  for (int i = 0; i < image.pixels.length; i++) 
  {      
      tmp = int(red(image.pixels[i]));
      hist1[0][tmp]+=1;     
      tmp = int(green(image.pixels[i]));
      hist1[1][tmp]+=1; 
      tmp = int(blue(image.pixels[i]));
      hist1[2][tmp]+=1;
      tmp = int(red(compareTo.pixels[i]));
      hist2[0][tmp]+=1;
      tmp = int(green(compareTo.pixels[i]));
      hist2[1][tmp]+=1; 
      tmp = int(blue(compareTo.pixels[i]));
      hist2[2][tmp]+=1; 
  }
  float firstSqSum[] = new float[3];  // Stores sum of values for the future formula //<>//
  float secondSqSum[]= new float[3];  // Stores sum of values for the future formula
  float crossCor[]   = new float[3];  // Stores sum of values for the future formula
  // Fills arrays with zeros, to avoid null pointer excepripns
  for(int j = 0; j < 3; j++)
  {
    firstSqSum[j]  = 0;
    secondSqSum[j] = 0;
    crossCor[j]    = 0;
  }
  
  // Goes throughout all the pixels and aplies actions to all of them for three colors separately 
  for(int j = 0; j < 3; j++)
  {    
    for(int i = 0; i < 256; i++)  
    {
      firstSqSum[j] += sq(hist1[j][i]);
      secondSqSum[j] += sq(hist2[j][i]);
      crossCor[j] += hist1[j][i] * hist2[j][i];
    }
  }
  float percentage = 0; //<>//
  // Combines resulting percentage
  for(int i = 0; i < 3; i++)
  {
    percentage += crossCor[i]/sqrt(secondSqSum[i] * firstSqSum[i]); // Formula   
  }
  return percentage/3; 
}

/*
* Calculates average brightness of a picture
* param image: Image, to apply algorithm to 
* return average Brigtness of a picture (0-255)
*/
private float meanBrightness(PImage image)
{
    int l = image.pixels.length;
    float sum = 0;
    for(int i = 0; i < l; i++) // For all pixels
    {
      sum+=brightness(image.pixels[i]);  // Sum pixel brigtness
    }
  return sum/l;                // Get average (sum/length)
}

/*
* Creates a new image of a size 20 to 15 pixels from given picture
* param image: Image, to apply algorithm to 
* return newImg: Resized image
*/
private PImage resizeTo20X15(PImage image)
{
  PImage newImg = createImage(20,15,RGB); // Creates new image with a size 20 to 15 pixels
  int pixel;
  int[] sumRGB = new int[3];              // Will store the sum of sum of RGB of averaged pixels 
  // For every pixel in the new image averages colors of the 40x40 squared area in the original picture
  for(int i = 0; i < newImg.height; i++)
  {
    for(int j = 0; j < newImg.width; j++)
    {
      // Resets the values before the next pixel averaging
      for(int k = 0; k < 3; k++) 
        sumRGB[k] = 0;
      for(int k = 0; k < 1600; k++)
      {
        pixel = ((i * 40 + (k/40)) * image.width) + (j * 40) + (k%40); // Calculates curent pixels position on the original picture
        // Adds the color values to the corresponding sums
        sumRGB[0] += red  (image.pixels[pixel]);
        sumRGB[1] += green(image.pixels[pixel]);
        sumRGB[2] += blue (image.pixels[pixel]);
      }
      // Averagivg 1600 pixels in 1
      for(int k = 0; k < 3; k++)      
        sumRGB[k] /= 1600;
      // uptating a averaged pixel in the small image
      newImg.pixels[i*20+j] = color(sumRGB[0],sumRGB[1],sumRGB[2]);
    }
  }
  newImg.updatePixels();
  return newImg;
}

/*
* Returns the index of the smallest element in given array by value
* param  array: Array of comparisson results
* return smallest: Number of the picture with a value closest to a zero
*/
private int findClosest(float[] array)
{
  int closest = 0;
  for(int i = 1; i < array.length; i++) // Goes through the given array
  {
    if(abs((array[closest]))>abs(array[i])&&array[i]>=0) // If absolute value of current element is closer to 0 than "closest"
      closest = i;                                       // Sets new closest 
  }
  return closest;
}

/*
* Returns the index of the biggest element in given array by value
* param  array: Array of comparisson results
* return biggest: nr of the picture with a biggest value
*/
private int findBiggest(float[] array)
{
  int biggest = 0;
  for(int i = 1; i < array.length; i++)
  {
    if(array[biggest]<array[i])
      biggest = i;
  }
  return biggest;
}