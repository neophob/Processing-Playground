/*
  idea from "Smack my glitch up": src: https://github.com/mutaphysis/smackmyglitchupjs/blob/master/glitch.html
  
  how an image is loaded in processing (java):
    byte bytes[] = loadBytes(filename);
    Image awtImage = Toolkit.getDefaultToolkit().createImage(bytes);
    PImage image = loadImageMT(awtImage);  
*/
import java.awt.Image;
import java.awt.Toolkit;

PImage img;
byte[] srcImage, glitchImage;

final String FILENAME = "toGlitch.jpg";
final int HEADER_SIZE = 20;

void setup() {
  //load file to get size
  img = loadImage(FILENAME);
  size(img.width, img.height);
  
  //load image in byte array
  srcImage = loadBytes(FILENAME);
  frameRate(4);
}

void draw() {
  glitchImage = new byte[srcImage.length];
  arrayCopy(srcImage, glitchImage);  
  int amount = 2 + int(random(8));
  for (int i=0; i<amount; i++) {
    int ofs = HEADER_SIZE+int(random(glitchImage.length-HEADER_SIZE));
    glitchImage[ofs] = byte(random(0xff));
  }
  Image awtImage = Toolkit.getDefaultToolkit().createImage(glitchImage);
  img = loadImageMT(awtImage);
  image(img, 0, 0);
}

void keyPressed() {
  println("save frame");
  saveFrame("glitch-######.png");
}

