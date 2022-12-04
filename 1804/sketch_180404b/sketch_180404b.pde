
float angleNoise, radiusNoise;
float xNoise, yNoise;
float angle = PI/2;
float radius;
float strokeColor = 253;
int strokeChange = 2;

void setup() {
	size(1000,1000);
	background(254);
	strokeWeight(5);
	smooth();
	frameRate(120);
	noFill();

	angleNoise = random(20);
	radiusNoise = random(20);
	xNoise = random(20);
	yNoise = random(20);


}

void draw() {
	noFill();
	radiusNoise += 0.005;
	radius = (noise(radiusNoise) * 750) + 1;

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
	strokeWeight(1);
	line(x1, y1, x2, y2);
	fill(strokeColor, 60);
	ellipse(x1, y1, 4, 4);
	ellipse(x2, y2, 4, 4);
}

float customNoise(float v) {
	float retValue = pow(sin(v), 3);
	return retValue;
}


//ellipse(x, y, width, height);
