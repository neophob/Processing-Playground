class Cell {
  int x,y;
  boolean visited;
  
  int[] walls = new int[4];
  
  public Cell(int x, int y) {
    visited=false;
    this.x=x;
    this.y=y;
    walls[0]=1;
    walls[1]=1;
    walls[2]=1;
    walls[3]=1;
  }
  
/*
     0
     |
 1 --+-- 2
     |
     3
*/
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
