/*
ideas:
 -split image up in multiple parts and verify which are the badest parts.
 update triangles there
 -compare current result with "Random Sampling" heuristic
  -> after 10'000 iterations

          | Heuristic Method
Iteration | Random | SA, 100000, 0.003 | SA, 80000, 0.005 |
----------+--------+-------------------+------------------+
10000     | 14750  | 17309             | 14022            |
20000     | 10681  | 10900             | 10194            |
30000     | 9207   | 9273              | 8289             | 

 */
PImage monaImg;

final boolean COLOR_MODE = true;

final int BORDER_SIZE = 30;

int[] srcColor;

int interation=0;

Mona m;
long start=System.currentTimeMillis();

void setup() {
  //max framerate
  frameRate(500);

  if (!COLOR_MODE) {
    colorMode(RGB, 255);
  }

  //monaImg = loadImage("mona.jpg");
  //monaImg = loadImage("mona-col.jpg");
  //monaImg = loadImage("watch.jpg");
  //  monaImg = loadImage("comic.jpg");
  //monaImg = loadImage("dp.jpg");
  monaImg = loadImage("ego.jpg");

  monaImg.loadPixels();
  srcColor = monaImg.pixels;
  monaImg.updatePixels();

  size(monaImg.width*3, monaImg.height+BORDER_SIZE, P3D);
  background(0);  
  image(monaImg, monaImg.width*2, 0);

  m = new Mona();
  noStroke();
}

boolean finished=false;
boolean savedImage=false;
int round;

void draw() {
  round++;
  
  if (simulateAnnealing()) {
    interation++; 
    println("iteration: "+interation);
    resetSim();
  }

  if (round%50==1) { 
    fill(50);
    rect(0, monaImg.height, monaImg.width*3, BORDER_SIZE);
    fill(255);
    long time = (System.currentTimeMillis()-start)/1000;
    long last = (System.currentTimeMillis()-lastBest)/1000;
    String fitn = nf(bestFitness, 0, 2);
    String s = "round: "+round+" :: best: "+fitn+" :: temp: "+nf(temp, 0, 2)+" :: fps:"+int(frameRate)+" :: in "+time+"s :: last "+last+"s ago :: layer: "+m.currentLayer;
    text(s, 4, monaImg.height+BORDER_SIZE/2);
    //println(s);
  }
}

void saveImage() {
  String ts = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  PrintWriter output = createWriter(ts+"-vect-r"+round+"-v"+bestFitness+".txt");
  best.serialize(output);
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  saveFrame(ts+"-img-r"+round+"-v"+bestFitness+".jpg");
}

void keyPressed() {
  if (key=='s') {
    println("save");
    saveImage();
  }
}

