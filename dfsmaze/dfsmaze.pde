import java.util.*;

int MAZE_WIDTH = 30;
int MAZE_HEIGHT = 20;
int MAZ_BLOCK_SIZE=20;

Cell[][] cell = new Cell[MAZE_WIDTH][MAZE_HEIGHT];
Deque<Cell> stack = new ArrayDeque<Cell>();
Cell currentCell;

void setup() {
  size(MAZE_WIDTH*MAZ_BLOCK_SIZE, MAZE_HEIGHT*MAZ_BLOCK_SIZE);
  background(0);

  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      cell[x][y] = new Cell(x, y);
    }
  }

  currentCell = cell[0][0];
  currentCell.visited=true;
}

//Choose randomly one of the unvisited neighbours
Cell chooseRandomNeighbour() {  
  List<Cell> neighbour = new ArrayList<Cell>();
  int cx=currentCell.x;
  int cy=currentCell.y;

  if (cx-1>-1) {
    Cell c = cell[cx-1][cy];        
    if (!c.visited) {
      neighbour.add(c);
    }
  }
  if (cx+1<MAZE_WIDTH) {
    Cell c = cell[cx+1][cy];        
    if (!c.visited) {
      neighbour.add(c);
    }
  }
  if (cy-1>-1) {
    Cell c = cell[cx][cy-1];        
    if (!c.visited) {
      neighbour.add(c);
    }
  }
  if (cy+1<MAZE_HEIGHT) {
    Cell c = cell[cx][cy+1];        
    if (!c.visited) {
      neighbour.add(c);
    }
  }

  if (neighbour.size()==0) {
    return null;
  }

  int r = int(random(neighbour.size()));
  return neighbour.get(r);
}

void doMaze() {
  println("stacksize="+stack.size());
  Cell c = chooseRandomNeighbour();
  if (c!=null && !c.visited) {
    stack.push(currentCell);
    c.breakWall(currentCell);
    currentCell.breakWall(c);
    c.visited=true;
    currentCell=c;
  } else if (!stack.isEmpty()) {
    currentCell = stack.pop();
  } else {
    //Pick a random cell, make it the current cell and mark it as visit
  }
}

void draw() {
  background(0);
  doMaze();

  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      drawCell(cell[x][y]);
    }
  }
}

int WALL_SIZE=1;

void drawCell(Cell cell) {
  noStroke();
  fill(255);
  boolean drawDot=false;
  if (cell.x==currentCell.x && cell.y==currentCell.y) {
    fill(color(255,0,0));
    drawDot=true;
  }
  
  int x2 = cell.x*MAZ_BLOCK_SIZE;
  int y2 = cell.y*MAZ_BLOCK_SIZE;  
  
  if (!cell.visited || drawDot) {
    rect(x2, y2, MAZ_BLOCK_SIZE, MAZ_BLOCK_SIZE);
    return;
  }
  
 //top wall
  if (cell.walls[0]==1) 
  rect(x2, y2, MAZ_BLOCK_SIZE, WALL_SIZE);

  //left wall
  if (cell.walls[1]==1) 
  rect(x2, y2, WALL_SIZE, MAZ_BLOCK_SIZE);

  //right wall
  if (cell.walls[2]==1) 
  rect(x2+MAZ_BLOCK_SIZE-WALL_SIZE, y2, WALL_SIZE, MAZ_BLOCK_SIZE);

  //bottom wall
  if (cell.walls[3]==1) 
  rect(x2, y2+MAZ_BLOCK_SIZE-WALL_SIZE, MAZ_BLOCK_SIZE, WALL_SIZE);
  
  //if (cell.visited) fill(0); else fill(255);
  //rect(x*MAZ_BLOCK_SIZE, y*MAZ_BLOCK_SIZE, MAZ_BLOCK_SIZE, MAZ_BLOCK_SIZE);
}

