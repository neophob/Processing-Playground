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

//Recursive backtracker, src: http://en.wikipedia.org/wiki/Maze_generation
void doMaze() {  
  Cell c = chooseRandomNeighbour();
  if (c!=null && !c.visited) {
    //joint position, save current position
    stack.push(currentCell);
    
    //break up walls
    c.breakWall(currentCell);
    currentCell.breakWall(c);
    
    //update cells
    c.visited=true;
    currentCell=c;
  } else if (!stack.isEmpty()) {
    //return to last position    
    do {
      currentCell = stack.pop();
    } while (!stack.isEmpty() && chooseRandomNeighbour()==null);
  } else {
    createMazeFinished=true;
    initSolver();
    println("maze created");
  }
}

void drawCell(Cell cell) {
  noStroke();
  fill(cell.col);
  boolean drawDot=false;
  if (cell.x==currentCell.x && cell.y==currentCell.y) {
    fill(color(255,0,0));
    drawDot=true;
  }
  
  int x2 = cell.x*MAZ_BLOCK_SIZE;
  int y2 = cell.y*MAZ_BLOCK_SIZE;  
  
  //draw unvisited cells flat/white
  if ((!createMazeFinished && !cell.visited) || drawDot) {
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
}

