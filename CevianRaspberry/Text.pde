class TextDisplay {
  private final long DISPLAY_TIME_IN_MS = 3000;
  private final long WAIT_TIME_IN_MS = 1000;
  private final long FADE_TIME_IN_MS = 500;
  private final boolean LOOP = false;
  
  private float displayOfsX=0;
  private int displayOfsY=0;
  private int txtAlpha=0;
  private int ofs = 0;
  private String[] content;
  private String[] geoTerms;
  private PFont font;
  private int enableColor=999;
  private int enableAnimation=999;
  private int disableColor=999;
  private int disableAnimation=999;
  private int fadeOutOsd=999;
  private int exitSketch=-1;
  
  private boolean updateColors = false;
  private boolean updateAnimation = false;
  private boolean osdFadeOut = false; 
  
  private int gx,gy;
  private boolean timeInitialized=false;
  /*
    FSM:
    0 : increasing alpha
    1 : display text
    2 : decreasing alpha
    3 : wait    
    99: finished
  */
  int state=0;
  
  long startTime;
  long initialTime;
  
  public TextDisplay() {
    content = new String[54];
    int i=0;
    content[i++] = "";
    content[i++] = "VANTAGE (WD) AND PIXELINVADERS";
    
    content[i++] = "PRESENT";
    content[i++] = "A DEMO FOR";
//20s    
    enableColor(i);
    content[i++] = "DEMODAYS 2013";   
    content[i++] = "called \"Cevian Raspberry\"";
    
    enableAnimation(i);
    content[i++] = "";     
    content[i++] = "";
//40s    
    content[i++] = "";        
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//60s    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//80s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//100s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//120s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//140s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//160s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";
//180s
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
    content[i++] = "";    
//200s    

//needed time from here: 40s
    content[i++] = "";    
    disableAnimation(i);    
    content[i++] = "credits";    
    content[i++] = "code/design: michu/pxv/vtg";        
    content[i++] = "pixelinvaders.ch";
    content[i++] = "music: minex";    
    content[i++] = "soundcloud.com/minex";
    fadeOutOsd(i);
    content[i++] = "";
    content[i++] = "";
    content[i++] = "";        
    exitSketch(i);
    content[i++] = "";
    
    i=0;
    geoTerms = new String[24];    
    geoTerms[i++] = "Annulus";
    geoTerms[i++] = "Apothem";
    geoTerms[i++] = "Adjacent";
    geoTerms[i++] = "Abscissa";
    geoTerms[i++] = "Cevian";
    geoTerms[i++] = "Concentric";
    geoTerms[i++] = "Heptagon";
    geoTerms[i++] = "icosahedron";
    geoTerms[i++] = "Radicand";
    geoTerms[i++] = "Oblique";
    geoTerms[i++] = "Semicircle";
    geoTerms[i++] = "Tessellate";    
    geoTerms[i++] = "Contraction";
    geoTerms[i++] = "Equidistant";
    geoTerms[i++] = "Glide";
    geoTerms[i++] = "Dodecagon";
    geoTerms[i++] = "Invariant";
    geoTerms[i++] = "Mean";
    geoTerms[i++] = "Vertex";
    geoTerms[i++] = "Segment";
    geoTerms[i++] = "sin";
    geoTerms[i++] = "cos";
    geoTerms[i++] = "arc";
    geoTerms[i++] = "tan";
    
    
    font = loadFont("OstrichSansRounded-Medium-72.vlw");
    textFont(font, 72);
    textSize(72);
    textAlign(LEFT, TOP);        
  }
  
  int geoTermIdx=0;
  void showText(int alpha) {
    if (!timeInitialized) {
      initFsm();
      timeInitialized= true;
      initialTime = startTime;
      return;
    }
    gx = int(500f*glitchX);
    gy = int(500f*glitchY);
    
    fill(255, alpha);
    text(activeElementCount, gx, gy+50);
    if (frameCount%5==2) {
      geoTermIdx=int(random(geoTerms.length));
    }
    text(geoTerms[geoTermIdx],gx, gy);
    
    if (state==99) {
      return;
    }
    
    fill(255, txtAlpha);
    if (!content[ofs].isEmpty()) {
      text(content[ofs], displayOfsX-gx, displayOfsY-gy);
    }    
    
    switch(state) {
      //fadein
      case 0:
        if (txtAlpha<128) {
          txtAlpha=increaseAlpha();
        } else {
          updateState(1);
        }
        break;
      
      //show text
      case 1:
        displayOfsX-=0.5f;
        if (waitIsOver(DISPLAY_TIME_IN_MS)) {
          updateState(2);
        }
        if (ofs==enableColor) {
          updateColors=true;
        }
        if (ofs==enableAnimation) {
          updateAnimation=true;
        }
        if (ofs==disableColor) {
          updateColors=false;
        }
        if (ofs==disableAnimation) {
          updateAnimation=false;
        }
        if (ofs==exitSketch) {
          exit();
        }
        if (ofs==fadeOutOsd) {
          osdFadeOut=true;
        }
        
        break;
      
      //fadeout
      case 2:
        displayOfsX-=0.5f;
        if (txtAlpha>1) {
          txtAlpha=decreaseAlpha();
        } else {
          updateState(3);
        }
        break;
        
      //next
      case 3:
        if (waitIsOver(WAIT_TIME_IN_MS)) {
          initFsm();
          if (ofs++>=content.length-1) {
            if (LOOP) {
              //Restart text
              ofs=0;
            } else {
              //no more text
              state=99;
            }            
          }          
        }        
        break;        
    }
  }
  
  private void updateState(int newState) {
    state=newState;
    startTime = System.currentTimeMillis();
    if (newState==1 && ofs>0) {
      long delta = (startTime-initialTime) - ofs*(DISPLAY_TIME_IN_MS+WAIT_TIME_IN_MS+2*FADE_TIME_IN_MS);
      //println(ofs+", newstate: "+newState+", diff: "+(startTime-initialTime)+", delta: "+delta);
      
      //adjust time delta, needed for slow machines to stay in sync
      startTime-=delta;
    }
  }
  
  //fadein in FADE_TIME_IN_MS ms.
  private int increaseAlpha(){
    long timeDiff = System.currentTimeMillis()-startTime; 
    // 10 / 500 = 0.02*128 
    float alphaValue = 128f*((float)timeDiff / (float)FADE_TIME_IN_MS);
    if (alphaValue>128f) alphaValue=128f;
    //println("fadein: "+alphaValue+" timeDiff:"+timeDiff);
    return int(alphaValue);
  }

  private int decreaseAlpha(){
    return 128-increaseAlpha();
  }
  
  private boolean waitIsOver(long timeToWait) {
    long timeDiff = System.currentTimeMillis()-startTime;
    if (timeDiff > timeToWait) {
      return true;
    }
    return false;
  }
  
  //returns true if MINEX is displayed
  public boolean isUpdateColors() {
    return updateColors;
  }

  public boolean isUpdateAnimation() {
    return updateAnimation;
  }
  
  public boolean isOsdFadeOut() {
    return osdFadeOut;
  }

  private void enableColor(int i) {
    enableColor = i;
  }
  
  private void fadeOutOsd(int i) {
    fadeOutOsd = i;
  }

  private void enableAnimation(int i) {
    enableAnimation = i;
  }

  private void disableColor(int i) {
    disableColor = i;
  }

  private void disableAnimation(int i) {
    disableAnimation = i;
  }
  
  private void exitSketch(int i) {
    exitSketch = i;
  }  
  
  private void initFsm() {
    state=0;
    txtAlpha=0;
    startTime = System.currentTimeMillis();
    displayOfsX = width-800+int(random(100));
    displayOfsY = height-200+int(random(100));
  }
  
  public int getGx() {
    return gx;
  }

  public int getGy() {
    return gy;
  }
}

