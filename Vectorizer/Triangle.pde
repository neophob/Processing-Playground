
class Triangle {
  float x1, x2, x3, y1, y2, y3;
  int col;

  public Triangle() {
    randomizeVectors();
    randomizeColor();
  }


  Triangle clone() {
    Triangle t = new Triangle("");
    t.x1=x1;
    t.x2=x2;
    t.x3=x3;
    t.y1=y1;
    t.y2=y2;
    t.y3=y3;
    t.col=col;
    return t;
  }  

  public Triangle(String a) {
    //dummy constructor
  }

  //rndomize color
  void randomizeColor() {
    if (COLOR_MODE) {
      int c=srcColor[int(random(srcColor.length))];
      col=(c & 0xffffff) | ((48+int(random(207))) << 24);
    } else {
      col=color(int(random(255)), 48+random(207));
    }
  }

  void randomize() {
    randomizeVectors();
    randomizeColor();
  }

  void draw() {
    fill(col);
    triangle(x1, y1, x2, y2, x3, y3);
  }

  //2000: 3100 ditto
  //3000: 2057 2300
  //5000: 1400 1480
  //6000: 1260 1260
  //8000:      1050
  //10k:        930
  //12k:        840
  //20k:        671

  void randomizeVectors() {    
    float angle = random(360);

    int rl1 = int(random(4));
    int rl2 = int(random(4));

    float l1 = random(monaImg.width/(8+rl1));
    float l2 = random(monaImg.height/(8+rl2));

    float x = random(monaImg.width);
    float y = random(monaImg.height);

    float deg = (angle) % TWO_PI;
    float f = x+cos(deg)*l1;
    x1 = f>monaImg.width ? monaImg.width: f;
    f = y+sin(deg)*l2;
    y1 = f>monaImg.height ? monaImg.height: f;

    deg = (1*2*THIRD_PI + angle) % TWO_PI;
    f = x+cos(deg)*l1;
    x2 = f>monaImg.width ? monaImg.width: f;
    f = y+sin(deg)*l2;
    y2 = f>monaImg.height ? monaImg.height: f;

    deg = (2*2*THIRD_PI + angle) % TWO_PI;
    f = x+cos(deg)*l1;
    x3 = f>monaImg.width ? monaImg.width: f;
    f = y+sin(deg)*l2;
    y3 = f>monaImg.height ? monaImg.height: f;
  }
}

