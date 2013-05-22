//final int NR_OF_TRIANGLES = 384;
final int NR_OF_TRIANGLES = 512;

/**
 * a triangle frame contains n triangles
 * randomize change ONE triangle per time
 * -> there is no local optimum as each randomize call generates a NEW content
 */
class TriangleFrame {
  Triangle[] form;

  private float fitness;

  /**
   * create new system
   */
  public TriangleFrame(int imagexSize, int imageYsize) {
    int nrOfTriangles = NR_OF_TRIANGLES;
    form = new Triangle[nrOfTriangles];

    for (int j = 0; j < form.length; j++) {
      form[j] = new Triangle();
    }

    fitness = 0;
  }

  /**
   * clone a system
   */
  public TriangleFrame(TriangleFrame m) {
    form = new Triangle[m.form.length];
    for (int j = 0; j < form.length; j++) {
      form[j] = m.form[j].clone();
    }

    fitness = m.fitness;
  }


  float diffAbs(int v1, int v2) {
    float f = v1-v2;
    if (f<0) {
      return (0-f)/255f;
    }
    return f/255f;
  }

  float getFitness() {
    if (fitness==0) {
      calcFitness();
    }

    return fitness;
  }

  void calcFitness() {
    fill(0);
    rect(0, 0, monaImg.width, monaImg.height);

    //draw
    for (int j = 0; j < form.length; j++) {
      form[j].draw();
    }

    //calculate    
    loadPixels();
    fitness = 0f;
    int ofs=0;
    int srcOfs = 0;
    for (int y=0; y<monaImg.height; y++) {
      for (int x=0; x<monaImg.width; x++) {
        //color src = monaImg.get(x, y);
        int src = srcColor[srcOfs]&255;
        int dst = pixels[ofs]&255;
        float diffR = diffAbs(src, dst);

        float pixelFitness;
        if (COLOR_MODE) {
          src = (srcColor[srcOfs]>>16)&255;
          dst = (pixels[ofs]>>16)&255;
          float diffG = diffAbs(src, dst);

          src = (srcColor[srcOfs]>>8)&255;
          dst = (pixels[ofs]>>8)&255;
          float diffB = diffAbs(src, dst);

          fitness += diffR*diffR + diffG*diffG + diffB*diffB;
        } else {
          fitness += diffR*diffR;
        }

        ofs++;
        srcOfs++;
      }
      ofs+=width-monaImg.width;
    }
    updatePixels();
  }

  //
  void randomize() {    
    form[int(random(form.length))].randomize();
    fitness = 0;
  }

  void shuffle() {    
    int src = int(random(form.length));
    int dst = int(random(form.length));
    Triangle t = form[src];
    form[src] = form[dst];
    form[dst] = t;
    fitness = 0;
  }
  
  final String DELIM = ";";

  void serialize(PrintWriter output) {
    for (int j = 0; j < form.length; j++) {      
      Triangle t=form[j];
      output.println(t.x1+DELIM+t.y1+DELIM+ t.x2+DELIM+t.y2+DELIM+ t.x3+DELIM+t.y3+DELIM+(t.col&0xffffffff));
    }
  }
}

