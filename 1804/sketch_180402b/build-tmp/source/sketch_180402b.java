/* autogenerated by Processing revision 1289 on 2022-11-29 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class sketch_180402b extends PApplet {




int radius=400;
public void setup() {
	/* size commented out by preprocessor */;
	background(255);
	stroke(255);
	/* smooth commented out by preprocessor */;

}

public void draw() {
	background(0);
	translate(width * 0.5f,height * 0.5f,1);
	rotateY(frameCount*0.03f);
	rotateX(frameCount*0.04f);

	float s= 0;
	float t= 0;
	float lastx = 0;
	float lastyvar = 0;
	float lastxvar = 0;
	float lastzvar = 0;
	float lasty = 0;
	float lastz = 0;
	float xin = 15;
	float yin = 10;
	float zin = 20;
	//float yNoise = random(10);
	while (t<180) {

		s+=40;
		t +=0.5f;
		float yNoise = random(yin);
		float xNoise = random(xin);
		float zNoise = random(zin);
		float radianS=radians(s);
		float radianT=radians(t);


		float thisx= 0 +(radius*cos(radianS)*sin(radianT));
		float thisy= 0 +(radius*sin(radianS)*sin(radianT));
		float thisz= 0 +(radius*cos(radianT));
		float yVar = 5 + (noise(yNoise) * 10);
		float xVar = 5 + (noise(xNoise) * 10);
		float zVar = 5 + (noise(zNoise) * 10);
		if(lastx != 0) {
			line(thisx + xVar,thisy + yVar,thisz + zVar,lastx + lastxvar,lasty + lastyvar,lastz + lastzvar);
		}
		else {
			rotateX(1.5708f);
		}
		lastx=thisx;
		lasty=thisy;
		lastyvar = yVar;
		lastxvar = xVar;
		lastzvar = zVar;
		yin += 0.1f;
		xin += 0.2f;
		zin += 0.05f;
		lastz=thisz;
	}

}


//ellipse(x, y, width, height);


  public void settings() { size(2000, 1000, OPENGL);
smooth(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180402b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
