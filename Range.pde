class Range {
  float x;
  float y;
  float w;
  float h;

  Range(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  boolean contains(float x, float y) {
    return (
      this.x <= x &&
      this.x + this.w >= x &&
      this.y <= y &&
      this.y + this.h >= y
    );
  }
  
  
}
