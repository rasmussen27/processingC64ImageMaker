/*

Processing (Processing.org) C64 Image Maker
PImage to commodore 64 image converter by John Rasmussen
Does not save into a commodore 64 format but makes a PImage that looks like it should be from a c64.

Background on c64 graphic modes here:
https://www.c64-wiki.com/wiki/Graphics_Modes

I'm basically emulating the Multicolor Bitmap Mode.
So for that mode you can have 4 out of 16 colors in each 4x8 block in an image.

(made a change 5/10/2017 it should actually be 4x8 because of the resolution its in an aspect radio of 2:1)
http://dustlayer.com/vic-ii/2013/4/26/vic-ii-for-beginners-screen-modes-cheaper-by-the-dozen

So what I did was make a function that takes a PImage
1.  Resize the source to 160x200
2.  Loop through the image and look at each 4x8 set of pixels.
3.  I take the 4x8 pixels and use the filter POSTERIZE to drop it down to 4 colors.
4.  I run a loop over the 4x8 and find the closest colors that are in the c64 palette and pick those colors.
5.  Write each 4x8 back out to another PImage and return the full image when done.

Fun things to do with this.
Run live video through it.
Run video clips through it.
Make you're own palette and use that.
Take the time to write out the output to a real c64 format. (if you do this let me know and share the code!)

If you use this please drop me a line and let me know what you're doing with it.
Email: john.rasmussen33@gmail.com subject: "GITHUB C64 CONVERTER"
This is free code use it for whatever you would like.

Here is an example of running a video file through it.  You can also do it with a webcam or video input.
https://vimeo.com/216556606

Change Log
2017/5/10 -- should actually get 4x8 blocks instead of 8x8 because of the aspect radio of 2:1

*/

PImage image;
PImage source;
PImage dest;
PImage converted;
color[] c64col;

void setup()
{
  makeC64colors();
  
  size(1024,768,P3D);
  background(0); 
  source = loadImage("1280px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg");
  
  //you can take this out if you want, like draw a frame grab an image then run the function on it
  noLoop();
}

//make an array of the c64 colors
void makeC64colors()
{
  //build c64 color table
  /*
  taken from http://unusedino.de/ec64/technical/misc/vic656x/colors/
  0          black   (0,0,0) 
  1          white  (255,255,255)
  2          red   (104,55,43)
  3          cyan   (112,164,178)
  4          purple   (111,61,134)
  5          green  (88,141,67)
  6          blue   (53,40,121)
  7          yellow  (184,199,111)
  8          orange  (111,79,37)
  9          brown  (67,57,0)
  A    light red    (154,103,89)
  B     dark grey   (68,68,68)
  C          grey  (108,108,108)
  D    light green    (154,210,132)
  E    light blue   (108,94,181)
  F    light grey   (149,149,149)
  */
  c64col = new color[16];
  c64col[0] = color(0,0,0);
  c64col[1] = color(255,255,255);
  c64col[2] = color(104,55,43);
  c64col[3] = color(112,164,178);
  c64col[4] = color(111,61,134);
  c64col[5] = color(88,141,67);
  c64col[6] = color(53,40,121);
  c64col[7] = color(184,199,111);
  c64col[8] = color(111,79,37);
  c64col[9] = color(67,57,0);
  c64col[10] = color(154,103,89);
  c64col[11] = color(68,68,68);
  c64col[12] = color(108,108,108);
  c64col[13] = color(154,210,132);
  c64col[14] = color(108,94,181);
  c64col[15] = color(149,149,149);
}

void draw()
{
  source.get(0,0,160,200);
  
  image = PImageToC64(source);
  image.resize(1024,768);
  image(image,0,0);
  
  saveFrame("output.jpg");
}

//convert an image to an image containing c64 colors via 8x8 blocks
PImage PImageToC64(PImage source)
{
  PImage eightbyeight;
  
  //change resolution to c64 rez
  if((source.width != 160) && (source.height != 200))
  {
    source.resize(160,200);
  }
  
  for(int i=0; i<160; i=i+4)
  {
    for(int j=0; j<200; j=j+8)
    {
      eightbyeight = source.get(i,j,4,8);
      eightbyeight = convertByte(eightbyeight);
      image(eightbyeight,i,j);
    }
  }
  
  dest = get(0,0,160,200);
  return dest;
}

//pick up an 8x8 block from image and convert the colors to c64 colors
//write to canvas
PImage convertByte(PImage block)
{
  block.filter(POSTERIZE,4);
  color c64color;
  color sourcecolor;
  
  for(int x=0; x<4; x++)
  {
    for(int y=0; y<8; y++)
    {
      sourcecolor = block.get(x,y);
      c64color = convertToC64Color(sourcecolor);
      block.set(x,y,c64color);
    }
  }
  
  return block;
}

//take a color and return the closest c64 color
color convertToC64Color(color c)
{
  float min = 999;
  float tmp = 0;
  int c64colorindex = 0;
  color colortmp;
  
  //loop and find the closest c64 color
  for(int i=0; i<16; i++)
  {
    colortmp = c;
    tmp = colorDistance(c64col[i],colortmp);

    if(min >= tmp) 
    {
      min = tmp;
      c64colorindex = i;
    }
  }

  return c64col[c64colorindex];
}

//https://forum.processing.org/one/topic/how-to-find-closest-color-to-r-g-or-b.html
float colorDistance(color a, color b)
{
      float redDiff = red(a) - red(b);
      float grnDiff = green(a) - green(b);
      float bluDiff = blue(a) - blue(b);
      return sqrt( sq(redDiff) + sq(grnDiff) + sq(bluDiff) );
} 
