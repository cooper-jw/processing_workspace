import processing.svg.*;
PGraphics pgDrawing;
PShape bg;

void setup() {
	int xHeight = 1000;
	int yHeight = 1000;
	String file = "3.svg";
	size(1000,1000);

	pgDrawing = createGraphics(1000, 1000, SVG, file);
	pgDrawing.beginDraw();
	pgDrawing.background(255);
	pgDrawing.stroke(0);
	
	pgDrawing.smooth();
	drawShapes();
	pgDrawing.endDraw();
	pgDrawing.dispose();
	bg = loadShape(file);
}

void draw() {
	shape(bg, 0, 0);
	noLoop();
}

void drawShapes() {
	int baseY = 20;
	int yIncrement = 20;
	int yStop = 20;

	int xStep = 10;

	while(baseY <= 1000 - yStop) {
	  
	  //gray line
	  pgDrawing.strokeWeight(5);
	  pgDrawing.stroke(0, 20);
	  //start xy - end xy
	  pgDrawing.line(0, baseY, 1000, baseY);
	  
	  float lastX = -999;
	  float lastY = -999;
	  float yNoise = random(10);
	  
	  float y;
	  pgDrawing.strokeWeight(3);
	  pgDrawing.stroke(20, 50, 70);

	  for (int x = 0; x <= 1000; x+=xStep) {
	  	y = (baseY - 40) + (noise(yNoise) * 40);
	  	if(lastX > -999) {
	  		pgDrawing.line(x, y, lastX, lastY);
	  	}
	  	lastX = x;
	  	lastY = y;
	  	yNoise += 0.1;
	  }

	  baseY += yIncrement;
	}
}


