int fps = 60;
boolean gen = false;
int dim = 1000; //screensize
//vars----------------
int n;         // number of nodes
float fr;      // frame number
float rand;    // random value used for offsetting hue etc. (not in use)
boolean saved; // just so it doesn't save every frame
node[] nodes;

// cos alternative - high a => more squarelike waves
float thc(float a, float b) { 
  return (float)Math.tanh(a * cos(b)) / (float)Math.tanh(a); 
}

public class node {
      public PVector pos; // position
      public PVector vel; // velocity
      public float dist;  // distance travelled
}

void makeNodes() {
  nodes = new node[n];
  for (int i = 0; i < n; i++) {
   nodes[i] = new node();
   //nodes[i].pos = new PVector(2 * width * i / (float)n - 0.5 * width, 1.5 * width); // [-0.5 * width, 1.5 * width]
   nodes[i].pos = new PVector(2.5 * width * i / (float)n - 0.5 * width, 0);
   nodes[i].vel = new PVector(0,0);
   nodes[i].dist = 0;
  }
}

// Play with:
// Changing lerp values, velocities, adding friction, increasing random values,
// offset the hue differently, oscillate opacity with fr or point.pos.y or point.dist, harshen/soften mx (could use exp(-x) instead of 1/cosh),
// could change strokeWeight, or keep opacity constant, idk - a whole bunch of stuff
void doNodes() {
  for (int i = 1; i < n - 1; i++) {
    node point = nodes[i];
    node prev = nodes[i-1];
    node next = nodes[i+1];

    // offset + start y value
    float o = i / (float)n * 2 * PI;
    PVector pointPosition = point.pos.copy();

    // change velocity randomly, lerp towards neighbours' velocities, oscillate side to side and move constantly downwards
    point.vel.y += 0.1 * random(-0.99, 1);     
    point.pos.add(point.vel);

    float av = 0.5 * (prev.pos.y + next.pos.y);
    //flattens curves   
    //point.pos.y = lerp(point.pos.y, av, 0.75);             
    point.pos.y = lerp(point.pos.y, av, 0.5);
    point.pos.y += 0.5;      

    av = 0.5 * (prev.vel.x + next.vel.x);
    point.vel.x -= 0.02 * thc(2, 0 * o + 0.01 * fr);  
    point.vel.x = lerp(point.vel.x, av, 0.75);
    //point.vel.x = lerp(point.vel.x, av, 0.5);
    //point.vel.x = lerp(point.vel.x, av, 0.33);

    //flattens curves
    //point.vel.mult(0.99);
    //

    // increment distance travelled
    point.dist += point.pos.dist(pointPosition);    

    // smoothly go from high value to low value with height - used for hue + opacity
    float mx = 1 / (float)Math.cosh(point.dist / height);

    // hue + opacity (commented bit: randomises opacity and creates dark patches in places)
    float hue = (mx + 0 * point.pos.x/width + 0 * i);// % 1;
    //float hue = (mx + 0 * point.pos.x/width + 0 * i) % 1;
    float opacity = (1 - mx) * (0.75 + 0.25 * cos(random(0, 2 * PI))) * (0.5 + 0.5 * thc(2, 1 * (point.pos.y - pointPosition.y)));
    //float opacity = (1 - mx); // * (0.75 + 0.25 * cos(random(0, 2 * PI))) * (0.5 + 0.5 * thc(2, 1 * (point.pos.y - pointPosition.y)));
    //println("opacity - " + opacity + " / HUE - " + hue);
    float bright = 1;//hue * 2;
    float sat = 0.8 * (1 - mx);
    //
    //opacity = (1-opacity);
    //hue = (1-hue)+0.5;
    //opacity += 0.33;
    //opacity *=0.5;
    //hue = (hue + 0.35);// * 0.5;
    //hue = (hue + 0.25) * 2;
    //

    // draw dark downwards line below (useful for "shadows" and not having a transparent shape)
    strokeWeight(12);
    stroke(hue, 0.8 * (1 - mx), 0, 40 * opacity);
    line(prev.pos.x, prev.pos.y + (12-4), point.pos.x, point.pos.y + 250);

    // lines between neighbours
    strokeWeight(3);
    //stroke(hue, sat, bright, 5 + 100 * opacity);
    //stroke(hue, sat, bright, 5 + 100 * opacity);
    //stroke(hue, 0.8 * (1 - mx), hue, 5 + 100 * opacity);
    stroke(hue, 0.8 * (1 - mx), 1, 5 + 100 * opacity);
    line(prev.pos.x, prev.pos.y, point.pos.x, point.pos.y);       
  }

  // not very important
  nodes[0].pos.y += 0.5;
  nodes[n-1].pos.y += 0.5;
  nodes[0].vel.x = 0;
  nodes[n-1].vel.x = 0;
}

void doNodesOG() {
  for (int i = 1; i < n - 1; i++) {
    node p = nodes[i];
    node prev = nodes[i-1];
    node next = nodes[i+1];

    // offset + start y value
    float o = i / (float)n * 2 * PI;
    PVector p0 = p.pos.copy();

    // change velocity randomly, lerp towards neighbours' velocities, oscillate side to side and move constantly downwards
    p.vel.y += 0.1 * random(-0.99, 1);     
    p.pos.add(p.vel);

    float av = 0.5 * (prev.pos.y + next.pos.y);   
    p.pos.y = lerp(p.pos.y, av, 0.5) ;               
    p.pos.y += 0.5;      

    av = 0.5 * (prev.vel.x + next.vel.x);
    p.vel.x -= 0.02 * thc(2, 0 * o + 0.01 * fr);  
    p.vel.x = lerp(p.vel.x, av, 0.5);

    //p.vel.mult(0.99);

    // increment distance travelled
    p.dist += p.pos.dist(p0);    

    // smoothly go from high value to low value with height - used for hue + opacity
    float mx = 1 / (float)Math.cosh(p.dist / height);

    // hue + opacity (commented bit: randomises opacity and creates dark patches in places)
    float hue = (mx + 0 * p.pos.x/width + 0 * i) % 1;
    float op = (1 - mx); // * (0.75 + 0.25 * cos(random(0, 2 * PI))) * (0.5 + 0.5 * thc(2, 1 * (p.pos.y - p0.y)));

    // draw dark downwards line below (useful for "shadows" and not having a transparent shape)
    strokeWeight(12);   
    stroke(hue, 0.8 * (1 - mx), 0, 40 * op);
    line(prev.pos.x, prev.pos.y + (12-4), p.pos.x, p.pos.y + 250);

    // lines between neighbours
    strokeWeight(4);
    stroke(hue, 0.8 * (1 - mx), 1, 5 + 100 * op);
    line(prev.pos.x, prev.pos.y, p.pos.x, p.pos.y);       
  }

  // not very important
  nodes[0].pos.y += 0.5;
  nodes[n-1].pos.y += 0.5;
  nodes[0].vel.x = 0;
  nodes[n-1].vel.x = 0;
}

void setup() {
  size(1000, 1000, P3D); //dim
  frameRate(fps);
  smooth(8);
  background(0);
  //setup--------------
  n = 375; 
  fr = 0;
  rand = random(0, 1);
  saved = false;  
  makeNodes();

  colorMode(HSB, 1, 1, 1);
  background(0.5,0.8,0.1);
}

void draw() {
  //draw----------------
  if (0.5 * fr > height && !saved) {
    saveTheFrame();
    println("SAVE");
    saved = true;
  } else {
    fr++; 
    doNodesOG();
    casing();
  }

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
  if (key == 'g' || key == 'G') {
    gen = true;
  } else if (key == 'q' || key == 'Q') {
    exit();
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
