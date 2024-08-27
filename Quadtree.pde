class Quadtree {
  int capacity;
  Boundary boundary;
  ArrayList<Boid> elements = new ArrayList<>();
  
  Quadtree tl = null;
  Quadtree tr = null;
  Quadtree bl = null;
  Quadtree br = null;
  
  boolean divided = false;
  
  Quadtree(Boundary boundary, int capacity) {
    this.boundary = boundary;
    this.capacity = capacity;
  }

  void subdivide() {
    if (this.divided) return;

    Boundary[] boundaries = this.boundary.subdivide();
    this.tl = new Quadtree(boundaries[0], this.capacity);
    this.tr = new Quadtree(boundaries[1], this.capacity);
    this.bl = new Quadtree(boundaries[2], this.capacity);
    this.br = new Quadtree(boundaries[3], this.capacity);

    this.divided = true;
  }

  boolean insert(Boid point) {
    if (!this.boundary.contains(point.pos.x, point.pos.y)) return false;
    
    if (this.elements.size() < capacity) {
      this.elements.add(point);
      return true;
    }
    
    if (!this.divided) this.subdivide();

    if (this.tl.insert(point)) return true;
    if (this.tr.insert(point)) return true;
    if (this.bl.insert(point)) return true;
    if (this.br.insert(point)) return true;

    return false;
  }

  void query(Range range, ArrayList<Boid> elements) {
    if (this.boundary.intersect(range)) {
      for (Boid e : this.elements) {
        if (range.contains(e.pos.x, e.pos.y)) {
          elements.add(e);
        }
      }
    }
    
    if (!this.divided) return;
    
    this.tl.query(range, elements);
    this.tr.query(range, elements);
    this.bl.query(range, elements);
    this.br.query(range, elements);
  }
  
  void show() {
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(this.boundary.x, this.boundary.y, this.boundary.w, this.boundary.h);
    
    if (this.divided) {
      this.tl.show();
      this.tr.show();
      this.bl.show();
      this.br.show();
    }
  }
}
