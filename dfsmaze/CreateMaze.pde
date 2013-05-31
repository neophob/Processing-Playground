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
  if (createMazeFinished) {
    return;
  }

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
    } 
    while (!stack.isEmpty () && chooseRandomNeighbour()==null);
  } else {
    println("maze created");
    initSolver();
    createMazeFinished=true;
  }
}

