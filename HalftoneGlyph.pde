/*****************************
 * HALFTONE GLYPH
 * Created by: Sofia Salvatori
 * License: GPL-3.0
 ******************************/

/*
Configuration
 */
String imputImage = "demo.png";         // image to covert
String outputImage = "output-demo.png"; // name of the converted image
String fontName = "Arial";              // font used 
String gliphs = "inserthereyourtext";   // characters to draw the image
int tile = 20;                          // size (pixel) of the biggest character
boolean whiteOnBlack = true;            // true: white characters on black background
//                                         false: black characters on white background



PFont myFont = createFont(fontName, tile);
PImage img = loadImage(imputImage);
// convert the image in grayscale to increase the contrast
img.filter(GRAY);
// decrease the pixel amount to have one pixel per tile
img.resize(img.width/tile, img.height/tile);
// create the new image whose size is rounded down
PGraphics pg = createGraphics(img.width*tile, img.height*tile);
pg.beginDraw();

// set the color of the characters and the background
if (whiteOnBlack == true) {
  pg.background(0);
  pg.fill(255);
} else {
  pg.background(255);
  pg.fill(0);
}

int gliphPosition = 0;
// for every x, y pixel of the downsized image
for (int y=0; y<img.height; y+=1) {
  for (int x=0; x<img.width; x+=1) {
    // get the color of the pixel in position x, y
    color pixelColor = img.get(x, y);
    // get the brightness (0-255) of the pixel
    float value = brightness(pixelColor);
    int gliphSize;
    //and map it to the size of the character 
    if (whiteOnBlack == true) {
      // the white character is bigger when the brightness is higher
      gliphSize = round(map(value, 0, 255, 0, tile));
    } else {
      // the black character is bigger when the brightness is lower
      gliphSize = round(map(value, 255, 0, 0, tile));
    }
    // configure the character font, size and position it inside the tile
    pg.textAlign(LEFT, TOP);
    pg.textFont(myFont, gliphSize);
    // if all the characters of the string have been used, start over
    if (gliphPosition == gliphs.length()) {
      gliphPosition=0;
    }
    // get one character of the string and draw it in a tile
    char carattere = gliphs.charAt(gliphPosition);
    pg.text(carattere, x*tile, y*tile);
    gliphPosition +=1;
  }
}
pg.endDraw();
pg.save(outputImage);
