class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  

  Boid(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.fromAngle(random(0, TWO_PI)).setMag(random(0, 4));
    acc = new PVector();
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void update() {
    vel.add(acc).setMag(BOID_SPEED);
    pos.add(vel);
    acc.mult(0);
  }

  void steer(ArrayList<Boid> boids) {
    int amt = 0;
    PVector alignment = new PVector(0, 0);
    PVector separation = new PVector(0, 0);
    PVector cohesion = new PVector(0, 0);

    for (Boid boid : boids) {
      if (boid == this) continue;
      float distance = dist(pos.x, pos.y, boid.pos.x, boid.pos.y);
      if (distance > RADIUS_DISTANCE) continue;
      
      float heading = vel.heading();
      float s = heading - ARC_ANGLE;
      float e = heading + ARC_ANGLE;
      //A = atan2 (Y - CenterY, X - CenterX)
      float a = atan2(boid.pos.y - pos.y, boid.pos.x - pos.x);
      
      if (!(s < a && a < e)) continue;

      alignment.add(boid.vel);
      cohesion.add(boid.pos);
      separation.add(PVector.sub(this.pos, boid.pos).div(distance));
      
      amt++;
    }

    if (amt == 0) return;

    applyForce(alignment.div(amt).sub(vel).mult(ALIGNMENT_FORCE));
    applyForce(cohesion.div(amt).sub(vel).sub(pos).mult(COHESION_FORCE));
    applyForce(separation.div(amt).sub(vel).mult(SEPARATION_FORCE));
  }
  
  void avoid() {
    float distLeft = pos.x;
    if (distLeft < 75) {
      applyForce(PVector.fromAngle(0).mult(75 - distLeft)); 
    }
    float distTop = pos.y;
    if (distTop < 75) {
      applyForce(PVector.fromAngle(HALF_PI).mult(75 - distTop)); 
    }
    float distRight = width - pos.x;
    if (distRight < 75) {
      applyForce(PVector.fromAngle(PI).mult(75 - distRight)); 
    }
    float distBottom = height - pos.y;
    if (distBottom < 75) {
      applyForce(PVector.fromAngle(PI + HALF_PI).mult(75 - distBottom)); 
    }
  }

  void show() {
    stroke(210, 90, 70, 220);
    strokeWeight(3);
    PVector temp = vel.copy().setMag(30).add(pos);
    line(pos.x, pos.y, temp.x, temp.y);
    
    noFill();
    stroke(120, 60, 210, 100);
    strokeWeight(2);
    float heading = vel.heading();
    float s = heading - ARC_ANGLE;
    float e = heading + ARC_ANGLE;
    arc(pos.x, pos.y, DIAMETER_DISTANCE, DIAMETER_DISTANCE, s, e);
    stroke(255);
    strokeWeight(5);
    point(pos.x, pos.y);
  }
}
