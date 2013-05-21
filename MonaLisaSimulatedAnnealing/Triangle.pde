class Triangle {
  PVector p1;
  PVector p2;
  PVector p3;
  int col;

  int layer;
  int vSelect;
  int r;

  public Triangle(int layr) {
    r=int(random(20));
    layer=layr;
    randomize();
  }

  public Triangle(String a) {
  }

  //rndomize color
  void randomizeColor() {
    if (COLOR_MODE) {
      if (random(50)<2) {
        col=color(0,0,0, random(192));
        return;
      }
      //return color(int(random(255)), int(random(255)), int(random(255)), random(255));
      int c=srcColor[int(random(srcColor.length))];
      col=color(red(c), green(c), blue(c), random(255));
      return;
    }

    col=color(int(random(255)), random(224));
  }

  void randomize() {
    randomizeVectors();
    randomizeColor();
  }

  void draw(int xofs) {
    fill(col);
    triangle(xofs+p1.x, p1.y, xofs+p2.x, p2.y, xofs+p3.x, p3.y);
  }

  Triangle clone() {
    Triangle t = new Triangle("");
    t.p1=p1;
    t.p2=p2;
    t.p3=p3;
    t.col=col;
    t.vSelect=vSelect;
    t.r=r;
    t.layer=layer;
    return t;
  }  

  void randomizeVectors() {
    int w2 = monaImg.width/2;
    int h2 = monaImg.height/2;
    int w4 = monaImg.width/4;
    int h4 = monaImg.height/4;


    r++;
    
    switch (layer) {
    case 0:
      p1 = new PVector(random(monaImg.width), random(monaImg.height));
      p2 = new PVector(random(monaImg.width), random(monaImg.height));
      p3 = new PVector(random(monaImg.width), random(monaImg.height));
      return; 

    case 1:
      switch (r%4) {
      case 0:
        p1 = new PVector( int(random(w2)), int(random(h2)) );
        p2 = new PVector( int(random(w2)), int(random(h2)) );
        p3 = new PVector( int(random(w2)), int(random(h2)) );
        return;
        
      case 1:
        p1 = new PVector( int(random(w2))+w2, int(random(h2)) );
        p2 = new PVector( int(random(w2))+w2, int(random(h2)) );
        p3 = new PVector( int(random(w2))+w2, int(random(h2)) );
        return;
        
      case 2:
        p1 = new PVector( int(random(w2)), int(random(h2))+h2 );
        p2 = new PVector( int(random(w2)), int(random(h2))+h2 );
        p3 = new PVector( int(random(w2)), int(random(h2))+h2 );
        return;

      case 3:  
      default:    
        p1 = new PVector( int(random(w2))+w2, int(random(h2))+h2);
        p2 = new PVector( int(random(w2))+w2, int(random(h2))+h2);
        p3 = new PVector( int(random(w2))+w2, int(random(h2))+h2);
        return;
      }


    case 2:
      int ofs = r%16; //0..16
      int tx=w4*(ofs%4);
      int ty=h4*(ofs/4);
      p1 = new PVector(  int(random(w4))+tx,  int(random(h4))+ty);
      p2 = new PVector(  int(random(w4))+tx,  int(random(h4))+ty);
      p3 = new PVector(  int(random(w4))+tx,  int(random(h4))+ty);
      return;
      
    default:
      println("ERROR!"+layer);
      return;      
    }
  }
}

