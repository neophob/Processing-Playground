void drawText() {
  pushMatrix();

  translate(2*BOXSIZE, FONT_SIZE_HEADER, 15);
  textHeader.draw();
  
  translate(0, BOXSIZE*1+FONT_SIZE_SLOGAN, 0);
  textSlogan.draw();
  
  popMatrix();
}

