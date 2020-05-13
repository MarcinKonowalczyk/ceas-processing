class Photon {
  float xpos, ypos, speedx, speedy;
  float oxpos;
  boolean alive;
  float[] xpos_history, ypos_history;
  Photon(float x, float y) {
    xpos = x; 
    ypos = y; 
    speedx = 10; 
    speedy = 0;
    oxpos = x;
    alive = true;
    xpos_history = new float[2]; 
    ypos_history = new float[2];
    for (int i = 0; i < xpos_history.length; i++) {
      xpos_history[i] = x; 
      ypos_history[i] = y;
    }
  }
  void update() {
    oxpos = xpos; // Old x position (for collision detection)
    float alpha = speed_of_light/10.0; // Correction for the speed of light
    xpos += speedx*alpha;  ypos += speedy*alpha; // Movement
    ypos += random(-0.2, 0.2); // Dispersion

    // Die if out of the frame
    if (xpos>width | xpos<0) {alive = false;}
    if (ypos>height | ypos<0) {alive = false;}

    // Interact with everything
    for (Mirror mirror : M) {mirror.interact(this);}
    for (Absorber abs : A) {abs.interact(this);}
    for (Scaterer sct : S) {sct.interact(this);}
    for (Detector det : D) {det.interact(this);}
  }

  // Draw self
  void show() {
    //noFill();
    //stroke(#d74f6f);
    //ellipse(xpos,ypos,2,2);
    point(xpos, ypos);
  }
}

void spawn_at_xy(float x, float y) {
  for (int i=0; i < Nspawn; i++) {
    float xspread = speed_of_light/2 + speed_of_light/2;
    float yspread = min(2,xspread);
    float yoffset = randomGaussian()*yspread; 
    float xoffset = randomGaussian()*xspread;
    P.add(new Photon(x+xoffset, y+yoffset));
    spawn_single = false; // Reset spawn single
  }
}

// Photon source
class Source {
  float xpos, ypos;
  int phase; // Blinking phase
  int blink_period = 30;
  Source(float x, float y) {
    xpos = x; ypos = y;
    phase = round(random(0,blink_period));
  }
  
  void show() {
  noFill(); stroke(255);
  float size = ((frameCount+phase) % blink_period)*10.0/blink_period+10;
  strokeWeight(1);
  ellipse(xpos,ypos,size,size);
  }
}
    
