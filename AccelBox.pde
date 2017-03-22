class AccelBox {
  PVector pos;
  PVector center;
  PVector accel;
  PVector size;
  
  AccelBox(PVector startPos, PVector startAccel, PVector startSize) {
    pos = startPos;
    accel = startAccel;
    size = startSize;
    
    center = new PVector(pos.x, pos.y).add(size.x /2, size.y / 2);
  }
  
  boolean intersect(Droplet drop) {
    float dropLeft = drop.getPos().x;
    float dropRight = drop.getPos().x + drop.getSize();
    float dropTop = drop.getPos().y;
    float dropBot = drop.getPos().y + drop.getSize();
    
    float left = pos.x;
    float right = pos.x + size.x;
    float top = pos.y;
    float bot = pos.y + size.y;
    
    return !(left > dropRight ||
             right < dropLeft ||
             top > dropBot ||
             bot < dropTop);
  }
  
  boolean contains(PVector pPos) {
    return (pPos.x < pos.x + size.x && pPos.x > pos.x 
            && pPos.y > pos.y && pPos.y < pos.y + size.y);
  }
  
  void draw() {
    fill(255);
    rect(pos.x, pos.y, size.x, size.y);
    
    fill(0);
    line(center.x, center.y, center.x + accel.x * 100, center.y + accel.y*100);
  }
  
  void changeAccel(PVector deltaAcc) {
    accel.add(deltaAcc);
  }
  
  PVector getAccel() {
    return accel;
  }
 
}