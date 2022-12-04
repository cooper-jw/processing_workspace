import processing.opengl.*;


int radius=400;
void setup() {
	size(2000,1000,OPENGL);
	background(255);
	stroke(255);
	smooth();

}

void draw() {
	background(0);
	translate(width * 0.5,height * 0.5,1);
	rotateY(frameCount*0.03);
	rotateX(frameCount*0.04);

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
		t +=0.5;
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
			rotateX(1.5708);
		}
		lastx=thisx;
		lasty=thisy;
		lastyvar = yVar;
		lastxvar = xVar;
		lastzvar = zVar;
		yin += 0.1;
		xin += 0.2;
		zin += 0.05;
		lastz=thisz;
	}

}


//ellipse(x, y, width, height);
