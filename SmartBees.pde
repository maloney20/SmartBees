//PrintWriter out;


float fitness = 0;

Bee[] population;
int iterationFrame = 0;
int iteration = 0;

float targetX = 250, targetY = 30;
float goals = 0;
float obsX = 100, obsY = 200, obsWidth = 300, obsHeight = 20;
int populationSize = 120;

void setup() {
  size(500, 500); 
  population = new Bee[populationSize];
    //println("generating population " + iteration+", size: "+population.length);
  for (int i = 0; i < population.length; i++) {
    population[i] = new Bee();
  }
  //out = createWriter("output.csv");
  frameRate(100);
}

void draw() {
  background(0);
  fill(0, 160, 0);
  rect(targetX-2, targetY, 4, 60);
  ellipseMode(CENTER);
  fill(255, 0, 222);
  ellipse(targetX, targetY, 40, 40);
  fill(92, 46, 0);
  ellipse(targetX, targetY, 30, 30);
  fill(255);
  rect(obsX, obsY, obsWidth, obsHeight);

  if (iterationFrame < 400) {


    for (int i = 0; i < population.length; i++) {
      population[i].applyPhysics();
      population[i].show(); 
      if ((population[i].pos.x < obsX+obsWidth && population[i].pos.x > obsX &&
        population[i].pos.y >obsY && population[i].pos.y < obsY+obsHeight)) {

        population[i].crashed =true;
      }
      else if(dist(population[i].pos.x, population[i].pos.y, targetX, targetY) < 20){
        population[i].goal = true;
        population[i].framesToGoal = iterationFrame;
        population[i].fitness = 10;
      }
    } //<>//
    iterationFrame++;
  } else {
    resetIteration();
    updatePopulation(); //<>//
  }
}

void resetIteration() {
  iterationFrame = 0;
}
 //<>//
void updatePopulation() {
  for(Bee b : population){
      if(b.goal){
        goals++;
      }
    }
  println("iteration "+iteration++ +" complete: "+goals+" goals: "+goals/(float)populationSize*100+"% success.");
  //println("generating next population, size: "+population.length);
  //out.flush();
  //out.print(goals/(float)populationSize*100 +",");
  goals = 0;
  ArrayList<Bee> genePool = new ArrayList(); //<>//
  float maxFitness = 0;
  generateFitnesses();
  for(int i = 0; i < population.length; i++){
    if(population[i].fitness > maxFitness) maxFitness = population[i].fitness;
  }
  
  for(int i = 0; i < population.length; i++){
    population[i].fitness /= maxFitness;
  }
  
  for(int i = 0; i < population.length; i++){
    float n = population[i].fitness * 100;
    for(int j = 0; j < n; j++){
      genePool.add(population[i]); 
    }
  }
  
  for(int i = 0; i < population.length; i++){
    
    population[i] = new Bee();
    Bee parentA = genePool.get(floor(random(genePool.size())));
    Bee parentB = genePool.get(floor(random(genePool.size())));
    for(int j = 0; j < population[i].genes.length; j++){
      int midpoint = floor(random(parentA.genes.length));
      if(random(1) < 0.03){
        //println("Mutation occured!");
        population[i].genes[j] = PVector.random2D();
      }
      if(j > midpoint){
        population[i].genes[j] = parentA.genes[j]; 
      }
      else{
         population[i].genes[j] = parentB.genes[j]; 
      }
    }
  }
}

void sortByFitness() {
  Bee[] sorted = new Bee[population.length];
  for (int i = 0; i < population.length; i++) {
    Bee max = population[i];
    for (int j = i; j < population.length; j++) {
      if (population[j].fitness > max.fitness) max = population[j];
    }
    sorted[i] = max;
  }
  population = sorted;
  for(Bee b : population){
    println(b.fitness); 
  }
}

void generateFitnesses() {
  for(int i = 0; i < population.length; i++){
    population[i].calcFitness(targetX, targetY);
  }
}
