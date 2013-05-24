// -- SIMULATED_ANNEALING --

final float SIMULATED_ANNEALING_INITIAL_HEAT = 500000;
final float SIMULATED_ANNEALING_COOLING_RATE = 0.999f;

// Set initial temp
float saTemp = SIMULATED_ANNEALING_INITIAL_HEAT;
// -- SIMULATED_ANNEALING --


// Save best;
TriangleFrame currentSolution;
TriangleFrame workingSolution;
TriangleFrame bestSolution;


long lastBest = 0;

void initHeuristic() {
  workingSolution = new TriangleFrame(monaImg.width, monaImg.height);
  currentSolution = new TriangleFrame(workingSolution);
  bestSolution    = new TriangleFrame(workingSolution);
}

//
// RANDOM (Greedy?)
//
/*
 49k  (100)   40k  40k    38k 
 46k  (200)        34k    32k
 39k  (400)   28k  28k    26k
 31k  (800)   21k  22k    21k
 21k  (1600)  16k         15k
      (5000)              10k (160s) 136s
 */
void randomHeuristic2() {
  currentSolution = new TriangleFrame(bestSolution);

/*  if (bestSolution.getFitness() > 20000) {
    currentSolution.randomize();
    currentSolution.randomize();
    currentSolution.randomize();
    currentSolution.randomize();    
    currentSolution.randomize();
  } else if (bestSolution.getFitness() > 13000) {
    currentSolution.randomize();
    currentSolution.randomize();
    currentSolution.randomize();    
    currentSolution.randomize();    
  } else if (bestSolution.getFitness() > 9500) {
    currentSolution.randomize();
    currentSolution.randomize();
    currentSolution.randomize();
  } else if (bestSolution.getFitness() > 1500) {
    currentSolution.randomize();
    currentSolution.randomize();
  } else {
    currentSolution.randomize();
  }*/
  for (int i=0; i<int(random(4))+1; i++) currentSolution.randomize();

  if (currentSolution.getFitness() < bestSolution.getFitness()) {
    bestSolution = new TriangleFrame(currentSolution);
    println("new best: "+bestSolution.getFitness());
    lastBest = System.currentTimeMillis();      
    copy(0, 0, monaImg.width, monaImg.height, monaImg.width, 0, monaImg.width, monaImg.height);
  }
}

//
// RANDOM (Greedy?)
//
void randomHeuristic() {
  currentSolution = new TriangleFrame(bestSolution);
  currentSolution.randomize();

  if (currentSolution.getFitness() < bestSolution.getFitness()) {
    bestSolution = new TriangleFrame(currentSolution);
    println("new best: "+bestSolution.getFitness());
    lastBest = System.currentTimeMillis();      
    copy(0, 0, monaImg.width, monaImg.height, monaImg.width, 0, monaImg.width, monaImg.height);
  }
}

//
// SIMULATED_ANNEALING
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
    float calc = (float)Math.exp(-delta / saTemp);
    //jump out of any local optimums it finds itself in early on in execution
    if (calc > test) {
      useNewSolution = true;
    }
  }

  if (useNewSolution) {
    currentSolution = new TriangleFrame(workingSolution);

    if (currentSolution.getFitness() < bestSolution.getFitness()) {
      bestSolution = new TriangleFrame(currentSolution);
      println("new best: "+bestSolution.getFitness());
      lastBest = System.currentTimeMillis();      
      copy(0, 0, monaImg.width, monaImg.height, monaImg.width, 0, monaImg.width, monaImg.height);
    }
  } else {
    workingSolution = new TriangleFrame(currentSolution);
  }

  // Cool system
  saTemp *= SIMULATED_ANNEALING_COOLING_RATE;
  if (saTemp>1) {
    return false;
  }

  //finished
  return true;
}

