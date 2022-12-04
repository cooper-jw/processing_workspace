/**
 * Heartbeats Accelerating.
 * The heartbeat of recurring formula.
 * 
 * Processing 3.5.3
 * @author @deconbatch
 * @version 0.1
 * created 0.1 2021.04.04
 */

void setup() {
  size(720, 720);
  colorMode(HSB, 360.0, 100.0, 100.0, 100.0);
  rectMode(CENTER);
  smooth();
  noStroke();
}

void draw() {

  int   frmMax    = 24 * 12; // 24fps x 12s
  int   calcMax   = 50;
  int   phaseMax  = 3000;
  float shapeVal  = random(-0.1, 0.1);
  float phaseInit = random(TWO_PI);
  float baseHue   = random(360.0);

  translate(width / 2, height / 2);
  for (int frmCnt = 0; frmCnt < frmMax; ++frmCnt) {
    float frmRatio = map(frmCnt, 0, frmMax, 0.0, 1.0);

    blendMode(BLEND);
    background(0.0, 0.0, 90.0, 100.0);

    blendMode(SUBTRACT);
    for (int phaseCnt = 0; phaseCnt < phaseMax; ++phaseCnt) {

      float phaseRatio = map(phaseCnt, 0, phaseMax, 0.0, 1.0);
      float prevX = cos(frmRatio * TWO_PI) * shapeVal;
      float prevY = sin(frmRatio * TWO_PI) * shapeVal;
      float prevT = phaseRatio * TWO_PI;
 
      for (int calcCnt = 0; calcCnt < calcMax; ++calcCnt) {

        float calcRatio = map(calcCnt, 0, calcMax, 0.0, 1.0);
        float x = (pow(sin(prevX), 2) + cos(prevY)) * sin(prevT);
        float y = (pow(cos(prevX), 2) + sin(prevY)) * cos(prevT);
        float t = prevT + phaseInit + (calcRatio + x + y) * shapeVal + TWO_PI * frmRatio;

        float eHue = baseHue + calcRatio * 120.0;
        float eSat = 30.0 + abs(sin((phaseRatio * 2.0 + frmRatio) * TWO_PI)) * 50.0;
        float eBri = abs(sin((phaseRatio + frmRatio * 2) * TWO_PI)) * 10.0;
        float eSiz = abs(sin((phaseRatio + frmRatio + calcRatio) * TWO_PI)) * 2.0;

        fill(eHue % 360.0, eSat, eBri, 100.0);
        ellipse(x * width * 0.3, y * height * 0.3, eSiz, eSiz);

        prevX = x;
        prevY = y;
        prevT = t;
      }
          
    }

    blendMode(BLEND);
    casing();
    saveFrame("frames/" + String.format("%04d", frmCnt) + ".png");

  }

  exit();

}

/**
 * casing : draw fancy casing
 */
private void casing() {
  fill(0.0, 0.0, 0.0, 0.0);
  strokeWeight(34.0);
  stroke(0.0, 0.0, 0.0, 100.0);
  rect(0.0, 0.0, width, height);
  strokeWeight(30.0);
  stroke(0.0, 0.0, 100.0, 100.0);
  rect(0.0, 0.0, width, height);
  noStroke();
  noFill();
  noStroke();
}