color[][] palette = { {#5efc8d, #8ef9f3, #93bedf, #8377d1, #6d5a72}, //og
                      {#397367, #8ef9f3, #93bedf, #35393c, #faf33e}, //blues, yellows, greens
                      {#ada8b6, #8ef9f3, #4c3b4d, #a53860, #067bc2}, //blues pinks purples
                      {#0c090d, #8ef9f3, #e01a4f, #f15946, #f9c22e}, //blue pink peach yeloow
                      {#f991cc, #8ef9f3, #499167, #3f4531, #7284a8}  //pink blues greens
                    };
boolean gen = false;
float y = 0;
float speed = .05;
float segMult = .2;
float limit = height;
float seed = random(10000);
color col2;
int index=0;
int seg;
float div = random(.01, .1);
float h = 60;
boolean saveEachPass = false;
int maxPass = 5;
int fps = 400;
int paletteId = 0;
int passCount = 0;
Circle c;


void setup() {
  size(1000, 1000, P3D);
  frameRate(fps);
  smooth(8);
  background(0);

  paletteId = (int)random(palette.length);
  if (paletteId > palette.length)
    paletteId = 0;
  println("Palette Id = " + paletteId);
  index = (int)random(palette[paletteId].length);
  if (index > palette[paletteId].length-1)
    index = 0;
  col2 = palette[paletteId][index];

  h =  random(50, 120);
  limit = height*.8;
  y=(height-height*.8)-h;
  seg = (int)(width*segMult);
  div = random(.001, .01);
  c = new Circle();
  c.x = width*segMult;
  c.y =width*segMult;
  c.r = random(120, 200);
  passCount = 0;
}


void draw()
{
  float py = 0;
  float px = 0;
  float w=width*.8;
  // y = height*.5;
  pushMatrix();
  translate(width*.5, height*.5);
  translate(-w*.5, -height*.5);

  blendMode(ADD);
  beginShape(LINES);
  stroke(0);
  for (int i=0; i<seg+1; i++) {
    float delta = i/(float)seg;
    float x = delta*w;
    float my =(delta+frameCount*.01)*h;
    float noi = noise(x*.02, y*.002, seed+frameCount*div);
    int ci = (int)(noi*palette[paletteId].length);
    color col = palette[paletteId][ci];
    float my2 = noi*h;
    float fy = y+my2;
    float d = dist(c.x, c.y, x, fy);
    float al = 10;
    if (d < c.r*segMult)
    {
      float a = atan2(c.y-fy, c.x-x);
      float r2 = (c.r)*noi;

      x = c.x+cos(a)*-r2;
      fy = c.y+sin(a)*-r2;
    }



    if (i > 0) {
      stroke(col2, noi*al);
      vertex(px, py);

      vertex(x, fy);
    }

    py = fy;
    px = x;
  }
  endShape();
  blendMode(NORMAL);
  popMatrix();

  y+=speed;
  if (y > limit)
  {
    passCount++;
    index++;
    if (index > palette[paletteId].length-1)
      index = 0;
    col2 = palette[paletteId][index];
    h = random(50, 120);
    y=(height-height*.8)-h;
    seed = random(10000);
    seg = (int)(width*(random(.05, segMult)));
    div = random(.001, .01);
    c.x = random(0, width);
    c.y =random(0, height);
    c.r =  random(60, 200);
    if (saveEachPass) 
    {
      gen = true;
    }
  }
  if (gen)
  {
    gen = false;
    saveTheFrame();
    println("SAVE");
  }
  if (maxPass > 0 && passCount >= maxPass)
  {
    println("QUIT ON MAX PASS " + passCount);
    exit();
  }
}

void keyPressed()
{
  if (key == 'g')
  {
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

class Circle
{
  float x;
  float y;
  float r;
  Circle()
  {
  }
}
