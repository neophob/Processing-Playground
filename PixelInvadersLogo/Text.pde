PImage crImage()
{
  PGraphics pg = createGraphics(400,20,JAVA2D);
  pg.beginDraw();
  pg.background(0,0,64);
  pg.fill(250);
  pg.textAlign(CENTER);
  //pg.textFont(ff, 16);
  pg.text("Hello World", 0, 0, 400, 20);
  pg.endDraw();
  PImage w = createImage(400,20,RGB);
  copy(pg, 0, 0, 400, 20, 0, 0, 400, 20);
  return w;    
}

void drawText(PImage tex) {
  pushMatrix();
  translate(0, 1, 0);

  beginShape(QUADS);
  texture(tex);

  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)
  
  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);
  
  endShape();
  popMatrix();
  
}

