/* autogenerated by Processing revision 1289 on 2022-11-29 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.svg.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class sketch_180401b extends PApplet {


PGraphics pgDrawing;
PShape bg;

public void setup() {
	int xHeight = 1000;
	int yHeight = 1000;
	String file = "3.svg";
	/* size commented out by preprocessor */;

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

public void draw() {
	shape(bg, 0, 0);
	noLoop();
}

public void drawShapes() {
	int baseY = 20;
	int yIncrement = 20;
	int yStop = 20;

	int xStep = 1;
	int variance = 30;

	while(baseY <= 1000 - yStop) {
	  
	  //gray line
	  pgDrawing.strokeWeight(3);
	  pgDrawing.stroke(0, 20);
	  //start xy - end xy
	  pgDrawing.line(0, baseY, 1000, baseY);
	  
	  float lastX = -999;
	  float lastY = -999;
	  float y = baseY;
	  float angle = random(0, 60);
	  pgDrawing.strokeWeight(3);
	  pgDrawing.stroke(20, 50, 70);

	  for (int x = 0; x <= 1000; x+=xStep) {
	  	float rad = radians(angle);
	  	y = baseY + (sin(rad) * variance);
	  	if(lastX > -999) {
	  		pgDrawing.line(x, y, lastX, lastY);
	  	}
	  	lastX = x;
	  	lastY = y;
	  	angle++;
	  }

	  baseY += yIncrement;
	}
}


  public void settings() { size(1000, 1000); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180401b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
