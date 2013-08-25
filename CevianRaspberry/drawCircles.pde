void drawCircles() {
  int ofs;  
  int ofsy=0;
  for (int y=0; y<elementY; y++) {
    ofs = y*elementX;
    int ofsx=-1;
    for (int x=0; x<elementX; x++) {      
      if (ofs%4==0) ofsx++;      
      if (selectedElement[3][ofs]>0) drawCircle(ofsx, ofsy, SIZE_SMALL, ofs, (selectedElement[3][ofs])*(LIFETIME_ALPHA_MUL), 0);
      
      if (selectedElement[4][ofs]>0) drawCircle(ofsx/2, ofsy/2, 2*SIZE_SMALL, ofs, (selectedElement[4][ofs])*(LIFETIME_ALPHA_MUL), 1);
      if (selectedElement[5][ofs]>0) drawCircle(ofsx/4, ofsy/4, 4*SIZE_SMALL, ofs, (selectedElement[5][ofs])*LIFETIME_ALPHA_MUL+2, 2);      
      ofs++;
    }
    ofsy++;
  }
}


PShape[][] circles = new PShape[3][4];

//using arc is VERY slow, create pre renedered shapes
void initCircle() {  
  int s=0;
  for (int i=0; i<3; i++) {
    switch (i) {
      case 0: s=SIZE_SMALL; break;
      case 1: s=2*SIZE_SMALL; break;
      case 2: s=4*SIZE_SMALL; break;
    }
    circles[i][0] = createShape(ARC, 0, 0, s,s, 0, HALF_PI);
    circles[i][1] = createShape(ARC, 0, 0, s,s, HALF_PI, PI);
    circles[i][2] = createShape(ARC, 0, 0, s,s, PI, PI+HALF_PI);
    circles[i][3] = createShape(ARC, 0, 0, s,s, PI+HALF_PI, TWO_PI);    
    circles[i][0].setStrokeWeight(1);
    circles[i][1].setStrokeWeight(1);
    circles[i][2].setStrokeWeight(1);
    circles[i][3].setStrokeWeight(1);
  }
}

void drawCircle(int posx, int posy, int size, int pos, int alpha, int sizeSelector) {
  int x = posx*size+size/2;
  int y = posy*size+size/2;  
  int ofs = pos%4;
 
  circles[sizeSelector][ofs].setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
  circles[sizeSelector][ofs].setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
  canvas.shape(circles[sizeSelector][ofs], x, y);
}
/*

void drawCirclesSmall(int posx, int posy, int size, int pos, int alpha) {
  int x = posx*size+size/2;
  int y = posy*size+size/2;  
  int ofs = pos%4;
 
  if (ofs==0) {
    circleSmall0.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
  //  circleSmall0.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
    canvas.shape(circleSmall0, x, y);
    return;
  }

  if (ofs==1) {
    circleSmall1.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
  //  circleSmall1.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
    canvas.shape(circleSmall1, x, y);
    return;
  }

  if (ofs==2) {
    circleSmall2.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
  //  circleSmall2.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));    
    canvas.shape(circleSmall2, x, y);
    return;
  }
  
  circleSmall3.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
 // circleSmall3.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));  
  canvas.shape(circleSmall3, x, y);
}

////////////////////////////////
void drawCirclesMed(int posx, int posy, int size, int pos, int alpha) {
  int x = posx*size+size/2;
  int y = posy*size+size/2;  
  int ofs = pos%4;
 
  if (ofs==0) {
    circleMed0.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
 //   circleMed0.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
    canvas.shape(circleMed0, x, y);
    return;
  }

  if (ofs==1) {
    circleMed1.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
 //   circleMed1.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
    canvas.shape(circleMed1, x, y);
    return;
  }

  if (ofs==2) {
    circleMed2.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
//    circleMed2.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));    
    canvas.shape(circleMed2, x, y);
    return;
  }
  
  circleMed3.setFill(cs.getSmoothColor(colorBuffer[pos], alpha));
//  circleMed3.setStroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));  
  canvas.shape(circleMed3, x, y);
}
*/
