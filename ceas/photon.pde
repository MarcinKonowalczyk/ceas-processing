class Photon {
  float xpos, ypos, speedx, speedy;
  float oxpos;
  boolean alive;
  float[] xpos_history, ypos_history;
  Photon(float x, float y) {
    xpos = x; ypos = y; speedx = 10; speedy = 0;
    oxpos = x;
    alive = true;
    xpos_history = new float[5]; ypos_history = new float[5];
    for (int i = 0; i < xpos_history.length; i++) {
      xpos_history[i] = x; ypos_history[i] = y;
    }
  }
  void update() {
    oxpos = xpos; // Old x position (for collision detection)
    float alpha = speed_of_light/10.0; // Correction for the speed of light
    xpos += speedx*alpha; ypos += speedy*alpha; // Movement
    ypos += random(-0.2,0.2); // Dispersion
    
    // Die if out of the frame
    if (xpos > width | xpos<0) {alive = false;}
    if (ypos > height | ypos<0) {alive = false;}
    
    // Interact with everything
    for (Mirror mirror:M) {mirror.interact(this);}
    for (Absorber abs:A) {abs.interact(this);}
    for (Scaterer sct:S) {sct.interact(this);}
    for (Detector det:D) {det.interact(this);}
    
    // Position history (for drawing)
    for (int i = 1; i < xpos_history.length; i++) {
      xpos_history[i-1] = xpos_history[i]; ypos_history[i-1] = ypos_history[i];
    }
    xpos_history[xpos_history.length-1] = xpos; ypos_history[ypos_history.length-1] = ypos;
  }
  
  // Draw self
  void show() {
    noFill();
    float[] photon_color = {252, 186, 3};
    if (speed_of_light>5) {
      for (int i = 1; i < xpos_history.length; i++) {
        float alpha = (1.0*i/(xpos_history.length-1));
        //alpha = alpha*alpha;
        alpha = (2*alpha-1)/((2*alpha-1)*(2*alpha-1)+1)+0.5;
        strokeWeight(2.0*alpha + 0.5);
        stroke(photon_color[0],photon_color[1],photon_color[2],20*alpha);
        line(xpos_history[i-1],ypos_history[i-1],xpos_history[i],ypos_history[i]);
      }
    } else {
      noStroke();
      fill(photon_color[0],photon_color[1],photon_color[2]);
      ellipse(xpos,ypos,2,2);
    }
  }
}
