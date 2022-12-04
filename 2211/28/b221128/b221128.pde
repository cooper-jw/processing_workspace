boolean gen = false;
boolean res = false;

void setup() {
  size(1000, 1000);
  colorMode(HSB, 360.0, 100.0, 100.0, 100.0);
  rectMode(CENTER);
  smooth();
  noLoop();
}

void draw() {
  if(frameCount==1 || res) {
    background(0.0, 0.0, 90.0, 100.0);
    create();
  }
  
  if (gen) {
    gen = false;
    saveTheFrame();
    println("SAVE");
  }

  //exit();
}

void create() {
  int frmRate  = 12;
  int frmMorph = frmRate * 3;       // morphing duration frames
  int cycles   = 6;                 // animation cycle no
  int frmMax   = frmMorph * cycles; // whole frames

  // shapes
  int   lines  = floor(random(2.0, 6.0));
  int   waves  = floor(random(3.0, 5.0));
  float radius = min(width, height) * 0.25;
  float step   = floor(random(1.0, 6.0)) * 0.05;
  ArrayList<ArrayList<PVector>> shapes = new ArrayList<ArrayList<PVector>>();
  for (int i = 0; i < cycles; i++) {
    shapes.add(getShape(lines, waves, i, radius, step));
  }
  int nodeMax = shapes.get(0).size();

  // morphing tools
  ArrayList<PVector> nodesFrom = new ArrayList<PVector>();
  ArrayList<PVector> nodesTo   = new ArrayList<PVector>();
  int cycleCnt = 0;

  translate(width * 0.5, height * 0.5);
  for (int frmCnt = 0; frmCnt < frmMax; frmCnt++) {
    //background(0.0, 0.0, 90.0, 100.0);

    // select morphing objects
    if (frmCnt % frmMorph == 0) {
      cycleCnt = frmCnt / frmMorph;
      nodesFrom = shapes.get(cycleCnt);
      nodesTo   = shapes.get((cycleCnt + 1) % cycles);
    }

    // easing calculation
    float frmRatio = map(frmCnt % frmMorph, 0, frmMorph - 1, 0.0, 1.0);
    float morphRatio = easeInOutCubic(frmRatio);
    float easeRatio  = InFourthPow(frmRatio);

    // draw
    fill(1.0, 1.0); //boxes
    //noFill(); //lines
    stroke(0.0, 0.0, 30.0, 5.0);
    strokeWeight(2.0);
    beginShape();
    for (int i = 0; i < nodeMax + 3; i++) {
      // j is for close the curve.
      // ref. https://www.deconbatch.com/2021/01/processing-curvevertex-memo.html
      int j = i % nodeMax;
      float nodeRatio = map(j, 0, nodeMax, 0.0, 1.0);
      plotVertex(nodesFrom.get(j), nodesTo.get(j), nodeRatio, easeRatio, morphRatio * morphRatio);
    }
    endShape();
    //casing();

    //saveFrame("frames/" + String.format("%04d", frmCnt) + ".png");
    
  }
  saveTheFrame();
}

void keyPressed() {
  if (key == 'g') {
    gen = true;
  }
}

void mousePressed() {
  reset();
}

void reset() {
  res = true;
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

/**
 * getShape : get shape points.
 * @param _lines, _waves, _shape : shape parameters
 * @param _radius : shape size 
 * @param _step   : vertex points spacing
 * @return   : PVector array of shape points
 */
private ArrayList<PVector> getShape(int _lines, int _waves, int _shape, float _radius, float _step) {
  ArrayList<PVector> line = new ArrayList<PVector>();
  
  // curve lines
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

/**
 * plotVertex : plot the vertex with morphing calculation.
 * @param  _from, _to : nodes to draw, morphing from and to
 * @param  _ratioN    : vartex number ratio
 * @param  _ratioM    : morphing ratio
 * @param  _ratioS    : shift ratio for viscous moving
 */
void plotVertex(PVector _from, PVector _to, float _ratioN, float _ratioM, float _ratioS) {
  float rT = _ratioM * constrain(_ratioN + _ratioS, 0.0, 1.0);
  float rF = 1.0 - rT;
  float nX = (_from.x * rF + _to.x * rT);
  float nY = (_from.y * rF + _to.y * rT);
  blendMode(DIFFERENCE); //lines
  //rect(nX, nY, nX, nY); //lines
  curveVertex(nX, nY); //curves
}

/**
 * easeInOutCubic easing function.
 * @param  t     0.0 - 1.0 : linear value.
 * @return float 0.0 - 1.0 : eased value.
 */
float easeInOutCubic(float t) {
  t *= 2.0;
  if (t < 1.0) {
    return pow(t, 3) / 2.0;
  }
  t -= 2.0;
  return (pow(t, 3) + 2.0) / 2.0;
}
  
/**
 * InFourthPow : easing function.
 * @param  _t    0.0 - 1.0 : linear value.
 * @return       0.0 - 1.0 : eased value.
 */
private float InFourthPow(float _t) {
  return 1.0 - pow(1.0 - _t, 4);
}

/**
 * casing : draw fancy casing
 */
private void casing() {
  fill(0.0, 0.0, 0.0, 0.0);
  strokeWeight(54.0);
  stroke(0.0, 0.0, 0.0, 100.0);
  rect(0.0, 0.0, width, height);
  strokeWeight(50.0);
  stroke(0.0, 0.0, 100.0, 100.0);
  rect(0.0, 0.0, width, height);
  noStroke();
  noFill();
  noStroke();
}