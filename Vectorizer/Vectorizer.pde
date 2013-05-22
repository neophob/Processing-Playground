/*
ideas:
 -split image up in multiple parts and verify which are the badest parts.
 update triangles there
 -compare current result with "Random Sampling" heuristic
  -> after 10'000 iterations

          | Heuristic Method
Iteration | Random | SA, 1000000/0.99 | SA, 10000/0.999 | SA, 10000/0.99 | no 
----------+--------+------------------+-----------------+----------------+--------
1000      | 25000  | 41000            | 46000           | 31000          | 35000 38k 29k 31k
2000      | 18000  | 23000            | 38000           | 19500          | /28k 23k
5000      | 12000  | 13400            | 25000           | 12900          | 14k

 */
PImage monaImg;

final boolean COLOR_MODE = true;

final int BORDER_SIZE = 30;

int[] srcColor;

int iteration=0;

long start=System.currentTimeMillis();
boolean finished=false;
boolean savedImage=false;
int round;

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
  
  noStroke();  
  
  initHeuristic();
}


void draw() {
  round++;
  
  //randomHeuristic();
  //simulateAnnealing();
  greedyHeuristic();

  if (round%20==0) { 
    fill(50);
    rect(0, monaImg.height, monaImg.width*3, BORDER_SIZE);
    fill(255);
    long time = (System.currentTimeMillis()-start)/1000;
    long last = (System.currentTimeMillis()-lastBest)/1000;
    String fitn = nf(bestSolution.fitness, 0, 2);
    String s = "round: "+round+" :: best: "+fitn+" :: temp: "+nf(saTemp, 0, 2)+" :: fps:"+int(frameRate)+" :: in "+time+"s :: last "+last+"s ago";
    text(s, 4, monaImg.height+BORDER_SIZE/2);
    //println(s);
  }
}

void saveImage() {
  String ts = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  PrintWriter output = createWriter(ts+"-vect-r"+round+"-v"+bestSolution.fitness+".txt");
  bestSolution.serialize(output);
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  saveFrame(ts+"-img-r"+round+"-v"+bestSolution.fitness+".jpg");
}

void keyPressed() {
  if (key=='s') {
    println("save");
    saveImage();
  }
}

