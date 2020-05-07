class Scaterer {
  float tlx, tly, brx, bry;
  float scaterance;
  boolean text_flag;
  Scaterer (float x1, float y1, float x2, float y2, float s) {
    tlx = x1; 
    tly = y1; 
    brx = x2; 
    bry = y2;
    scaterance = s;
    text_flag = false;
  }

  void show() {
    noStroke();
    fill(105, 42, 39);//(107, 51, 48);
    rect(tlx, tly, brx, bry, 5);

    fill(219, 149, 147);
    strokeWeight(2.5);
    textSize(12);
    textAlign(CENTER, TOP);
    text("Scaterer", tlx+(brx-tlx)/2, tly+1);
    
    // Scaterance text
    if (text_flag) {
      fill(128);
      strokeWeight(2.5);
      textSize(12);
      textAlign(RIGHT, BOTTOM);
      text("Sct = " + nf(scaterance, 1, 3), brx, tly);
    }
  }

  boolean contains(Photon p) {
    return (p.xpos>tlx & p.xpos<brx) & (p.ypos>tly & p.ypos<bry);
  }

  void interact(Photon p) {
    if (this.contains(p) & random(0, 1)<scaterance) {
      //int sign = 1; if (random(0,1)<0.5) {sign = -sign;}; // Random +-1 
      //speedy = 10*sign; //speedx = 0;
      PVector v1 = new PVector(p.speedx, p.speedy);
      float angle = PI/2 + randomGaussian()/10;
      if (random(0,1)<0.5) {angle = -angle;};
      v1.rotate(angle);
      p.speedx = v1.x; 
      p.speedy = v1.y;
    }
  }
}
