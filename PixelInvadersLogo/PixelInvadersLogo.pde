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
 -animation
 */

int BOXSIZE = 25;
int FONT_DEPTH = 8;
int FONT_SIZE_HEADER = 110;
int FONT_SIZE_SLOGAN = 62;
String FONT_NAME = "Z_PERISCOPE_BOLDSM-1.TTF";

PeasyCam cam;
PImage textTexture;
boolean capture = false;

RExtrudedMesh textHeader;
RExtrudedMesh textSlogan;

PShader blur;

void setup() {
  size(600*2, 400, OPENGL);
  frameRate(120);
  noStroke();

  cam = new PeasyCam(this, 400, 100, 0, 600);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
  //cam.setSpeedLock(false);
  cam.setSpeedRate(30);
  
  RG.init(this);
  // Set the polygonizer detail (lower = more details)
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(1);

  RShape grp = RG.getText("PixelInvaders", FONT_NAME, FONT_SIZE_HEADER, RG.LEFT);
  textHeader = new RExtrudedMesh(grp, FONT_DEPTH, color(255));

  grp = RG.getText("Pixels invade the world", FONT_NAME, FONT_SIZE_SLOGAN, RG.LEFT);
  textSlogan = new RExtrudedMesh(grp, FONT_DEPTH, color(255, 0, 210));

  smooth();
  
  blur = loadShader("blur.glsl"); 
   blur.set("aperture", 180.0);  
}

void draw() {  
  background(0);

  lights();  
  directionalLight(128, 0, 105, 0, -1, 0);
  directionalLight(64, 64, 64, 1, 0, 0);

  drawLogo();
  drawText();

  
  filter(blur);
  if (capture) {
    saveFrame("frame-####.png");
  }
}

void keyPressed() {
  if (key == '1') {
    println("animation1");
//    cam.lookAt(-814.48724, 100.31114, 330.7573, 330.7574, 2000L);
    cam.lookAt(-891.48724, 130.34, 330.7573, 0, 2000L);
  } else if (key == '2') {
    println("animation2");
//    cam.lookAt(1315.95, 130.34, 132.48, 132.48, 2000L);
    cam.lookAt(1540.49, 130.34, 264.96, 0, 30000L);
  } else if (key == 'p') {
    float[] pos = cam.getPosition();
    println("x="+pos[0]+", y="+pos[1]+", z="+pos[2]+", distance="+cam.getDistance()+", Zoomscale="+cam.getZoomScale()+", panScale="+cam.getPanScale()+", rotscale="+cam.getRotationScale());
  } else if (key == 'c') {
    capture = !capture;
    println("capture: "+capture);    
  }
  
}

