class Triangle {
  PVector p1;
  PVector p2;
  PVector p3;
  int col;

  int vSelect;
  int r;

  public Triangle() {
    r=int(random(21));
    //r=4;
    
    randomize();
  }

  private Triangle(int foo) {
  }

  int getRandomColor() {
    if (COLOR_MODE) {
      //return color(int(random(255)), int(random(255)), int(random(255)), random(255));
      int c=srcColor[int(random(srcColor.length))];
      return color(red(c), green(c), blue(c), random(255));
    }

    return color(int(random(255)), random(255));
  }

  void randomize() {
    p1=getRandomVector();
    p2=getRandomVector();
    p3=getRandomVector();
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

  PVector getRandomVector() {
    int w2 = monaImg.width/2;
    int h2 = monaImg.height/2;
    int rw2 = int(random(w2));
    int rh2 = int(random(h2));
    int w4 = monaImg.width/4;
    int h4 = monaImg.height/4;
    int rw4 = int(random(w4));
    int rh4 = int(random(h4));

    if (vSelect>5) {
      vSelect=0;
      r++;
      if (r>21) r=0;
    }
    else
      vSelect++;

    switch (r) {
    case 0:
      return new PVector( rw2, rh2 );

    case 1:
      return new PVector( rw2+w2, rh2 );

    case 2:
      return new PVector( rw2, rh2+h2 );

    case 3:
      return new PVector( rw2+w2, rh2 +h2);

    case 4:
      return new PVector(random(monaImg.width), random(monaImg.height));

      //5..21
    default:
      int ofs = r-5; //0..16
      int xofs=w4*(ofs%4);
      int yofs=h4*(ofs/4);
      return new PVector( rw4+xofs, rh4+yofs);
    }
  }
}

