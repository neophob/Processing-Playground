class Cell {
  int x,y;
  boolean visited;
  color col;
  
  int[] walls = new int[4];
  
  public Cell(int x, int y) {
    visited=false;
    this.x=x;
    this.y=y;
    walls[0]=1;
    walls[1]=1;
    walls[2]=1;
    walls[3]=1;
    col=color(255,255,255);
  }
  
  boolean goUp(Cell c) {
    if (walls[0]==0 && c.walls[0]==0) return true;
    return false;
  }
  boolean goDown(Cell c) {
    if (walls[3]==0 && c.walls[3]==0) return true;
    return false;
  }
  boolean goLeft(Cell c) {
    if (walls[1]==0 && c.walls[1]==0) return true;
    return false;
  }
  boolean goRight(Cell c) {
    if (walls[2]==0 && c.walls[2]==0) return true;
    return false;
  }  
  
  void breakWall(Cell c) {
    if (c.x<x) {
      walls[1] = 0;
      return;
    }
    
    if (c.x>x) {
      walls[2] = 0;
      return;
    }
    
    if (c.y<y) {
      walls[0] = 0;
      return;
    }    

    if (c.y>y) {
      walls[3] = 0;
      return;
    }    
  }
}
