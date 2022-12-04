int fps = 30;
boolean gen = false;
int dim = 1000;           //dimensions of rendering window

color[][] palettes = { {#FFFFFF, #000000},  //og
                      {#397367, #8ef9f3},   //blue yellow
                      {#ada8b6, #8ef9f3},   //blues pink
                      {#0c090d, #8ef9f3},   //blue pink
                      {#f991cc, #8ef9f3},   //pink blue
                      {#F991CC, #000000}    //pink black
                    };

int paletteId = -1;
color lightColour = #F991CC; //#FFFFFF;
color darkColour = #000000; //#1C3041;

int num = 7500;           // total number of particles (5000)
int f = 1;                //initial force (0.2)
float vel = 0.0033;        //constant velocity (0.005)
int ang = 30;             //initial angle (30)
int age = 350;            //max particle age (200)

// blackout is production control of white or black filaments
boolean blackout = false;

// kaons is array of path tracing particles
Particle[] kaons;


// ENVIRONMENTAL METHODS ----------------------------------------------

void setup() {
  size(1000,1000,P3D); //dim = size
  background(0);
  frameRate(fps);
  smooth(8);

  if(paletteId < 0 || paletteId > palettes.length-1) {
    paletteId = (int)random(palettes.length);
    if (paletteId > palettes.length)
      paletteId = 0;
    println("Random palette selected - " + paletteId);
  }
  else println("Manual palette selected - " + paletteId);

  lightColour = palettes[paletteId][0];
  darkColour = palettes[paletteId][1];

  kaons = new Particle[num];

  // begin with particle sling-shot around ring origin
  for (int i=0;i<num;i++) {
    int emitx = int(ang*sin(TWO_PI*i/num)+dim/2);
    int emity = int(ang*cos(TWO_PI*i/num)+dim/2);
    float r = PI*i/num;
    kaons[i] = new Particle(emitx,emity,r);
  }
}

void draw() {
  for (int i=0;i<num;i++) {
    kaons[i].move();
  }
  
  // randomly switch blackout periods
  if (random(10000)>9950) {
    if (blackout) {
      blackout = false;
    } else {
      blackout = true;
    }
  }

  if (gen) {
    gen = false;
    saveTheFrame();
    println("FRAME SAVED");
  }
}

void mousePressed() {
    // manually switch blackout periods
    if (blackout) {
      blackout = false;
    } else {
      blackout = true;
    }
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    exit();
  }
  else if (key == 'g' || key == 'G') {
    gen = true;
  }
}

void saveTheFrame()
{
  String path = sketchPath();
  File f = new File(path+"/render");
  int ind = 0;
  if (f.list() != null) {
    ind = f.list().length;
  }
  saveFrame("render/out"+Integer.toString(ind)+".png");
}

// OBJECTS ----------------------------------------------

// wandering particle
class Particle {
  float ox, oy;
  float x, y;
  float xx, yy;

  float vx;
  float vy;
  int a = int(random(age));
  color i;

  Particle(int Dx, int Dy, float r) {
    // initialize particle origin
    ox = dim/2;
    oy = dim/2;

    x = int(ox-Dx);    // position x
    y = int(oy-Dy);    // position y
    xx = 0;            // position x'
    yy = 0;            // position y'

    vx = f*cos(r);     // velocity x
    vy = f*sin(r);     // velocity y

    if (blackout) {
      i = darkColour;
    } else {
      i = lightColour;
    }
  }

  void move() {
    xx=x;
    yy=y;

    x+=vx;
    y+=vy;

    vx += (random(100)-random(100))*vel;
    vy += (random(100)-random(100))*vel;

    stroke(red(i),green(i),blue(i),24);
    line(ox+xx,oy+yy,ox+x,oy+y);
    line(ox-xx,oy+yy,ox-x,oy+y);

    // grow old
    a++;
    if (a>age) {
      // die and be reborn
      float t = random(TWO_PI);
      x=ang*sin(t);
      y=ang*cos(t);
      xx=0;
      yy=0;
      vx=0;
      vy=0;
      a=0;
      if (blackout) {
        i = darkColour;
      } else {
        i = lightColour;
      }
    }
  }
}

