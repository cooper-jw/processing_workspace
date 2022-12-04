int fps = 60;
boolean gen = false;
int dim = 1000; //screensize
//vars----------------
int stepAmount;
int currentStep;
int startEndSizeDiff;
int totalSteps;

//modifiers-----------
int finalSize = 50;
int startSize = 750;
int inSteps = 5;
int outSteps = 5;


color backgroundColor = color(0, 0, 0);
color lineColor = color(255, 255, 255);
int lineAlpha = 100;
int lineStrokeWeight = 2;

void setup() {
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(8);
  background(backgroundColor);
  //setup--------------
  startEndSizeDiff = startSize - finalSize;
  totalSteps = inSteps + outSteps;
  stepAmount = startEndSizeDiff / totalSteps;

}

void draw() {
  //draw----------------
  stroke(lineColor, lineAlpha);
  strokeWeight(lineStrokeWeight);
  noFill();

  ellipse(dim/2, dim/2, startSize, startSize);


  if (gen) {
    gen = false;
    saveTheFrame();
  }
}

void keyPressed() {
  if (key == 'g' || key == 'G') {
    gen = true;
  }
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
