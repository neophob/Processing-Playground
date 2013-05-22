final String VECTORFILE = "test.txt";
final float  MAX_SCALE = 2.5;

float[][] triangles;
int[] col;

float maxX = 0;
float maxY = 0;

void setup() {
  loadVectorFile();
  size(int(maxX*MAX_SCALE), int(maxY*MAX_SCALE), P2D);
  background(0);
  noStroke();
  frameRate(50);
}

float scale=1;

void draw() {
  drawVector(scale);
  scale+=0.01f;
  if (scale>MAX_SCALE) scale=1;
}

void drawVector(float scale) {
  for (int i = 0 ; i < col.length; i++) {
    fill(col[i]);
    triangle(
      triangles[i][0]*scale, triangles[i][1]*scale,
      triangles[i][2]*scale, triangles[i][3]*scale,
      triangles[i][4]*scale, triangles[i][5]*scale
    );
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
    
    triangles[i][0] = float(entry[0]); 
    triangles[i][2] = float(entry[2]);
    triangles[i][4] = float(entry[4]);
    triangles[i][1] = float(entry[1]); 
    triangles[i][3] = float(entry[3]);
    triangles[i][5] = float(entry[5]);
    
    maxX = max(maxX, max(triangles[i][0], triangles[i][2], triangles[i][4]));
    maxY = max(maxY, max(triangles[i][1], triangles[i][3], triangles[i][5]));
  }
   
}
