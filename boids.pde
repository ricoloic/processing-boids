float ALIGNMENT_FORCE = 0.03;
float SEPARATION_FORCE = 0.78;
float COHESION_FORCE = 0.025;

boolean DRAW_CIRCLE = false;
boolean DRAW_VELOCITY = false;
boolean DRAW_ARC = false;
boolean DRAW_TREE = false;

float ARC_ANGLE = HALF_PI + QUARTER_PI;

float IDLE_SPEED = 7;
float VIEW_RADIUS = 50;
float VIEW_DIAMETER = VIEW_RADIUS * 2;

int FLOCK_SIZE = 75;

float WALL_SEPARATION = 75;

Boid[] flock = new Boid[FLOCK_SIZE];
Quadtree<Boid> quadtree;
Boundary boundary;

void setup() {
  size(600, 900);
  //fullScreen();
  boundary = new Boundary(0, 0, width, height);
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock[i] = new Boid(new PVector(random(0, width), random(0, height)));
  }
}

void draw() {
  background(33);

  quadtree = new Quadtree<Boid>(boundary, 4);
  for (Boid boid : flock) {
    quadtree.insert(boid);
  }
  if (DRAW_TREE) quadtree.show();

  for (Boid boid : flock) { 
    Range range = new Range(boid.x - VIEW_RADIUS, boid.y - VIEW_RADIUS, VIEW_DIAMETER, VIEW_DIAMETER);
    ArrayList<Boid> found = new ArrayList<>();
    quadtree.query(range, found);

    //boid.edge();
    boid.steer(found);
    boid.avoid();
    boid.update();
    boid.show();
  }
}
