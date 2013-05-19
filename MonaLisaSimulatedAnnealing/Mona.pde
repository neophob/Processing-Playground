import java.util.*;

class Mona {
  final int NR_OF_VECTORS = 768;

  Triangle[] form;

  float fitness;

  int xofs;

  public Mona() {
    println("Create Mona using "+NR_OF_VECTORS+" triangles");
    form = new Triangle[NR_OF_VECTORS];
    xofs=0;

    for (int i = 0; i < NR_OF_VECTORS; i++) {
      form[i] = new Triangle();
    }

    println("create temp image, size: "+monaImg.width+" x "+monaImg.height);
  }

  //clone an instance
  public Mona(Mona m) {
    form = new Triangle[NR_OF_VECTORS];
    for (int i = 0; i < NR_OF_VECTORS; i++) {
      form[i] = m.form[i].clone();
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
    rect(xofs, 0, monaImg.width, monaImg.height);

    //draw
    for (int i=0; i<NR_OF_VECTORS; i++) {
      form[i].draw(xofs);
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
        float diffR = diffAbs(src,dst);
        
        float pixelFitness;
        if (COLOR_MODE) {
          src = (srcColor[srcOfs]>>16)&255;
          dst = (pixels[ofs]>>16)&255;
          float diffG = diffAbs(src,dst);
          
          src = (srcColor[srcOfs]>>8)&255;
          dst = (pixels[ofs]>>8)&255;
          float diffB = diffAbs(src,dst);
          pixelFitness = diffR*diffR + diffG*diffG + diffB*diffB;
        } else {
          pixelFitness = diffR*diffR;
        }
        
        ofs++;
        srcOfs++;
        fitness += pixelFitness;
      }
      ofs+=width-monaImg.width;
    }
    updatePixels();


    // perfect image: fitness = 0
    // worst case image: width*height*3 
    // 300 - 0 / 300 = 1.0f ->
    // 300 - 300 / 300 = 0.0f
    //  fitness = 1f-((worstCaseImage-fitness) / worstCaseImage);

    //  println(" - "+fitness+" "+worstCaseImage);
    //    if (fitness > 1.0f || fitness<0f) println("OOPS, invalid fitness value "+fitness);
    return fitness;
  }

  final String DELIM = ";";

  void serialize(PrintWriter output) {

    for (int i = 0; i < NR_OF_VECTORS; i++) {
      Triangle t=form[i];
      int c = t.col&255;
      output.println(t.p1.x+DELIM+t.p1.y+DELIM+t.p2.x+DELIM+t.p2.y+DELIM+t.p3.x+DELIM+t.p3.y+DELIM+c);
    }
  }
}

