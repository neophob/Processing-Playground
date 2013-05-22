//final String VECTORFILE = "test.txt";
final String VECTORFILE = "ego.txt";
final int  SIZE = 800;

float[][] triangles;
int[] col;

void setup() {
  loadVectorFile();
  size(SIZE, SIZE, P2D);
  background(0);
  noStroke();
  frameRate(1);
  drawVector(SIZE);
}

void draw() {
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
