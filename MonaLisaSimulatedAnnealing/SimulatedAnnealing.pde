final float INITIAL_HEAT = 80000;
final float COOLING_RATE = 0.003;

// Set initial temp
float temp = INITIAL_HEAT;

// Cooling rate
float coolingRate = COOLING_RATE;

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
  if (interation<3) {
    temp = INITIAL_HEAT;
  } else {
//    temp = 8;
  }
  coolingRate = COOLING_RATE;
  //m = best;
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
    copy(0, 0, monaImg.width, monaImg.height, monaImg.width, 0, monaImg.width, monaImg.height);
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

