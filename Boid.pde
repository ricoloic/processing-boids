class Boid extends PVector {
  PVector vel;
  PVector acc;
  PVector avgVel = new PVector();
  PVector avgPos = new PVector();
  PVector avgSep = new PVector();

  float startAngle = 0;
  float endAngle = 0;

  Boid(PVector pos) {
    super(pos.x, pos.y);
    this.vel = new PVector(random(-1, 1), random(-1, 1)).setMag(4);
    this.acc = new PVector();
    avgVel = new PVector();
    avgPos = new PVector();
    avgSep = new PVector();
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    vel.add(acc).setMag(IDLE_SPEED);
    calcAngles();
    add(vel);
    acc.mult(0);
  }

  void edge() {
    if (x < 0) x = width;
    else if (x > width) x = 0;
    if (y < 0) y = height;
    else if (y > height) y = 0;
  }

  void calcAngles() {
    startAngle = vel.heading() - ARC_ANGLE;
    endAngle = vel.heading() + ARC_ANGLE;
  }

  void steer(ArrayList<Boid> boids) {
    int validBoidsCount = 0;
    avgVel = new PVector();
    avgPos = new PVector();
    avgSep = new PVector();

    for (Boid boid : boids) {
      if (boid == this) continue;
      float distance = PVector.dist(boid, this);
      if (distance >= VIEW_RADIUS) continue;
      float a = atan2(boid.y - y, boid.x - x);
      if (!(startAngle < a && a < endAngle)) continue;

      avgVel.add(boid.vel);
      avgPos.add(boid);
      avgSep.add(PVector.sub(this, boid).div(distance));

      validBoidsCount++;
    }

    if (validBoidsCount == 0) return;

    applyForce(avgVel
      .div(validBoidsCount)
      .sub(vel)
      .mult(ALIGNMENT_FORCE));
    applyForce(avgPos
      .div(validBoidsCount)
      .sub(this).sub(vel)
      .mult(COHESION_FORCE));
    applyForce(avgSep
      .div(validBoidsCount)
      .sub(vel)
      .mult(SEPARATION_FORCE));
  }

  void avoid() {
    float distanceL = x;
    if (distanceL < WALL_SEPARATION) {
      applyForce(PVector.fromAngle(0).setMag(WALL_SEPARATION - distanceL));
    }

    float distanceT = y;
    if (distanceT < WALL_SEPARATION) {
      applyForce(PVector.fromAngle(HALF_PI).setMag(WALL_SEPARATION - distanceT));
    }

    float distanceR = width - x;
    if (distanceR < WALL_SEPARATION) {
      applyForce(PVector.fromAngle(PI).setMag(WALL_SEPARATION - distanceR));
    }

    float distanceB = height - y;
    if (distanceB < WALL_SEPARATION) {
      applyForce(PVector.fromAngle(PI + HALF_PI).setMag(WALL_SEPARATION - distanceB));
    }
  }

  void show() {
    if (DRAW_VELOCITY) {
      strokeWeight(2);
      stroke(220, 60, 90);
      line(x, y, x + vel.x * 10, y + vel.y * 10);
    }
    if (DRAW_CIRCLE) {
      strokeWeight(1);
      noFill();
      stroke(200);
      circle(x, y, VIEW_RADIUS * 2);
    }
    if (DRAW_ARC) {
      strokeWeight(1);
      noFill();
      stroke(200);
      arc(x, y, VIEW_DIAMETER, VIEW_DIAMETER, startAngle, endAngle, PIE);
    }

    strokeWeight(10);
    stroke(255);
    pushMatrix();
    translate(x, y);
    //rotate(vel.heading());
    point(0, 0);
    popMatrix();
  }
}
