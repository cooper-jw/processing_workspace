int fps = 60;
boolean gen = false;
int dim = 1000; //screensize
//vars----------------





void setup() {
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(8);
  background(0);
  //setup--------------



}

void draw() {
  //draw----------------





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
