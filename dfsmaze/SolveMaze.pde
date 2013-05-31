//prepare solver
void initSolver() {
  for (int y=0; y<MAZE_HEIGHT; y++) {
    for (int x=0; x<MAZE_WIDTH; x++) {
      cell[x][y].visited=false;
    }
  }
}

Cell chooseNextPossibleDirecton() {
  Cell ret = null;
  //currentCell.goUp();
  return ret;  
}

void solveMaze() {
  Cell c = chooseNextPossibleDirecton();
  if (c!=null && !c.visited) {
    //joint position, save current position
    stack.push(currentCell);

    //mark way    
    c.col=color(128,32,32);
    
    //update cells
    c.visited=true;
    currentCell=c;
  } else if (!stack.isEmpty()) {
    //return to last position    
    do {
      currentCell = stack.pop();
    } while (!stack.isEmpty() && chooseRandomNeighbour()==null);
  } else {
    finished=true;
    println("maze created");
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
