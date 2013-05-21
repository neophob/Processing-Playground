final float INITIAL_HEAT = 1000000;
//final float INITIAL_HEAT = 00000;

//final float COOLING_RATE = 0.0008;
final float COOLING_RATE = 0.99;

// Set initial temp
float temp = INITIAL_HEAT;

// Cooling rate
float coolingRate = COOLING_RATE;

// Save best;
TriangleFrame currentSolution;
TriangleFrame workingSolution;
TriangleFrame bestSolution;


long lastBest = 0;

void initSimulatedAnnealing() {
  workingSolution = new TriangleFrame(monaImg.width, monaImg.height);
  currentSolution = new TriangleFrame(workingSolution);
  bestSolution    = new TriangleFrame(workingSolution);
}



//gets called for the detail step
void resetSim() {
/*  if (iteration<3) {
    //    temp = 8;
    temp=INITIAL_HEAT;
    currentSolution = new TriangleFrame(bestSolution);
    workingSolution = new TriangleFrame(bestSolution);
  }*/
}


//
// Main lop
//
boolean simulateAnnealing() {
  //newSolution = new TriangleFrame(workingSolution);
  workingSolution.randomize();

  boolean useNewSolution = false;

  // Keep track of the best solution found
  if (workingSolution.getFitness() <= currentSolution.getFitness()) {
    useNewSolution = true;
  } else {
    //new solution wasnt better, but maybe use it anyway
    float test = random(1);
    float delta = workingSolution.getFitness() - currentSolution.getFitness();
    float calc = (float)Math.exp(-delta / temp);
    //jump out of any local optimums it finds itself in early on in execution
    if (calc > test) {
      useNewSolution = true;
    }
  }

  if (useNewSolution) {
    currentSolution = new TriangleFrame(workingSolution);

    if (currentSolution.getFitness() <= bestSolution.getFitness()) {
      bestSolution = new TriangleFrame(currentSolution);
      println("new best: "+bestSolution.getFitness());
      lastBest = System.currentTimeMillis();      
      copy(0, 0, monaImg.width, monaImg.height, monaImg.width, 0, monaImg.width, monaImg.height);
    }
  } else {
    workingSolution = new TriangleFrame(currentSolution);
  }

  // Cool system
  temp *= coolingRate;
  if (temp>1) {
    return false;
  }

  //finished
  return true;
}

