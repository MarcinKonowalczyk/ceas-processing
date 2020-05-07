class Mirror {
  float xpos, y1pos, y2pos;
  float reflectivity;
  boolean text_flag;
  Mirror(float x, float y1, float y2, float r) {
    xpos = x; y1pos = y1; y2pos = y2;
    reflectivity = r;
    text_flag = false;
  }
  
  void show() {
    noFill();
    stroke(240);
    strokeWeight(4);
    line(xpos, y1pos, xpos, y2pos);
    
    // Absorbance text
    if (text_flag) {
      fill(128);
      strokeWeight(2.5);
      textSize(12);
      textAlign(CENTER, BOTTOM);
      text("R = " + nf(reflectivity,1,3), xpos, y1pos-1);
    }
    
  }
  
  void interact(Photon p) {
    if (p.ypos>y1pos & p.ypos<y2pos) {
        if (
        (p.oxpos<xpos & p.xpos>xpos) | // Left reflect
        (p.oxpos>xpos & p.xpos<xpos) | // Right reflect
        (p.xpos==xpos) // Edge case
        ) {
          if (random(0,1)<reflectivity) {
            if (p.oxpos<xpos) { // Left refelction
              p.xpos = xpos-(p.xpos-xpos); p.speedx = -p.speedx;
            } else { // Right reflection
              p.xpos = xpos+(xpos-p.xpos); p.speedx = -p.speedx;
            }
          }
        }
      }
  }
}
