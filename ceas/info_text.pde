void draw_info_text() {
  fill(255);
  strokeWeight(2.5);
  textSize(12);
  textAlign(RIGHT, TOP);
  String t = 
    "fps : " + nf(frameRate,2,2) + "\n" +
    "frame : " + nf(frameCount,4) + "\n" +
    //"-----\n" + 
    "alive : " + nf((int) P.size(),4) + "\n" +
    "N : " + nf(Nspawn,4) + "\n" +
    "c : " + nf(speed_of_light,4);
  text(t, width-5, 0+5);
}

void draw_author_text() {
  fill(128);
  strokeWeight(2.5);
  textSize(10);
  textAlign(BOTTOM, LEFT);
  String t = "Marcin Konowalczyk | Oxford/Oldenburg virtual meeting, 14/02/20";
  text(t, 5, height-5);
}

void draw_control_hints() {
  fill(128);
  strokeWeight(2.5);
  textSize(10);
  textAlign(LEFT, TOP);
  String t = "[backspace] - reset\n" +
  "[spacebar] - single spawn\n" +
  "[up/down] - spawn rate\n" +
  "[left/right] - speed of light\n" +
  "[T] - toggle spawn\n" +
  "[S] - spawn source\n" +
  "[L] - show labels\n" + 
  "[R] - toggle record";
  text(t, 5, 5);
}
