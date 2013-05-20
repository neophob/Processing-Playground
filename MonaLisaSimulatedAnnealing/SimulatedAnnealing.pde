// Set initial temp
float temp = 100000;

// Cooling rate
float coolingRate = 0.003;

// Save best;
Mona best = m;
float bestFitness = 9999999;

float currentEngery = -1;

long lastBest = 0;

static double acceptanceProbability(float engery, float newEngery, float temperature) {
  // If the new solution is better, accept it
  if (newEngery < engery) {
    return 1.0;
  }
  // If the new solution is worse, calculate an acceptance probability
  return Math.exp((engery - newEngery) / temperature);
}

//gets called for the detail step
void resetSim() {
  //bestFitness = 9999999;
  //currentEngery = -1;
  temp = 10000;
  coolingRate = 0.002;
}

boolean simulateAnnealing() {
  Mona newSolution = new Mona(m);

  //modify
  newSolution.randomize();
  
  // Get energy of solutions, the smaller the fitness the better!
  if (currentEngery==-1) {
    currentEngery = m.fitness();
  }
  float neighbourEngery = newSolution.fitness();

  // Decide if we should accept the neighbour - in the beginning results are much more experimental
  if (acceptanceProbability(currentEngery, neighbourEngery, temp) > Math.random()) {
    m = newSolution;
    currentEngery = neighbourEngery;
  }

  // Keep track of the best solution found
  if (currentEngery < bestFitness) {
    best = m;
    bestFitness = currentEngery;
    //println("new best: "+bestFitness);
    lastBest = System.currentTimeMillis();
    copy(0, 0, monaImg.width,monaImg.height, monaImg.width, 0, monaImg.width,monaImg.height);
  }

  // Cool system
  temp *= 1-coolingRate;
  if (temp>1) {
    return false;
  }
  
  m.triggerNextRound();
  //finished
  return true;
}

