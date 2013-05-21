final int NR_OF_TRIANGLES = 384;

class Mona {
  Triangle[] form;

  float fitness;

  /**
   * create new system
   */
  public Mona() {
    form = new Triangle[NR_OF_TRIANGLES];

    for (int j = 0; j < NR_OF_TRIANGLES; j++) {
        form[j] = new Triangle();
    }
  }

  /**
   * clone a system
   */
  public Mona(Mona m) {
    form = new Triangle[NR_OF_TRIANGLES];
    for (int j = 0; j < NR_OF_TRIANGLES; j++) {
        form[j] = m.form[j].clone();
    }
  }


  float diffAbs(int v1, int v2) {
    float f = v1-v2;
    if (f<0) {
      return (0-f)/255f;
    }
    return f/255f;
  }

  float fitness() {
    fill(0);
    rect(0, 0, monaImg.width, monaImg.height);

    //draw
    for (int j = 0; j < NR_OF_TRIANGLES; j++) {
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

    return fitness;
  }

  void randomize() {
    form[int(random(NR_OF_TRIANGLES))].randomize();
  }


  final String DELIM = ";";

  void serialize(PrintWriter output) {
/*    for (int j = 0; j < MAX_LAYERS; j++) {
      for (int i = 0; i < TrianglesPerLayer[j]; i++) {
        Triangle t=form[j][i];
        int c = t.col&255;
//        output.println(t.p1.x+DELIM+t.p1.y+DELIM+t.p2.x+DELIM+t.p2.y+DELIM+t.p3.x+DELIM+t.p3.y+DELIM+c);
      }
    }*/
  }
}

