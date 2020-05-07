ArrayList<Photon> P = new ArrayList<Photon>(0);
ArrayList<Mirror> M = new ArrayList<Mirror>(0);
ArrayList<Absorber> A = new ArrayList<Absorber>(0);
ArrayList<Scaterer> S = new ArrayList<Scaterer>(0);
ArrayList<Detector> D = new ArrayList<Detector>(0);

boolean spawn_toggle = false; // Toggle continous spawn
boolean spawn_single = false; // Spawn single burst
int Nspawn = 16; // Number of photons to spawn per click
int speed_of_light = 10; // Pixels per frame

void setup() {
  size(1000, 500);
  //fullScreen();
  ellipseMode(CENTER);
  rectMode(CORNERS);
  frameRate(30);
  
  float scene_height = 300;
  float[] align_rungs = new float[5];
  float rung_spacing = scene_height/(align_rungs.length-1);
  for (int i = 0; i<align_rungs.length; i++) {
    align_rungs[i] = (height-scene_height)/2 + i*rung_spacing;
  }
  M.add(new Mirror(width*0.2, align_rungs[0], align_rungs[4], 0.9));
  M.add(new Mirror(width*0.8, align_rungs[1], align_rungs[4], 0.9));
  
  A.add(new Absorber(
    width/2-50-100, align_rungs[2]+10,
    width/2+50-100, align_rungs[3]-10, 0.04));
  
  S.add(new Scaterer(
    width/2-50+100, align_rungs[3]+10,
    width/2+50+100, align_rungs[4]-10, 0.01));
  
  D.add(new Detector(
    width*0.9, align_rungs[1]+20,
    width*0.9+rung_spacing-40, align_rungs[2]-20,1));
  D.add(new Detector(
    width*0.9, align_rungs[2]+20,
    width*0.9+rung_spacing-40, align_rungs[3]-20,2));
  D.add(new Detector(
    width*0.9, align_rungs[3]+20,
    width*0.9+rung_spacing-40, align_rungs[4]-20,3));
}

void draw() {
  background(10);
  noStroke();
  fill(255);
  ellipse(mouseX,mouseY,2,2);
  
  // Spawn new stuff
  if (mousePressed | spawn_toggle | spawn_single) {
    for (int i=0; i < Nspawn; i++) {
      float yoffset = randomGaussian()*1; float xoffset = random(-10,10);
      P.add(new Photon(mouseX+xoffset, mouseY+yoffset));
      spawn_single = false; // Reset spawn single
    }
  }

  for (Detector det : D) {
    det.show();
    det.record_line();
  }

  // Draw absorbers and scaterers
  for (Absorber abs : A) {abs.show();}
  for (Scaterer sct : S) {sct.show();}
  
  // Update and draw photon
  for (int i = P.size()-1; i >= 0; i--) {
    Photon photon = P.get(i);
    if (!photon.alive) {P.remove(i);}
    else {photon.update(); photon.show();}
  }

  // Draw mirrors
  for (Mirror mirror : M) {mirror.show();}

  draw_info_text(); // Info text
  draw_author_text(); // Author text
  draw_control_hints(); // Control hints
}

// Keyboard control
void keyPressed() {
  if (keyCode == BACKSPACE) {
    for (int i = P.size()-1; i >= 0; i--) {P.remove(i);}
    for (Detector det : D) {det.count = 0; det.stop_recording();}
    spawn_toggle = false;
  } else if (keyCode == 32) { // Space = Single spawn
    spawn_single = true;
  } else if (keyCode == 84) { // T = Toggle spawn
    spawn_toggle = !spawn_toggle;
  } else if (keyCode == 82) { // R = Record
    for (Detector det : D) {
      if (!det.record_flag) {det.start_recording();}
      else {det.stop_recording();}
    }
  } else if (keyCode == 76) { // L = Labels
    for (Mirror miror : M) {miror.text_flag = !miror.text_flag;}
    for (Absorber abs : A) {abs.text_flag = !abs.text_flag;}
    for (Scaterer sct : S) {sct.text_flag = !sct.text_flag;}
  } else if (keyCode == UP) { // UP
    Nspawn = min(round(Nspawn*2),8192);
  } else if (keyCode == DOWN) { // DOWN
    Nspawn = max(round(Nspawn/2),1);
  } else if (keyCode == RIGHT) { // RIGHT
    if (speed_of_light==1) {speed_of_light = 5;}
    else {speed_of_light = min(round(speed_of_light+5),40);}
  } else if (keyCode == LEFT) { // LEFT
    speed_of_light = max(round(speed_of_light-5),1);
  }
}

void stop() {
  for (Detector det : D) {
    det.record_flag = false;
    det.stop_recording();
  }
  exit();
}
