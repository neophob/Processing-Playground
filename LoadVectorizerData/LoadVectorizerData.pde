final String VECTORFILE = "test.txt";
//final String VECTORFILE = "ego.txt";
final int  SIZE = 800;

float[][] triangles;
int[] col;

void setup() {
  loadVectorFile();
  size(SIZE, SIZE, P2D);
  background(0);
  noStroke();
  frameRate(8);  
  
}

float zoomFactor = 1.0f;
float mposX=0.0f;
float mposY=0.0f;

void draw() {
  background(0);
  if (mousePressed == true) {
    //zoom
    zoomFactor = mouseX/float(SIZE/2);
  } else {
    //position
    mposX = (mouseX)/float(SIZE) -0.5f;
    mposY = (mouseY)/float(SIZE) -0.5f;
  }
  drawVector();
}


void keyPressed() {
  if (key=='s') {
    println("save");
    String ts = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveFrame(ts+".jpg");
  }
}

void drawVector() {
  float imageWidth = zoomFactor*width;
  float imageHeight = zoomFactor*height;

  float xOfs = mposX*imageWidth;
  float yOfs = mposY*imageHeight;

  println("zoomFactorInPixels: "+zoomFactor+", xOfs: "+xOfs+", mposX: "+mposX);

  for (int i = 0 ; i < col.length; i++) {       
    float x1 = triangles[i][0]*imageWidth - xOfs;
    float x2 = triangles[i][2]*imageWidth - xOfs;
    float x3 = triangles[i][4]*imageWidth - xOfs;
    float y1 = triangles[i][1]*imageHeight - yOfs;
    float y2 = triangles[i][3]*imageHeight - yOfs;
    float y3 = triangles[i][5]*imageHeight - yOfs;

    float maxX = max(x1, x2, x3);
    float maxY = max(y1, y2, y3);
    if (maxX>100) maxX -= 100;
    if (maxY>100) maxY -= 100;
    if (maxX<100) maxX += 100;
    if (maxY<100) maxY += 100;
    
    if (maxX > 0 && maxY > 0 && maxX < width && maxY < height) {
      fill(col[i]);
      triangle(
        x1, y1, 
        x2, y2, 
        x3, y3
      );
    }
  }
}

void loadVectorFile() {
  String lines[] = loadStrings(VECTORFILE);  

  if (lines==null) {
    println("failed to load file: "+VECTORFILE);
    return;
  }

  col = new int[lines.length];
  triangles = new float[lines.length][6];

  for (int i = 0 ; i < lines.length; i++) {
    String[] entry = lines[i].split(";");
    col[i] = int(entry[6])&0xffffffff;

    if (alpha(col[i])<0.2f) {
      println(i+": low alpha: "+hex(col[i]));
    } 

    if (red(col[i])<0.2f && blue(col[i])<0.2f && green(col[i])<0.2f) {
      println(i+": low value: "+hex(col[i]));
    }

    triangles[i][0] = float(entry[0]); 
    triangles[i][2] = float(entry[2]);
    triangles[i][4] = float(entry[4]);
    triangles[i][1] = float(entry[1]); 
    triangles[i][3] = float(entry[3]);
    triangles[i][5] = float(entry[5]);
  }
}

