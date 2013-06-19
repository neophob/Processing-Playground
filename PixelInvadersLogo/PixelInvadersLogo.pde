import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

/*
todo:
 -rotate
 -lightning
 -add text
 -create shape for the logo
 -animation
 */

int BOXSIZE = 25;
int FONT_DEPTH = 10;
int FONT_SIZE_HEADER = 110;
int FONT_SIZE_SLOGAN = 62;
String FONT_NAME = "Z_PERISCOPE_BOLDSM-1.TTF";

PeasyCam cam;
PImage textTexture;

RExtrudedMesh textHeader;
RExtrudedMesh textSlogan;


void setup() {
  size(600, 400, OPENGL);
  frameRate(50);
  noStroke();
  cam = new PeasyCam(this, 800);

  RG.init(this);

  // Set the polygonizer detail (lower = more details)
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(1);

  RShape grp = RG.getText("PixelInvaders", FONT_NAME , FONT_SIZE_HEADER, RG.LEFT);
  textHeader = new RExtrudedMesh(grp, FONT_DEPTH, color(255));

  grp = RG.getText("Pixels invade the world", FONT_NAME, FONT_SIZE_SLOGAN, RG.LEFT);
  textSlogan = new RExtrudedMesh(grp, FONT_DEPTH, color(255,0,210));

  smooth();
}

void draw() {  
  background(0);

  lights();  
  directionalLight(128, 0, 105, 0, -1, 0);
  directionalLight(64, 64, 64, 1, 0, 0);

  drawLogo();
  drawText();
}

