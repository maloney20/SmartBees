class Bee {
  PVector pos;
  PVector vel;
  PVector accel;
  PVector[] genes;
  boolean crashed = false;
  boolean goal = false;
  int count = 0;
  float framesToGoal = 400;
  float fitness;
  
  
  
  Bee(){
  
    pos = new PVector(width/2, 0.9*height);
    vel= new PVector(0, 0);
    accel = new PVector(0, 0);
    genes = new PVector[400];
    for(int i = 0; i < genes.length; i++){
      genes[i] = PVector.random2D(); 
      genes[i].setMag(0.1);
    }
  }
  
  void applyPhysics() {
    if(!crashed && !goal){
      applyForce();
      vel.add(accel);
      pos.add(vel);
      accel.mult(0);
    }
  }
  
  void applyForce(){
    accel.add(genes[count++]); 
  }
  
  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate((PI/2)+vel.heading());
    ellipseMode(CENTER);
    fill(255, 255, 0, 100);
    ellipse(0, 0, 10, 20);
    fill(100, 100);
    ellipse(-7, 0, 10, 10);
    ellipse(7, 0, 10, 10);
    popMatrix();
  }
  
  void calcFitness(float targX, float targY) {
    float dist = dist(pos.x, pos.y, targX, targY);
    fitness = map(dist, 0, width, width, 0);
    if(goal){
      fitness*=2;
    }
    else if(crashed){
      fitness /= 4;
    }
    fitness/=1.5*framesToGoal;
  }
}
