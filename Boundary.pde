class Boundary {
  float x;
  float y;
  float w;
  float h;

  Boundary(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  Boundary[] subdivide() {
    Boundary[] boundaries = new Boundary[4];

    // top left
    boundaries[0] = new Boundary(this.x, this.y, this.w / 2, this.h / 2);
    // top right
    boundaries[1] = new Boundary(this.x + this.w / 2, this.y, this.w / 2, this.h / 2);
    // bottom left
    boundaries[2] = new Boundary(this.x, this.y + this.h / 2, this.w / 2, this.h / 2);
    // bottom right
    boundaries[3] = new Boundary(this.x + this.w / 2, this.y + this.h / 2, this.w / 2, this.h / 2);
    
    return boundaries;
  }

  boolean contains(float x, float y) {
    return (
      this.x <= x &&
      this.x + this.w >= x &&
      this.y <= y &&
      this.y + this.h >= y
    );
  }
  
  boolean intersect(Range range) {
    return !(
      this.x > range.x + range.w ||
      this.x + this.w < range.x ||
      this.y > range.y + range.h ||
      this.y + this.h < range.y
    );
  }
}
