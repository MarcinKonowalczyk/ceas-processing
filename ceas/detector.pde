class Detector {
  float tlx, tly, brx, bry;
  int count, detector_numer;
  float dwidth, dheight;
  // Recording stuff
  boolean record_flag, writer_exists;
  PrintWriter output;
  int last_recorded_count;

  Detector (float x1, float y1, float x2, float y2, int n) {
    tlx = x1;  
    tly = y1;  
    brx = x2;  
    bry = y2;
    dwidth = brx-tlx; 
    dheight = bry-tly;
    detector_numer = n;
    record_flag = false; 
    writer_exists = false;
    last_recorded_count = -1;
  }

  void show() {
    noStroke();
    //strokeWeight(1); stroke(128);
    fill(128);
    rect(tlx, tly, brx, bry);
    fill(128-64);
    triangle(tlx, tly, tlx, bry, tlx+dwidth/2, tly+dheight/2);

    if (record_flag) {
      strokeWeight(2);
      stroke(128, 0, 0);
      fill(255, 0, 0);
      ellipse(brx-7, tly+6, 8, 8);
    }

    // Count text
    fill(255);
    strokeWeight(2.5);
    textSize(12);
    textAlign(RIGHT, BOTTOM);
    text(nf(count, 3), brx-1, tly-1);
  }

  boolean contains(Photon p) {
    return (p.xpos>tlx & p.xpos<brx) & (p.ypos>tly & p.ypos<bry);
  }

  void interact(Photon p) {
    if (p.ypos>tly & p.ypos<bry) {
      if (
        (p.oxpos<tlx & p.xpos>tlx) | // Left reflect
        (p.xpos==tlx) // Edge case
        ) {
        p.alive = false; 
        count++;
      }
    }
  }

  void start_recording() {
    if (!record_flag) {
      output = createWriter("D" + detector_numer + "_data.txt");
      output.println("frame\tcount");
      record_flag = true;
    }
  }

  void record_line() {
    if (record_flag) {
      if (count != last_recorded_count) {
        output.print(frameCount + "\t");
        output.println(count-last_recorded_count);
        last_recorded_count = count;
      }
    }
  }

  void stop_recording() {
    if (record_flag) {
      output.flush(); // Write remaining data
      output.close(); 
      record_flag = false;
      last_recorded_count = -1;
    }
  }
}
