# processingC64ImageMaker
Sample code for processing (processing.org) to take a PImage and make a Commodore 64 looking image.

Processing (Processing.org) C64 Image Maker
PImage to commodore 64 image converter by John Rasmussen
Does not save into a commodore 64 format but makes a PImage that looks like it should be from a c64.

Background on c64 graphic modes here:
https://www.c64-wiki.com/wiki/Graphics_Modes

I'm basically emulating the Multicolor Bitmap Mode.
So for that mode you can have 4 out of 16 colors in each 8x8 block in an image.

So what I did was make a function that takes a PImage

1.  Resize the source to 160x200
2.  Loop through the image and look at each 8x8 set of pixels.
3.  I take the 8x8 pixels and use the filter POSTERIZE to drop it down to 4 colors.
4.  I run a loop over the 8x8 and find the closest colors that are in the c64 palette and pick those colors.
5.  Write each 8x8 back out to another PImage and return the full image when done.

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
