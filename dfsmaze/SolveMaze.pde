int solveCount=0;

//prepare solver
void initSolver() {
  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      cell[x][y].visited=false;
    }
  }
  currentCell = cell[0][0];
  targetCell = cell[int(random(MAZE_WIDTH))][int(random(MAZE_HEIGHT))];
  println("start solve: "+currentCell.x+"/"+currentCell.y);
}

Cell chooseNextPossibleDirecton() {
  int x = currentCell.x;
  int y = currentCell.y; 
    
  if (currentCell.x>0) {
    if (currentCell.goLeft(cell[x-1][y])) {
      if (!cell[x-1][y].visited) return cell[x-1][y];
    }
  }
  if (currentCell.x+1<MAZE_WIDTH) {
    if (currentCell.goRight(cell[x+1][y])) {
      if (!cell[x+1][y].visited) return cell[x+1][y];
    }
  }
  if (currentCell.y>0) {
    if (currentCell.goUp(cell[x][y-1])) {
      if (!cell[x][y-1].visited) return cell[x][y-1];
    }
  }
  if (currentCell.y+1<MAZE_HEIGHT) {
    if (currentCell.goDown(cell[x][y+1])) {
      if (!cell[x][y+1].visited) return cell[x][y+1];
    }
  }
  //
  return null;  
}

void solveMaze() {
  Cell c = chooseNextPossibleDirecton();  
  if (c!=null && !c.visited) {
    //junction position, save current position on stack
    stack.push(currentCell);

    //mark way    
    c.col=color(255,255,32);
    c.bgCol=color(192,192,128);
    //update cells
    c.visited=true;
    currentCell=c;
  } else if (!stack.isEmpty()) {
    //return to last position aka backtracking
    currentCell.bgCol=0;    
    do {
      currentCell = stack.pop();
      currentCell.bgCol=0;
    } while (!stack.isEmpty() && chooseRandomNeighbour()==null);
    currentCell.bgCol=color(192,192,128);
  } else {
    solveMazeFinished=true;
    println("maze NOT solved: "+solveCount);
  }  
  solveCount++;
  
  if (currentCell.x==targetCell.x && currentCell.y==targetCell.y) {
    solveMazeFinished=true;
    println("maze solved: "+solveCount);
  }
}

/*

You can think of your maze as a tree.

     A
    / \
   /   \
  B     C
 / \   / \
D   E F   G
   / \     \
  H   I     J
 / \
L   M
   / \
  **  O

(which could possibly represent)

        START
        +   +---+---+
        | A   C   G |
    +---+   +   +   +
    | D   B | F | J |
+---+---+   +---+---+
| L   H   E   I |
+---+   +---+---+
    | M   O |
    +   +---+
    FINISH

*/
