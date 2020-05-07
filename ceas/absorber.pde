class Absorber {
  float tlx, tly, brx, bry;
  float absorbance;
  boolean text_flag;
  Absorber (float x1, float y1, float x2, float y2, float a) {
    tlx = x1; tly = y1; brx = x2; bry = y2;
    absorbance = a;
    text_flag = false;
  }
  
  void show() {
    noStroke();
    //strokeWeight(1); stroke(128);
    fill(54, 87, 28);//(51, 107, 48);
    rect(tlx,tly,brx,bry,5);
    
    // Absorbance text
      fill(134, 181, 98);
      strokeWeight(2.5);
      textSize(12);
      textAlign(CENTER, TOP);
      text("Absorber", tlx+(brx-tlx)/2, tly+1);
    if (text_flag) {  
      fill(128);
      strokeWeight(2.5);
      textSize(12);
      textAlign(RIGHT, BOTTOM);
      text("Abs = " + nf(absorbance,1,3), brx-1, tly-1);
    }
  }
  
  boolean contains(Photon p) {
    return (p.xpos>tlx & p.xpos<brx) & (p.ypos>tly & p.ypos<bry);
  }
  
  void interact(Photon p) {
    if (this.contains(p) & random(0,1)<absorbance) {
      p.alive = false;
    }
  }
}
