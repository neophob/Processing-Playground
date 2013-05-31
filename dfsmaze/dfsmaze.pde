import java.util.*;

int MAZE_WIDTH = 30;
int MAZE_HEIGHT = 10;
int MAZ_BLOCK_SIZE=10;
int WALL_SIZE=1;

Cell[][] cell = new Cell[MAZE_WIDTH][MAZE_HEIGHT];
Deque<Cell> stack = new ArrayDeque<Cell>();
Cell currentCell;
boolean createMazeFinished=false;

void setup() {
  size(MAZE_WIDTH*MAZ_BLOCK_SIZE, MAZE_HEIGHT*MAZ_BLOCK_SIZE);
  background(0);

  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      cell[x][y] = new Cell(x, y);
    }
  }
  frameRate(25);
  currentCell = cell[0][0];
  currentCell.visited=true;
}


void draw() {
  background(0);
  
  if (!createMazeFinished) {
    doMaze();
  } else {
    solveMaze();
  }
  
  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      drawCell(cell[x][y]);
    }
  }
    
}


