void drawTriangles() {
  int ofs;  
  int ofsy=0;
  for (int y=0; y<elementY; y++) {
    ofs = y*elementX;
    int ofsx=-1;
    for (int x=0; x<elementX; x++) {      
      if (ofs%4==0) ofsx++;              
      if (selectedElement[0][ofs]>0) drawQuader(ofsx, ofsy, SIZE_SMALL, ofs, (selectedElement[0][ofs])*(LIFETIME_ALPHA_MUL));
      
      if (selectedElement[1][ofs]>0) drawQuader(ofsx/2, ofsy/2, 2*SIZE_SMALL, ofs, (selectedElement[1][ofs])*(LIFETIME_ALPHA_MUL));
      if (selectedElement[2][ofs]>0) drawQuader(ofsx/4, ofsy/4, 4*SIZE_SMALL, ofs, (selectedElement[2][ofs])*LIFETIME_ALPHA_MUL+2);
      ofs++;
    }
    ofsy++;
  }
}

//fill the selected elements with the fill color 
void setDrawOptions(int pos, int alpha) {
//noborders  
//  canvas.fill(cs.getSmoothColor(colorBuffer[pos]), alpha);
//  canvas.stroke(cs.getSmoothColor(colorBuffer[pos]), 170);
  if (alpha>255) alpha=255;
  canvas.fill(cs.getSmoothColor(colorBuffer[pos]), alpha);
  canvas.stroke(cs.getSmoothColor(colorBuffer[pos]+128), 128);

}

void drawQuader(int posx, int posy, int size, int pos, int alpha) {
  int x = posx*size;
  int y = posy*size;
  int s2=size/2;
  int ofs = pos%4;
 
  setDrawOptions(pos, alpha);
  //canvas.fill(cs.getSmoothColor(colorBuffer[pos], alpha));
  //canvas.stroke(cs.getSmoothColor(colorBuffer[pos]+128, STROKE_WEIGHT));
 
  if (ofs==0) {    
    canvas.triangle(x, y, x, y+size, x+s2, y+s2);
    return;
  }

  if (ofs==1) {
    canvas.triangle(x, y, x+size, y, x+s2, y+s2);
    return;
  }

  if (ofs==2) {
    canvas.triangle(x+size, y, x+size, y+size, x+s2, y+s2);
    return;
  }

  canvas.triangle(x, y+size, x+size, y+size, x+s2, y+s2);
}
