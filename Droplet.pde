class Droplet {
  PVector pos;
  PVector vel;
  float size;
  float colorVal;
  
  Droplet(PVector startPos, float startSize) {
    pos = startPos;
    size = startSize;
    vel = new PVector(0, 0);
    colorVal = 255;
  }
  
  void update() {
    pos.add(vel);
    colorVal = 255*((abs(vel.x) + abs(vel.y)) / 100) + 10;
  }
  
  void draw() {
    fill(colorVal);
    ellipse(pos.x, pos.y, size, size);
  }
  
  void accelerate(PVector accel) {
    vel.add(accel);
  }
  
  void setColorVal(int val) {
    colorVal = val;
  }
  
  PVector getPos() {
    return pos;
  }
  
  float getSize() {
    return size;
  }
  
  boolean touchingPlayer() {
    float dropLeft = pos.x;
    float dropRight = pos.x + size;
    float dropTop = pos.y;
    float dropBot = pos.y + size;
    
    float left = mouseX;
    float right = mouseX + 25;
    float top = mouseY;
    float bot = mouseY + 25;
    
    return !(left > dropRight ||
             right < dropLeft ||
             top > dropBot ||
             bot < dropTop);
  }
}