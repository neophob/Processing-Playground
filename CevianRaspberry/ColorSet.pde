private static int staticId = 0;
public class ColorSet {

  private String name;

  private int id;

  private int[] colors;
  
  private int boarderCount;

  public ColorSet(String name, int[] colors) {
    this.name = name;
    this.id = staticId++;
    this.colors = colors.clone();
    this.boarderCount = int((255f / colors.length)+0.5);
    //println("colors.length: "+colors.length+", boarderCount: "+boarderCount);
  }

  public String getName() {
    return name;
  }

  public int getId() {
    return id;
  }

  public int getRandomColor() {
    int rnd = int(random(colors.length));    
    return this.colors[rnd];
  }

  color getSmoothColor(int posTmp) {        
    int pos = (posTmp&255)%255;    
    int ofs=0;
    while (pos > boarderCount) {
      pos -= boarderCount;
      ofs++;
    }
    
    int targetOfs = (ofs+1)%colors.length;
    
    //println("ofs:"+ofs+" targetofs:"+targetOfs+", pos:"+pos+", boarderCount:"+boarderCount);    
    return calcSmoothColor(colors[targetOfs], colors[ofs], pos);
  }
  
  //////////////////
  color getSmoothColor(int posTmp, int alpha) {
    if (alpha>255) alpha=255;
    int pos = (posTmp&255)%255;    
    int ofs=0;
    while (pos > boarderCount) {
      pos -= boarderCount;
      ofs++;
    }
    
    int targetOfs = (ofs+1)%colors.length;
    
    //println("ofs:"+ofs+" targetofs:"+targetOfs+", pos:"+pos+", boarderCount:"+boarderCount);    
    return calcSmoothColor(colors[targetOfs], colors[ofs], pos, alpha);
  } 
  
  private color calcSmoothColor(int col1, int col2, int pos) {
    int b= col1&255;
    int g=(col1>>8)&255;
    int r=(col1>>16)&255;
    int b2= col2&255;
    int g2=(col2>>8)&255;
    int r2=(col2>>16)&255;

    int mul=pos*colors.length;
    int oppisiteColor = 255-mul;
    r=(r*mul)/255;
    g=(g*mul)/255;
    b=(b*mul)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b);
  }
  
  private color calcSmoothColor(int col1, int col2, int pos, int a) {
    int b= col1&255;
    int g=(col1>>8)&255;
    int r=(col1>>16)&255;
    int b2= col2&255;
    int g2=(col2>>8)&255;
    int r2=(col2>>16)&255;

    int mul=pos*colors.length;
    int oppisiteColor = 255-mul;
    r=(r*mul)/255;
    g=(g*mul)/255;
    b=(b*mul)/255;
    r+=(r2*oppisiteColor)/255;
    g+=(g2*oppisiteColor)/255;
    b+=(b2*oppisiteColor)/255;

    return color(r, g, b, a);
  }  
}
