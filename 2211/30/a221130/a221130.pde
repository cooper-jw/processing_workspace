int fps = 120;
boolean gen = false;
int dim = 1000; //screensize
//vars----------------
boolean reset = false;
float angleNoise, radiusNoise;
float xNoise, yNoise;
float angle = PI/2;
float radius;
float strokeColor = 253;
int strokeChange = 2;
int lineStrokeWeight = 2;
float ellipseSize = 1;
int maxRadius = 550;

boolean randomBgShade = true;
boolean whiteBg = false;
boolean useMaxAge = true;
boolean renderOnReset = true;
int age = 0;
int maxAge = 0;
int maxAgeMin = 75;
int maxAgeMax = 600;

void setup() {
  //setup--------------
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(8);
  
  start();
}

void start() {
  reset = false;

  age = 0;
  maxAge = int(random(maxAgeMin, maxAgeMax));
  println("Living for " + maxAge + " frames.");

  if (randomBgShade) whiteBg = (maxAge % 2 == 0);

  if (whiteBg) background(255);
  else background(0);

  strokeWeight(5);
  noFill();

  angleNoise = random(20);
  radiusNoise = random(20);
  xNoise = random(20);
  yNoise = random(20);
}

void draw() {
  if (reset) start();

  //draw----------------
  noFill();
  radiusNoise += 0.005;
  radius = (noise(radiusNoise) * maxRadius) + 1;

  angleNoise+=0.03;
  angle+=(noise(angleNoise) * 10) - 5;
  if(angle > 360) angle-=360;
  if(angle < 0) angle+=360;

  xNoise+=0.02;
  yNoise+=0.01;
  float centerX = width/2 + (noise(xNoise) * 200) - 100;
  float centerY = height/2 + (noise(yNoise) * 200) - 100;

  float rad = radians(angle);
  float x1 = centerX + (radius*cos(rad));
  float y1 = centerY + (radius*sin(rad));

  float oppRad = rad + PI;
  float x2 = centerX + (radius*cos(oppRad));
  float y2 = centerY + (radius*sin(oppRad));

  strokeColor += strokeChange;
  if(strokeColor > 254) 
    strokeChange = strokeChange * -1;
  else if(strokeColor < 0) 
    strokeChange = strokeChange * -1;

  stroke(strokeColor, 60);
  strokeWeight(lineStrokeWeight);
  line(x1, y1, x2, y2);
  fill(strokeColor, 60);
  ellipse(x1, y1, ellipseSize, ellipseSize); //ellipse(x, y, width, height);
  ellipse(x2, y2, ellipseSize, ellipseSize);

  age++;

  if (age >= maxAge) {
    if (renderOnReset) gen = true;
    reset = true;
  }

  if (gen) {
    gen = false;
    saveTheFrame();
  }
}

float customNoise(float v) {
  float retValue = pow(sin(v), 3);
  return retValue;
}

void keyPressed() {
  if (key == 'g') {
    gen = true;
  }
}

void mousePressed() {
  reset = true;
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
