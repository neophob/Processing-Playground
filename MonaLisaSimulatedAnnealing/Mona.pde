
class Mona {
  final int ROUNDS_PER_LAYER = 10000;

  final int MAX_LAYERS = 3;

  int[] TrianglesPerLayer = {
    64, 128, 512
  };  

  int maxLayer;
  int currentLayer;
  Triangle[][] form;

  float fitness;

  int xofs;

  /**
   * create new system
   */
  public Mona() {
    form = new Triangle[MAX_LAYERS][TrianglesPerLayer[2]];
    xofs=0;
    currentLayer=0;
    maxLayer=0;

    for (int j = 0; j < MAX_LAYERS; j++) {
      for (int i = 0; i < TrianglesPerLayer[j]; i++) {
        form[j][i] = new Triangle();
      }
    }
  }

  /**
   * clone a system
   */
  public Mona(Mona m) {
    form = new Triangle[MAX_LAYERS][TrianglesPerLayer[2]];
    for (int j = 0; j < MAX_LAYERS; j++) {
      for (int i = 0; i < TrianglesPerLayer[j]; i++) {
        form[j][i] = m.form[j][i].clone();
      }
    }
    currentLayer = m.currentLayer;
    maxLayer=m.maxLayer;
    
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
    rect(xofs, 0, monaImg.width, monaImg.height);

    //draw
    for (int j = 0; j < maxLayer+1; j++) {
      //println(round+" DRAW L"+j+" "+TrianglesPerLayer[j]);
      for (int i=0; i<TrianglesPerLayer[j]; i++) {        
        form[j][i].draw(xofs);
      }
    }

    //calculate    
    loadPixels();
    fitness = 0f;
    int ofs=xofs;
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
    //int layerNr = int(random(currentLayer));
    //int pos = int(random(TrianglesPerLayer[layerNr]));
    //    form[layerNr][pos].randomize();

    int s=int(random(TrianglesPerLayer[currentLayer]));
    //println(s+" "+currentLayer);
    form[currentLayer][s].randomize(currentLayer);
  }


  void triggerNextRound() {
    currentLayer++;    
    if (currentLayer>2) {
      currentLayer=0;
    }
    
    if (maxLayer<currentLayer) {
      maxLayer = currentLayer;
    }
  }


  final String DELIM = ";";

  void serialize(PrintWriter output) {
    for (int j = 0; j < MAX_LAYERS; j++) {
      for (int i = 0; i < TrianglesPerLayer[j]; i++) {
        Triangle t=form[j][i];
        int c = t.col&255;
        output.println(t.p1.x+DELIM+t.p1.y+DELIM+t.p2.x+DELIM+t.p2.y+DELIM+t.p3.x+DELIM+t.p3.y+DELIM+c);
      }
    }
  }
}

