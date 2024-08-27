int FLOCK_SIZE = 250;

float RADIUS_DISTANCE = 50;
float DIAMETER_DISTANCE = RADIUS_DISTANCE * 2;
float ARC_ANGLE = PI / 2;

float ALIGNMENT_FORCE = 0.03;
float SEPARATION_FORCE = 0.9;
float COHESION_FORCE = 0.025;

float BOID_SPEED = 5;

Boid[] flock = new Boid[FLOCK_SIZE];

Quadtree tree;

void setup() {
  //size(600, 800);
  fullScreen();
  tree = new Quadtree(new Boundary(0, 0, width, height), 5);
  
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock[i] = new Boid(random(0, width), random(0, height));
  }
}

void draw() {
  background(22);
  tree = new Quadtree(new Boundary(0, 0, width, height), 5);

  for (Boid boid : flock) {
    tree.insert(boid);
  }

  for (Boid boid : flock) {
    Range range = new Range(boid.pos.x - RADIUS_DISTANCE, boid.pos.y - RADIUS_DISTANCE, DIAMETER_DISTANCE, DIAMETER_DISTANCE);
    ArrayList<Boid> b = new ArrayList<>();
    tree.query(range, b);
    boid.avoid();
    boid.steer(b);
    boid.update();
    boid.show();
  }
}
