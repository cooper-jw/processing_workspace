int fps = 240;
boolean gen = false;
int dim = 1000; //screensize
float dimUsablePerc = 0.5;
//vars----------------
float a, b, c, d;
float gs = 3.5;
float gx = 0.5;
float gy = 0.75;
int fadebg;
int exposures;
int maxage = 128;  

int num = 0;
int maxnum = 4000;
TravelerHenon[] travelers = new TravelerHenon[maxnum];

// frame counter for animation
float time;

void setup() {
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(16);
  background(0);
  rectMode(CORNER);
  noStroke();

  // bourke constants
  a = 2.01;
  b = -2.53;
  c = 1.61;
  d = -0.33;
  
  // make some travelers
  for (int i=0;i<maxnum;i++) {
    travelers[i] = new TravelerHenon();
    num++;
  } 
}

void draw() {
  //draw----------------
  for (int i=0;i<num;i++) {
    travelers[i].draw();
  }
  exposures+=num;
  //casing();

  if (gen) {
    gen = false;
    saveTheFrame();
    println("SAVE");
  }
}

float casingPercent = 0.03;
private void casing() {
  fill(0.5,0.8,0.0);
  stroke(0.5,0.8,0.0);
  rect(0.0, 0.0, width * casingPercent, height);
  rect(0.0, 0.0, width, height * casingPercent);
  rect(width - (width * casingPercent), 0.0, width, height);
  rect(0.0, height - (height * casingPercent), width, height);
  noStroke();
  noFill();
}

void keyPressed() {
  if (key == 'g') {
    gen = true;
  }
}

void mousePressed() {
  // reset the image  
  reset();
}

void reset() {
  background(0);
  exposures = 0;
  gs = 3.0;
  gx = 0.5;
  gy = 0.5;
  a = random(-2.5,2.5);
  b = random(-2.5,2.5);
  c = random(-2.5,2.5);
  d = random(-2.5,2.5);
  
  for (int i=0;i<num;i++) {
    travelers[i].rebirth();
  }

}

void saveTheFrame() {
  String path = sketchPath();
  File f = new File(path+"/render");
  int ind = 0;
  if (f.list() != null) {
    ind = f.list().length;
  }
  saveFrame("render/out"+Integer.toString(ind)+".png");
}


class TravelerHenon {
  float x, y;
  float xn, yn;

  int age = 0;
  
  TravelerHenon() {
    // constructor
    x = random(-1.0,1.0);
    y = random(-1.0,1.0);
  }
  
  void draw() {
      // move through time
      xn = sin(a*y) - cos(b*x);
      yn = sin(c*x) - cos(d*y);
      
      float d = sqrt((xn-x)*(xn-x) + (yn-y)*(yn-y));
      x = xn;
      y = yn;
      
      // render single transparent pixel
      stroke(255,5);
      point((x/gs+gx)*dim,(y/gs+gy)*dim);
      //point(((x/gs+gx)*dim)-((dim*dimUsablePerc)/2),((y/gs+gy)*dim)-((dim*dimUsablePerc)/2));

      // age
      age++;
      if (age>maxage) {
        // begin anew
        rebirth();
      }
        
  }  
  
  void rebirth() {
    x = random(0.0,1.0);
    y = random(-1.0,1.0);
    age = 0;
  }    
 
}    
