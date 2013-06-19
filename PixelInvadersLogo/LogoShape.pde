
int[] logo = new int[] {
  0, 1, 0, 1, 1, 0, 1, 0, 
  0, 0, 1, 1, 1, 1, 0, 0, 
  0, 1, 2, 1, 1, 2, 1, 0, 
  1, 1, 1, 1, 1, 1, 1, 1, 
  1, 0, 1, 1, 1, 1, 0, 1, 
  1, 0, 1, 0, 0, 1, 0, 1, 
  0, 0, 1, 0, 0, 1, 0, 0, 
  0, 1, 1, 0, 0, 1, 1, 0
};

void drawLogo() {
  pushMatrix();
  
  int y=0-(height-3*BOXSIZE)/2;  
  int x=(width-4*BOXSIZE)/2;  
//  translate(x, y, 0);
  translate(0, 0, 0);

  //translate(BOXSIZE, -BOXSIZE, 0);  
  for (int i=0; i<logo.length; i++) {
    int nextblock = logo[i];
    translate(BOXSIZE, 0, 0);

    if (i%8==0) {
      translate(-(BOXSIZE*8), BOXSIZE, 0);      
    }
    
    if (nextblock==1) {
      fill(255,255,255);    
      box(BOXSIZE);
    } 
    else if (nextblock==2) {
      fill(255,0,210);
      translate(0,0,2); 
      box(BOXSIZE);
      translate(0,0,-2);
    }
  }
  popMatrix();
}

