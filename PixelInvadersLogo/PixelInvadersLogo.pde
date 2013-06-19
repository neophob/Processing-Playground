import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

float rot;

/*
todo:
  -rotate
  -lightning
  -add text
  -create shape for the logo
  -animation
*/

int BOXSIZE = 35;
PeasyCam cam;
PImage textTexture;

void setup() {
  size(400, 400, OPENGL);
  frameRate(50);
  noStroke();
  cam = new PeasyCam(this, 80);
  textTexture = crImage();
  textureMode(NORMAL);
}

void draw() {  
  background(0);

  lights();  
  directionalLight(128, 0, 105, 0, -1, 0);
  directionalLight(64, 64, 64, 1, 0, 0);

  drawLogo();
  drawText(textTexture);
}

