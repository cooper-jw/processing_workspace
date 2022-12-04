//system--------------
int fps = 30;
boolean gen = false;
int dim = 1000; //screensize
boolean debugText = false;

//modifiers-----------
color backgroundColor = color(0, 0, 0);
color lineColor = color(253, 253, 253);
int lineAlpha = 10;
float lineStrokeWeight = 2.0;

float linesMin = 1.0;
float linesMax = 3.0;
float wavesMin = 5.0;
float wavesMax = 7.0;
float radiusPercent = 0.2;
float stepMin = 1.0;
float stepMax = 6.0;
float stepMult = 0.05;


//runtime-------------
ArrayList<ArrayList<PVector>> shapes;
int lines;
int waves;
float radius;
float step;
int nodeMax;
int cycleCnt;
int frmCnt;

//temp
int frmRate = 30;
int frmMorph;
int cycles = 4;
int frmMax;
boolean init = false;
boolean complete = false;
boolean renderOnComplete = true;
boolean autoReset = true;
//----------

ArrayList<PVector> nodesFrom;
ArrayList<PVector> nodesTo;

void setup() {
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(8);
  background(backgroundColor);

  init = false;
}

void create() {
  //temp setup
  nodesFrom = new ArrayList<PVector>();
  nodesTo = new ArrayList<PVector>();
  frmMorph = frmRate * 3;
  frmMax = frmMorph * cycles;
  cycleCnt = 0;
  frmCnt = 0;
  //

  //setup shape modifiers
  lines = floor(random(linesMin, linesMax));
  waves = floor(random(wavesMin, wavesMax));
  radius = min(width, height) * radiusPercent;
  step = floor(random(stepMin, stepMax)) * stepMult;
  
  //populate shapes
  shapes = new ArrayList<ArrayList<PVector>>();
  for (int i = 0; i < cycles; i++) {
    shapes.add(getShape(lines, waves, i, radius, step));
  }
  nodeMax = shapes.get(0).size();

  

  init = true;
  debugLine("setup complete");
}


void draw() {
  if (init == false) {
    create();
    return;
  }
  
  //draw----------------

  //set translate to center
  translate(width * 0.5, height * 0.5);

  if (frmCnt < frmMax) {
    //select morphing objects
    debugLine("frmCnt " + frmCnt + " frmMorph " + frmMorph + " % " + (frmCnt%frmMorph));
    if (frmCnt % frmMorph == 0) {
      cycleCnt = frmCnt / frmMorph;
      nodesFrom = shapes.get(cycleCnt);
      debugLine("nodesFromLen " + shapes.size() + " cycleCnt " + cycleCnt + " nodesFromLenCylceCnt " + shapes.get(cycleCnt).size());
      nodesTo = shapes.get((cycleCnt + 1) % cycles);
    }

    //easing calculation
    float frmRatio = map(frmCnt % frmMorph, 0, frmMorph - 1, 0.0, 1.0);
    float morphRatio = easeInOutCubic(frmRatio);
    float easeRatio = InFourthPow(frmRatio);

    //set strokes
    noFill();
    stroke(lineColor, lineAlpha);
    strokeWeight(lineStrokeWeight);
    
    //draw lines
    beginShape();
    for (int i = 0; i < nodeMax + 3; i++) {
      //j is for close the curve.
      //ref. https://www.deconbatch.com/2021/01/processing-curvevertex-memo.html
      int j = i % nodeMax;
      debugLine("j " + j + " i " + i + " % " + nodeMax + " nodesFromLen " + nodesFrom.size() + " nodesToLen " + nodesTo.size());
      float nodeRatio = map(j, 0, nodeMax, 0.0, 1.0);
      plotVertex(nodesFrom.get(j), nodesTo.get(j), nodeRatio, easeRatio, morphRatio * morphRatio);
    }
    endShape();

    frmCnt++;
  }
  else if (!complete) {
    complete = true;
    println("Complete!");
    if (renderOnComplete) gen = true;
  }

  if (gen) {
    gen = false;
    saveTheFrame();
  }

  if (complete && autoReset) {
    reset();
  }
}

private ArrayList<PVector> getShape(int _lines, int _waves, int _shape, float _radius, float _step) {
  ArrayList<PVector> line = new ArrayList<PVector>();
  
  //curve lines
  float phase = random(PI);
  for (int l = 0; l < _lines; l++) {
    for (float theta = 0.0; theta < TWO_PI; theta += PI * _step) {
      float t = (theta + phase) % TWO_PI;
      float r = _radius * (1.0 + 0.4 * sin(sin(t * (_waves + _shape) + l * TWO_PI / _lines) * TWO_PI));
      float x = r * cos(t);
      float y = r * sin(t);
      line.add(new PVector(x, y));
    }
  }
  return(line);
}

void plotVertex(PVector _from, PVector _to, float _ratioN, float _ratioM, float _ratioS) {
  float rT = _ratioM * constrain(_ratioN + _ratioS, 0.0, 1.0);
  float rF = 1.0 - rT;
  float nX = (_from.x * rF + _to.x * rT);
  float nY = (_from.y * rF + _to.y * rT);
  //blendMode(DIFFERENCE); //boxes
  //rect(nX, nY, nX, nY); //boxes
  curveVertex(nX, nY); //curves
}

float easeInOutCubic(float t) {
  t *= 2.0;
  if (t < 1.0) {
    return pow(t, 3) / 2.0;
  }
  t -= 2.0;
  return (pow(t, 3) + 2.0) / 2.0;
}

private float InFourthPow(float _t) {
  return 1.0 - pow(1.0 - _t, 4);
}

//export----------------
void keyPressed() {
  if (key == 'g') {
    gen = true;
  }
}

void mousePressed() {
  reset();
}

void reset() {
  background(backgroundColor);
  init = false;
  complete = false;
}

void saveTheFrame() {
  String path = sketchPath();
  File f = new File(path+"/render");
  int ind = 0;
  if (f.list() != null) {
    ind = f.list().length;
  }
  String fileName = "render/out"+Integer.toString(ind)+".png";
  saveFrame(fileName);
  println("Saved to " + fileName);
}

void debugLine(String s) {
  if (debugText) println(s);
}
