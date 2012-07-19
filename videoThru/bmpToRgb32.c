/*
	Converts a bmp file to RGBA
	may 31-Aug-2011
	Strips the 54 byte header and reverses the order of the rows of pixels.

	Based on bmpToRgb16.c
*/

#include <stdio.h>

#define MAX_OSD_WIDTH 720     // Max Davinci OSD width
#define MAX_OSD_HEIGHT 576    // Max Davinci OSD height (for PAL support)
#define MAX_OSD_SIZE MAX_OSD_WIDTH*MAX_OSD_HEIGHT  
#define NTSC_OSD_WIDTH  720
#define NTSC_OSD_HEIGHT 480

int main(int argc, char *argv[])
{
   int  osdData[MAX_OSD_SIZE], input; 
   FILE   *rgb24file;	// Input file
   FILE   *rgb16file;	// Output file
   long   fileSize;
   int    x, y; 
   int    width=NTSC_OSD_WIDTH, height=NTSC_OSD_HEIGHT; //Default values

   if (argc < 2) {
     printf("Usage: %s filename [width][height]\n", argv[0]);
     return -1;
   }
   else if ((argc > 2) && (argc != 4)) {
      printf("Must specify both width and height or neither\n");
      printf("Usage: %s filename [width][height]\n", argv[0]);
      return -1;
   }
   else if ((argc == 4) && (atoi(argv[2]) > MAX_OSD_WIDTH)) {
      printf("width cannot exceed %d  pixels\n", MAX_OSD_WIDTH);
      return -1;
   }
   else if ((argc==4) && (atoi(argv[3]) > MAX_OSD_HEIGHT)) {
      printf("height cannot exceed %d pixels\n", MAX_OSD_HEIGHT);
      return -1;
   }
   else if (argc==4) {
      //Valid width and Height were entered; therefore override defaults
      width = atoi(argv[2]);
      height = atoi(argv[3]);
   }
    
   printf("Preparing to convert %s (%d x %d)....\n", argv[1], width, height);   

   // Open file in read-binary mode
   rgb24file = fopen(argv[1], "rb");
  
   if (rgb24file == NULL) {
      printf("could not find file %s \n", argv[1]);
      return -1;
   }
 
   // Get size of file
   fseek(rgb24file, 0, SEEK_END);
   fileSize = ftell(rgb24file);
   fseek(rgb24file, 0, SEEK_SET);
   printf("size %d\n", fileSize);
  
   //Skip BMP header information 
   fseek(rgb24file, 54, SEEK_SET);
   fileSize = fileSize - 54;
 
   //Ensure file size does not exceed Max supported OSD size
   if (fileSize > (MAX_OSD_SIZE*4))
   {
      printf("This file is too large, maximum supported size is 720x576x4\n");
   }
   else if (((fileSize % 4) !=0)|| (fileSize != (width*height*4))) 
   {
      printf("this file does not have the size expected \n");
   }
   else
   {
	fread(osdData, sizeof(int), width*height, rgb24file);     
	// Open file in read-binary mode
	rgb16file = fopen("osd.r32", "wb");
	for (y= height -1;  y >=0; --y) {
	    fwrite(&osdData[width*y], sizeof(int), width, rgb16file);
	}
	fclose(rgb16file);   
   }

   fclose(rgb24file);
   return;
}
