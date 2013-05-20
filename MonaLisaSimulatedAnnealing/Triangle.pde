class Triangle {
  PVector p1;
  PVector p2;
  PVector p3;
  int col;

  int vSelect;
  int r;

  public Triangle() {
    r=int(random(20));
    randomize(0);
  }

  public Triangle(int a) {
  }

  int getRandomColor() {
    if (COLOR_MODE) {
      if (random(50)<2) {
        return color(0,0,0, random(192));
      }
      //return color(int(random(255)), int(random(255)), int(random(255)), random(255));
      int c=srcColor[int(random(srcColor.length))];
      return color(red(c), green(c), blue(c), random(255));
    }

    return color(int(random(255)), random(224));
  }

  void randomize(int layer) {
    p1=getRandomVector(layer);
    p2=getRandomVector(layer);
    p3=getRandomVector(layer);
    col=getRandomColor();
  }

  void draw(int xofs) {
    fill(col);
    triangle(xofs+p1.x, p1.y, xofs+p2.x, p2.y, xofs+p3.x, p3.y);
  }

  Triangle clone() {
    Triangle t = new Triangle(0);
    t.p1=p1;
    t.p2=p2;
    t.p3=p3;
    t.col=col;
    t.vSelect=vSelect;
    t.r=r;
    return t;
  }  

  PVector getRandomVector(int layer) {
    int w2 = monaImg.width/2;
    int h2 = monaImg.height/2;
    int w4 = monaImg.width/4;
    int h4 = monaImg.height/4;


    int rw2 = int(random(w2));
    int rh2 = int(random(h2));
    int rw4 = int(random(w4));
    int rh4 = int(random(h4));

    if (vSelect>5) {
      vSelect=0;
      r++;
      if (r>20) r=0;
    }
    else
      vSelect++;


    switch (layer) {
    case 0:
      return new PVector(random(monaImg.width), random(monaImg.height));

    case 1:
      switch (r%4) {
      case 0:
        return new PVector( rw2, rh2 );

      case 1:
        return new PVector( rw2+w2, rh2 );

      case 2:
        return new PVector( rw2, rh2+h2 );

      case 3:  
      default:    
        return new PVector( rw2+w2, rh2 +h2);
      }


    case 2:
      int ofs = r%15; //0..16
      int tx=w4*(ofs%4);
      int ty=h4*(ofs/4);
      return new PVector( rw4+tx, rh4+ty);
      
    default:
      println("ERROR!"+layer);
      return null;      
    }
  }
}

