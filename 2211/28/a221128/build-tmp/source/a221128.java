/* autogenerated by Processing revision 1289 on 2022-11-29 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class a221128 extends PApplet {

int[][] palette = { {0xFF5EFC8D, 0xFF8EF9F3, 0xFF93BEDF, 0xFF8377D1, 0xFF6D5A72}, //og
                      {0xFF397367, 0xFF8EF9F3, 0xFF93BEDF, 0xFF35393C, 0xFFFAF33E}, //blues, yellows, greens
                      {0xFFADA8B6, 0xFF8EF9F3, 0xFF4C3B4D, 0xFFA53860, 0xFF067BC2}, //blues pinks purples
                      {0xFF0C090D, 0xFF8EF9F3, 0xFFE01A4F, 0xFFF15946, 0xFFF9C22E}, //blue pink peach yeloow
                      {0xFFF991CC, 0xFF8EF9F3, 0xFF499167, 0xFF3F4531, 0xFF7284A8}  //pink blues greens
                    };
boolean gen = false;
float y = 0;
float speed = .05f;
float segMult = .2f;
float limit = height;
float seed = random(10000);
int col2;
int index=0;
int seg;
float div = random(.01f, .1f);
float h = 60;
boolean saveEachPass = true;
int maxPass = 5;
int fps = 400;
int paletteId = 0;
int passCount = 0;
Circle c;


public void setup() {
  /* size commented out by preprocessor */;
  frameRate(fps);
  /* smooth commented out by preprocessor */;
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
  limit = height*.8f;
  y=(height-height*.8f)-h;
  seg = (int)(width*segMult);
  div = random(.001f, .01f);
  c = new Circle();
  c.x = width*segMult;
  c.y =width*segMult;
  c.r = random(120, 200);
  passCount = 0;
}


public void draw()
{
  float py = 0;
  float px = 0;
  float w=width*.8f;
  // y = height*.5;
  pushMatrix();
  translate(width*.5f, height*.5f);
  translate(-w*.5f, -height*.5f);

  blendMode(ADD);
  beginShape(LINES);
  stroke(0);
  for (int i=0; i<seg+1; i++) {
    float delta = i/(float)seg;
    float x = delta*w;
    float my =(delta+frameCount*.01f)*h;
    float noi = noise(x*.02f, y*.002f, seed+frameCount*div);
    int ci = (int)(noi*palette[paletteId].length);
    int col = palette[paletteId][ci];
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
    y=(height-height*.8f)-h;
    seed = random(10000);
    seg = (int)(width*(random(.05f, segMult)));
    div = random(.001f, .01f);
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

public void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}

public void saveTheFrame()
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


  public void settings() { size(1000, 1000, P3D);
smooth(8); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a221128" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
