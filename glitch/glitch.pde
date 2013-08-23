/*
  idea from "Smack my glitch up": src: https://github.com/mutaphysis/smackmyglitchupjs/blob/master/glitch.html
    
  how an image is loaded in processing (java):
    byte bytes[] = loadBytes(filename);
    Image awtImage = Toolkit.getDefaultToolkit().createImage(bytes);
    PImage image = loadImageMT(awtImage);  
*/
import java.awt.Image;
import java.awt.Toolkit;

byte[] srcImage;

final String FILENAME = "toGlitch.jpg";
final int HEADER_SIZE = 2;

void setup() {
  //load file to get size
  PImage img = loadImage(FILENAME);
  size(img.width, img.height, OPENGL);
  
  //load image in byte array
  srcImage = loadBytes(FILENAME);
  frameRate(40);
}

void draw() {
  int glitchLevel = int(random(5));
  if (glitchLevel==4) glitchLevel=int(random(100));
  image(
    createGlitchImage(srcImage, glitchLevel)
    , 0, 0
  );
}

PImage createGlitchImage(byte[] srcImage, int amount) {
  byte[] glitchImage = new byte[srcImage.length];
  arrayCopy(srcImage, glitchImage);    
  for (int i=0; i<amount; i++) {    
    int ofs = HEADER_SIZE+int(random(glitchImage.length-HEADER_SIZE));
    glitchImage[ofs] = byte(random(0xff));
  }
  Image awtImage = Toolkit.getDefaultToolkit().createImage(glitchImage);
  return loadImageMT(awtImage);
}

void keyPressed() {
  println("save frame");
  saveFrame("glitch-######.png");
}

