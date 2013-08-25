int directionX=0;
int directionPosX = 0;
int directionY=0;
int directionPosY = 0;
int fillerCnt=elementX;
int cnt=0;

final int LINE_WIDTH = 5;

int aniX=3;
int aniY=4;
int aniCnt=0;

void filler(int idx) {

  switch (idx) {
    case 0:
      fillerCircle(); 
      break;
    case 1:
      fillerInsideOut();
      break;
    case 2:
    //solid?
      filler6();
      break;
    case 3:
      //dirty sidewalls
      filler7();
      break;
    case 4:
      fillerSolid();
      break;
    case 5:
      fillerHoVeLines();
      break;
    case 6:
      fillerVerticalMove();
      break;
    case 7:
      fillerHorizontalMove();
      break;      
    case 8:
      fillerSnake();
      break; 
    case 9:
      fillerRect();
      break;
    case 99:
      fillerNone();
      break; 
   }
   
}

void fillerNone() {
  int pos=0;
  for (int y=0; y<elementY*elementX; y++) {
    colorBuffer[pos++] = 0;
  }
}

//line filler
void fillerSolid() {
  int pos=0;  
  fillerCnt++;
  if (fillerCnt>elementX*elementY) fillerCnt=elementX;
  
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      if (pos<fillerCnt) {
        colorBuffer[pos++] = cnt;
      } else {
        colorBuffer[pos++] = 0;
      }      
    }
  }
  cnt+=3;   
}

void fillerSnake() {
  int pos=0;
  directionPosX+=int(random(3))-1;
  directionPosY+=int(random(3))-1;
  
  cnt++;
  updateYPos();
  updateXPos();
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      int diffY = abs(directionPosY-x);
      int diffX = abs(directionPosX-y);
      if (diffX<3 && diffY<9/* || diffY>35 && diffX>6*/) {
        colorBuffer[pos++] = (cnt+(diffX+diffY))*4;
      } else {
        colorBuffer[pos++] = (cnt+(diffX+diffY))*4+128;
      }      
    }
  }
}

void fillerHorizontalMove() {
  int pos=0;  
  
  if (cnt%2==0) updateYPos();
  
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = 4*(x-directionPosY)+(cnt>>1);
    }
  }
  cnt+=1;    
}

void fillerVerticalMove() {
  int pos=0;
  
  updateXPos();
  
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = 4*(y-directionPosX)+(cnt>>2);
    }
  }
  cnt+=1;    
}

void fillerCircle() {
  int pos=0;
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = x*y+cnt;
    }
  }
  cnt+=1;  
}


void fillerInsideOut() {
  int pos=0;
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = x+y+cnt;
    }
  }
  cnt+=1;  
}

void filler6() {
  int pos=0;
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = (x%(y+1))+cnt;
    }
  }
  cnt+=1;  
}

void filler7() {
  int pos=0;
  cnt+=1;  
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      colorBuffer[pos++] = ((x+cnt)%(y+cnt));
    }
  }  
}

void drawRect(int x1, int y1, int sizeX, int sizeY, int col) {
  for (int y=0; y<sizeY; y++) {
    int pos = x1*4 + elementX*y;
    for (int x=0; x<sizeX*4; x++) {
      colorBuffer[pos++] = col;
    }
  }   
}

void fillerRect() {
  if (cnt%4==0) {
    int startY = int(random(elementY));
    int widthY = int(random(elementY-startY));

    int startX = int(random(elementX/4));
    int widthX = int(random(elementX/4-startX));
    
    drawRect(startX,startY, widthX, widthY, int(random(255)));
  }
  cnt++;
}

void fillerEqualizer() {
  int pos=0;
  drawRect(0,0,elementX/4, elementY, 0);
  //drawRect(3,3,(elementX-16)/4, elementY-4, 128);
  
  int bands = min(sa.getFft().avgSize(), elementX/8);
  println("bands: "+bands);
  for (int b=0; b<bands; b++) {
    float rawValue = int(sa.getBandData(b).currentBandEnergy);
    if (rawValue>255f) rawValue=255f;
    int eqHeigth = int((rawValue/255f)*elementY);  
    drawRect((elementX/4)-b*2,0,  2,eqHeigth,  int(rawValue/2));
  }
}

void fillerHoVeLines() {
  int pos=0;
  for (int y=0; y<elementY; y++) {
    for (int x=0; x<elementX; x++) {
      if (x>aniX*4 && x<(aniX+LINE_WIDTH)*4 || y>aniY && y<(aniY+LINE_WIDTH)) {
        colorBuffer[pos++] = y+x+cnt*2;
      } else {
        colorBuffer[pos++] = 0;
      }
    }
  }
  cnt++;
  aniCnt+=4;  
  if (aniCnt>FPS) {
    aniCnt=0;
    aniX++;
    aniY++;
    if (aniX >= elementX/4) aniX=-LINE_WIDTH;
    if (aniY >= elementY) aniY=-LINE_WIDTH;
  }
}

void updateYPos() {
  if (directionY==0) {
    directionPosY++;
  } else {
    directionPosY--;
  }
  
  if (directionPosY>elementY-1) {
    directionPosY=elementY-1;
    directionY=1;
  } else if (directionPosY<0) {
    directionPosY=0;
    directionY=0;
  }  
}

void updateXPos() {
  if (directionX==0) {
    directionPosX++;
  } else {
    directionPosX--;
  }
  
  if (directionPosX>elementX-1) {
    directionPosX=elementX-1;
    directionX=1;
  } else if (directionPosX<0) {
    directionPosX=0;
    directionX=0;
  }
}
