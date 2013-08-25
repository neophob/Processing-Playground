//inspired by http://crowquills.com/

import ddf.minim.*;
import ddf.minim.analysis.*;

/////////////////////////////////////////////////////////
//constants
/////////////////////////////////////////////////////////
//if set to true, the current resolution will be used
final boolean FULLSCREEN = false;
final boolean SHOW_EQ = false;
final boolean SHOW_PALETTE = false;

//intro part: after 60s
//outro part: after 210s
final String SONGNAME = "MineX - Raspberry (Short Edit).mp3";

//if sketch is not running in fullscreen mode, use this resolution
final int WINDOWED_SIZE_X = 1280;
final int WINDOWED_SIZE_Y = 720;
final int FPS = 35;

//28
final float LIFETIME = 30;
final int LIFETIME_ALPHA_MUL = 5;
final int MAXIMAL_ENABLED_ELEMENTS = 1100;
final int MINIMAL_ENABLED_ELEMENTS = 550;

//band beat energy to color value
final float COLOR_LOOP_MUL = 20;
final int COLOR_LOOP_MUL_MAX = 55;

//size of a small geometry thing
final int SIZE_SMALL = 40;

final int RGB_SHIFT_BAND = 0;
final int ANIMATION_CHANGE_BAND = 1;
final int COLOR_CHANGE_BAND = 4;

final int ANIMATION_BAND = 2;

final int MAX_EFFECTIDX=10;

final int FRAME_DELAY_BETWEEN_ANIMATIONS = 8;
final int FRAME_DELAY_BETWEEN_RGB_SHIFT = FPS*3;
final int NO_ANIMATION_ID = 99;

final int STROKE_WEIGHT = 128;
/////////////////////////////////////////////////////////
//variables
/////////////////////////////////////////////////////////
ColorSet[] allColorsets;
int[] colorBuffer;

int[][] selectedElement;
int elementX, elementY;
ColorSet cs;
int csIdx;

int effectIdx=NO_ANIMATION_ID;

float rgbShiftAmount=0;
float rgbShiftAngle=0;
int rgbShiftCounter=0;

float shakeAmount=0;
int shakeCounter=0;

SoundAnalyzer sa;

PShader shader;
PGraphics canvas;
float ff=0;
float glitchX=0, glitchY=0;
TextDisplay textDisplay;

int lastAnimationChange=0;
int lastColorChange=0;
int lastRGBShift=0;

int textAlphaNr=0;
int activeElementCount=999;
boolean soundActive=false;

/////////////////////////////////////////////////////////
//init
/////////////////////////////////////////////////////////
public void setup() {
  int resX = WINDOWED_SIZE_X;
  int resY = WINDOWED_SIZE_Y;
  if (FULLSCREEN) {
    resX = displayWidth;
    resY = displayHeight;
  }

  size(resX, resY, OPENGL);  
  canvas = createGraphics(width, height, OPENGL);
  elementX = 4*resX/2/SIZE_SMALL;
  elementY = resY/2/SIZE_SMALL;
  colorBuffer = new int[elementX*elementY];
  selectedElement = new int[6][elementX*elementY];  
  //println("elementX: "+elementX+", elementY: "+elementY);
  
  shader = loadShader("colorShift.glsl");    
  shader.set("glitchOfs", 0f, 0f);
  shader.set("distortion", 0.2f);
  shader.set("zoom", 0.86f);
  
  sa = new SoundAnalyzer(this, SONGNAME);
  
  ellipseMode(CORNER);
  shapeMode(CORNER);
  smooth();
  frameRate(FPS);
  
  allColorsets = new ColorSet[5];
  allColorsets[0] = new ColorSet("1",     new int[] { color(#000000), color(#aaaaaa), color(#aaaaaa), color(#F2F2F2) } );
  allColorsets[1] = new ColorSet("2",     new int[] { color(#000000), color(#C6E070), color(#C6E070), color(#F2F2F2) } );
  allColorsets[2] = new ColorSet("3",     new int[] { color(#000000), color(#91C46C), color(#91C46C), color(#F2F2F2) } );  
  allColorsets[3] = new ColorSet("4",     new int[] { color(#000000), color(#287D7D), color(#287D7D), color(#F2F2F2) } );
  allColorsets[4] = new ColorSet("5",     new int[] { color(#000000), color(#1C344D), color(#1C344D), color(#F2F2F2) } );

  csIdx = 3;
  cs=allColorsets[csIdx];
  
  canvas.stroke(cs.getSmoothColor(0), 128);
  canvas.strokeCap(SQUARE);
  canvas.strokeWeight(1);
  canvas.smooth();
  
  initCircle();
  textDisplay = new TextDisplay();
}

/////////////////////////////////////////////////////////
//main loop
/////////////////////////////////////////////////////////
public void draw() {
  if (!soundActive) {
    soundActive=true;
    sa.play();
    return;
  }
  
  canvas.beginDraw();
  canvas.background(cs.getSmoothColor(0));
  canvas.stroke(cs.getSmoothColor(0), 170);
  
  //fill colorBuffer
  filler(effectIdx);  
  
  //get audio input parameter
  sa.soundProcess();
  
  boolean isRgbBandBoom = sa.getBandData(RGB_SHIFT_BAND).boom;
  boolean isAnimationBandBoom = sa.getBandData(ANIMATION_CHANGE_BAND).boom;
  boolean isColorBandBoom = sa.getBandData(COLOR_CHANGE_BAND).boom;
  
  //apply audio parameter to visuals
  if (isAnimationBandBoom) {
    //println(sa.getBandData(BOOM_BAND).loops+" - "+sa.getBandData(BOOM_BAND).currentBandEnergy+" - "+(sa.getBandData(BOOM_BAND).currentBandEnergy / sa.getBandData(BOOM_BAND).maxBandEnergy));
    if (textDisplay.isUpdateAnimation() && lastAnimationChange>FRAME_DELAY_BETWEEN_ANIMATIONS && int(random(2))==1) {
      effectIdx = int(random(MAX_EFFECTIDX));
      lastAnimationChange = 0;      
    } else if (!textDisplay.isUpdateAnimation()) {
      effectIdx = NO_ANIMATION_ID;
    }
    selectRandomElements(sa.getBandData(ANIMATION_CHANGE_BAND).loops, 0);    
  } 
  lastAnimationChange++;
  
  //select colorset, add circles
  if (isColorBandBoom) {
    if (textDisplay.isUpdateColors() && lastColorChange>FRAME_DELAY_BETWEEN_ANIMATIONS && int(random(2))==1) {
      cs=allColorsets[int(random(allColorsets.length-1))]; 
      lastColorChange = 0;     
    }
    selectRandomElements(sa.getBandData(COLOR_CHANGE_BAND).loops, 3);
  }
  lastColorChange++;
  
  //rgb color shift
  if (rgbShiftCounter==0 && isRgbBandBoom && lastRGBShift>FRAME_DELAY_BETWEEN_RGB_SHIFT) {  
     //rgbShiftCounter = 2*int(random(sa.getBandData(RGB_SHIFT_BAND).loops));
     lastRGBShift = 0;
     rgbShiftCounter = 1*sa.getBandData(RGB_SHIFT_BAND).loops;
     rgbShiftAmount = sa.getBandData(RGB_SHIFT_BAND).loops/2000f;
     rgbShiftAngle = (sa.getBandData(RGB_SHIFT_BAND).currentBandEnergy*720f)%360f;        
  }
  lastRGBShift++;

  //shaker
  if (shakeCounter<15 && isAnimationBandBoom) {    
    shakeCounter = sa.getBandData(ANIMATION_CHANGE_BAND).loops;
   shakeAmount = 2*sa.getBandData(ANIMATION_CHANGE_BAND).loops/1400f;      
  }  
  
  //draw elements  
  drawTriangles();
  drawCircles();    
  canvas.endDraw(); 

  //decrease lifetime
  activeElementCount = 0;
  for (int i=0; i<6; i++) {
    for (int j=0; j<colorBuffer.length; j++) {
      if (selectedElement[i][j]>0) {
        selectedElement[i][j]--;
        activeElementCount++;        
      }
     //selectedElement[i][j]=30;
    }
  }  
  
  //apply shader options
  if (rgbShiftCounter>0) {
    rgbShiftCounter--;
    shader.set("ammount", rgbShiftAmount);
    shader.set("angle", rgbShiftAngle);
    //rgbShiftAmount*=0.7f;
  } else {
    shader.set("ammount", 0.0f);
  }
  
  if (shakeCounter>0) {
    shakeCounter--;
    glitchX=sin(shakeCounter)*shakeAmount;
    glitchY=cos(shakeCounter)*shakeAmount;
    shader.set("glitchOfs", glitchX, glitchY);
    shader.set("zoom", 0.86f-glitchX/2);
    //shakeAmount/=2;
    shakeAmount*=0.6f;
  } else {
    shader.set("glitchOfs", 0f, 0f);
    shader.set("zoom", 0.86f);
  }

  //fragment processing
  shader(shader);
  image(canvas, 0, 0, width, height); 
  resetShader();  
  
  //display text
  if (frameCount > FPS*1) {
    textDisplay.showText(textAlphaNr);  
    sa.drawValues(textAlphaNr);
    if (textDisplay.isOsdFadeOut()) {
      if (textAlphaNr>0) textAlphaNr--;
    } else
      if (textAlphaNr<50) {
        textAlphaNr++;
      }
  }
  
  //saveFrame("C:\\Users\\xxx\\Documents\\1\\#####.tif");
  if (SHOW_EQ) {
    sa.drawEq();
  }  
  
  if (SHOW_PALETTE) {
    loadPixels();
    for (int i=0; i<allColorsets.length; i++) {
      ColorSet cose = allColorsets[i];
      int p;
      for (int y=i*20; y<i*20+20; y++) {
        p=y*width+200;
        for (int x=0; x<255; x++) {
          pixels[p++] = cose.getSmoothColor(x);
        }
      }
    }
    updatePixels();
  }
  
  //draw intro logo
/*  fill(255, 32);
  noStroke();
  int glitchOfsX = 30+textDisplay.getGx();
  int glitchOfsY = textDisplay.getGy();
  triangle(1000+glitchOfsX+25, 1+glitchOfsY, 1000+glitchOfsX, 1+glitchOfsY+50,  1000+glitchOfsX+50, 1+glitchOfsY+50);
  rect(1060+glitchOfsX, 1+glitchOfsY, 50, 50);  
  ellipse(1120+glitchOfsX, 1+glitchOfsY, 50, 50);*/
  
  
//  if (int(frameCount)%100==0) println("fps: "+frameRate);
}

/////////////////////////////////////////////////////////
//pre exit hook
/////////////////////////////////////////////////////////
void stop() {
  sa.closeMinim();
}

/////////////////////////////////////////////////////////
//just select some random elements to light up, define its life time but NOT the color
/////////////////////////////////////////////////////////
void selectRandomElements(int loops, int ofs) {
    if (activeElementCount>MAXIMAL_ENABLED_ELEMENTS) {
      return;
    }
    if (activeElementCount<MINIMAL_ENABLED_ELEMENTS) {
      loops += COLOR_LOOP_MUL_MAX/2;
    }
    int maxElements = colorBuffer.length;
    for (int i=0; i<loops; i++) {
      selectedElement[0+ofs][int(random(maxElements))] = int(3*LIFETIME+random(4));

      if (i%2==1) {
        selectedElement[1+ofs][int(random(maxElements))] = int(2*LIFETIME+random(4));
      }
      if (i%4==1) {
        selectedElement[2+ofs][int(random(maxElements))] = int(LIFETIME+random(4));
      }
    }
}

boolean sketchFullScreen() {
  return FULLSCREEN;
}

  

