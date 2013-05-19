//best 3203
//3143, round 128'000
//3002, round 145'000
//2806, roung 158'000
//2263, round 175'000
//1508, round 200'000 start looking link mona
//1051, round 226'000

//3543, round 128'000
//3308, round 145'000
//2236, round 175'000
//1532, round 200'000 start looking link mona
//1065, round 226'000

//1572, round 200'000 s
//1149, round 222'000

PImage monaImg;

final boolean COLOR_MODE = true;

final int BORDER_SIZE = 30;

int[] srcColor;

Mona m;
long start=System.currentTimeMillis();

void setup() {
  //max framerate
  frameRate(500);
  
  if (!COLOR_MODE) {
    colorMode(RGB, 255);
  }
  
  monaImg = loadImage("mona.jpg");
  //monaImg = loadImage("watch.jpg");
//  monaImg = loadImage("comic.jpg");
  //monaImg = loadImage("galaxysiiititle.jpg");
  //monaImg = loadImage("dp.jpg");
  
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
  if (!finished) {
    finished=simulateAnnealing();
  } 
  else {
    if (!savedImage) {
      saveImage();
      savedImage=true;
    }
    finished = false; 
    resetSim();
  }

  if (round++%100==1) {
    fill(50);
    rect(0, monaImg.height, monaImg.width*3, BORDER_SIZE);
    fill(255);
    long time = (System.currentTimeMillis()-start)/1000;
    long last = (System.currentTimeMillis()-lastBest)/1000;
    String fitn = nf(bestFitness,0,2);
    String s = "round: "+round+" :: best: "+fitn+" :: temp: "+int(temp)+" :: fps:"+int(frameRate)+" :: in "+time+"s :: last "+last+"s ago";
    text(s, 4, monaImg.height+BORDER_SIZE/2); 
  }
}

void saveImage() {
    String ts = year() + nf(month(),2) + nf(day(),2) + "-"  + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    PrintWriter output = createWriter(ts+"-vect-r"+round+"-v"+bestFitness+".txt");
    best.serialize(output);
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
   
    saveFrame(ts+"-img-r"+round+"-v"+bestFitness+".jpg");
    //best.img.save(ts+"-img-r"+round+"-v"+bestFitness+".jpg");  
}

void keyPressed() {
   if (key=='s') {
      println("save");
      saveImage();
   } 
}
