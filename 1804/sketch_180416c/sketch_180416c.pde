FractalRoot pentagon;
int _maxlevels = 15;
float _strutFactor = 0.05;

void setup() {
	background(255);
	size(1000, 1000);
	smooth();
	pentagon = new FractalRoot();
	pentagon.drawShape();
}

class PointObject {
	float x, y;
	PointObject(float ex, float why) {
		x = ex; y = why;
	}
}

class FractalRoot {
	PointObject[] pointArr = new PointObject[5];
	Branch rootBranch;

	FractalRoot() {
		float centerX = width/2;
		float centerY = width/2;
		int count = 0;
		for(int i = 0; i < 360; i+=72) {
			float x = centerX + (400 * cos(radians(i)));
			float y = centerY + (400 * sin(radians(i)));
			pointArr[count] = new PointObject(x,y);
			count++;
		}
		rootBranch = new Branch(0, 0, pointArr);	
	}

	void drawShape() {
		rootBranch.drawMe();
	}
}

class Branch {
	int level, num;
	PointObject[] outerPoints = {};
	PointObject[] midPoints = {};
	PointObject[] projPoints = {};
	Branch[] myBranches = {};

	Branch(int lev, int n, PointObject[] points) {
		level = lev;
		num = n;
		outerPoints = points;
		midPoints = calculateMidpoints();
		projPoints = calculateStructPoints();
		if((level+1) < _maxlevels) {
			Branch childBranch = new Branch(level+1, 0, projPoints);
			myBranches = (Branch[])append(myBranches, childBranch);
		}
	}

	void drawMe() {
		strokeWeight((_maxlevels - level) / 2);
		for (int i = 0; i < outerPoints.length; i++) {
			int nexti = i+1;
			if(nexti == outerPoints.length) { nexti = 0; }
			line(outerPoints[i].x, outerPoints[i].y, outerPoints[nexti].x, outerPoints[nexti].y);
		}
		// strokeWeight(0.5);
		// fill(255, 150);
		// for(int j = 0; j < midPoints.length; j++) {
		// 	ellipse(midPoints[j].x, midPoints[j].y, 15, 15);
		// 	line(midPoints[j].x, midPoints[j].y, projPoints[j].x, projPoints[j].y);
		// 	ellipse(projPoints[j].x, projPoints[j].y, 15, 15);
		// }

		for(int k = 0; k < myBranches.length; k++) {
			myBranches[k].drawMe();
		}
	}

	PointObject[] calculateMidpoints() {
		PointObject[] mpArray = new PointObject[outerPoints.length];
		for (int i = 0; i < outerPoints.length; i++) {
			int nexti = i+1;
			if(nexti == outerPoints.length) { nexti = 0; }
			PointObject thisMp = calcMidpoint(outerPoints[i], outerPoints[nexti]);
			mpArray[i] = thisMp;
		}
		return mpArray;
	}

	PointObject calcMidpoint(PointObject end1, PointObject end2) {
		float mx, my;
		if(end1.x > end2.x) {
			mx = end2.x + ((end1.x - end2.x)/2);
		} else {
			mx = end1.x + ((end2.x - end1.x)/2);
		}

		if(end1.y > end2.y) {
			my = end2.y + ((end1.y - end2.y)/2);
		} else {
			my = end1.y + ((end2.y - end1.y)/2);
		}

		return new PointObject(mx,my);
	}

	PointObject[] calculateStructPoints() {
		PointObject[] structArray = new PointObject[midPoints.length];
		for (int i = 0; i < midPoints.length; i++) {
			int nexti = i+3;
			if(nexti >= midPoints.length) { nexti -= midPoints.length; }
			PointObject thisSP = calcProjectionPoint(midPoints[i], outerPoints[nexti]);
			structArray[i] = thisSP;
		}
		return structArray;
	}

	PointObject calcProjectionPoint(PointObject mp, PointObject op) {
		float px, py;
		float adj, opp;
		if(op.x > mp.x) {
			opp = op.x - mp.x;
		} else {
			opp = mp.x - op.x;
		}

		if(op.y > mp.y) {
			adj = op.y - mp.y;
		} else {
			adj = mp.y - op.y;
		}

		if(op.x > mp.x) {
			px = mp.x + (opp * _strutFactor);
		} else {
			px = mp.x - (opp * _strutFactor);
		}

		if(op.y > mp.y) {
			py = mp.y + (adj * _strutFactor);
		} else {
			py = mp.y - (adj * _strutFactor);
		}

		return new PointObject(px,py);
	}


}