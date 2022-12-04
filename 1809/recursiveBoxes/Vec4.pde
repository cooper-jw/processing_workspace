package processing.core;

import java.io.Serializable;

import processing.core.PApplet;
import processing.core.PConstants;

public class Vec4 implements Serializable {
	public float x;
	public float y;
	public float z;
	public float w;

	//Empty constructor:
	public Vec4() {
	}

	public Vec4(float x, float y, float z, float w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public Vec4(Vec4 v) {
		this.x = v.x;
		this.y = v.y;
		this.z = v.z;
		this.w = v.w;
	}

	public Vec4 set(float x, float y, float z, float w) {
		this.x = x; 
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}

	public Vec4 set(Vec4 v) {
		this.x = v.x;
		this.y = v.y;
		this.z = v.z;
		this.w = v.w;
		return this;
	}

	public Vec4 copy() {
		return new Vec4(this);
	}

	public float mag() {
		return (float) Math.sqrt(x*x + y*y + z*z + w*w);
	}

	public float magSqr() {
		return (x*x + y*y + z*z + w*w);
	}

	public Vec4 add(Vec4 v) {
		this.x += v.x;
		this.y += v.y;
		this.z += v.z;
		this.w += v.w;
		return this;
	}

	public Vec4 add(float x, float y, float z, float w) {
		this.x += x;
		this.y += y;
		this.z += z;
		this.w += w;
		return this;
	}

	static public Vec4 add(Vec4 v1, Vec4 v2) {
		return add(v1, v2, null);
	}

	static public Vec4 add(Vec4 v1, Vec4 v2, Vec4 target) {
		if (target == null) {
			target = new Vec4(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
		} else {
			target.set(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
		}
		return target;
	}

	public Vec4 sub(Vec4 v) {
		this.x -= v.x;
		this.y -= v.y;
		this.z -= v.z;
		this.w -= v.w;
		return this;
	}

	public Vec4 sub(float x, float y, float z, float w) {
		this.x -= x;
		this.y -= y;
		this.z -= z;
		this.w -= w;
		return this;
	}

	static public Vec4 sub(Vec4 v1, Vec4 v2) {
		return sub(v1, v2, null);
	}

	static public Vec4 sub(Vec4 v1, Vec4 v2, Vec4 target) {
		if (target == null) {
			target = new Vec4(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
		} else {
			target.set(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
		}
		return target;
	}

	public Vec4 mult(float n) {
		x *= n;
		y *= n;
		z *= n;
		w *= n;
		return this;
	}

	static public Vec4 mult(Vec4 v, float n) {
		return mult(v, n, null);
	}

	static public Vec4 mult(Vec4 v, float n, Vec4 target) {
		if (target == null) {
			target = new Vec4(v.x * n, v.y * n, v.z * n, v.w * n);
		} else {
			target.set(v.x * n, v.y * n, v.z * n, v.w * n);
		}
		return target;
	}

	public Vec4 div(float n) {
		x /= n;
		y /= n;
		z /= n;
		w /= n;
		return this;
	}

	static public Vec4 div(Vec4 v, float n) {
		return div(v, n, null);
	}

	static public Vec4 div(Vec4 v, float n, Vec4 target) {
		if (target == null) {
			target = new Vec4(v.x / n, v.y / n, v.z / n, v.w / n);
		} else {
			target.set(v.x / n, v.y / n, v.z / n, v.w / n);
		}
		return target;
	}

	public float dist(Vec4 v) {
		float dx = x - v.x;
		float dy = y - v.y;
		float dz = z - v.z;
		float dw = w - v.w;
		return (float) Math.sqrt(dx*dx + dy*dy + dz*dz + dw*dw);
	}

	static public float dist(Vec4 v1, Vec4 v2) {
		float dx = v1.x - v2.x;
		float dy = v1.y - v2.y;
		float dz = v1.z - v2.z;
		float dw = v1.w - v2.w;
		return (float) Math.sqrt(dx*dx + dy*dy + dz*dz + dw*dw);
	}

	public float dot(Vec4 v) {
		return (float) (this.x*v.x + this.y*v.y + this.z*v.z + this.w+v.w);
	}

	public float dot(float x, float y, float z, float w) {
		return (float) (this.x*x + this.y*y + this.z*z + this.w*w);
	}

	static public float dot(Vec4 v1, Vec4 v2) {
		return (float) (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w);
	}

	public Vec4 cross(Vec4 v) {
		return cross(v, null);
	}

	public Vec4 cross(Vec4 v, Vec4 target) {
		float crossX;
		float crossY;
		float crossZ; //4D cross products
		float crossW;
		if (target == null) {
			target = new Vec4(crossX, crossY, crossZ, crossW);
		} else {
			target.set(crossX, crossY, crossZ, crossW);
		}
		return target;
	}

	static public Vec4 cross(Vec4 v1, Vec4 v2) {
		return cross(v1, v2, null);
	}

	static public Vec4 cross(Vec4 v1, Vec4 v2, Vec4 target) {
		float crossX;
		float crossY;
		float crossZ; //4D cross product
		float crossW;
		if (target == null) {
			target = new Vec4(crossX, crossY, crossZ, crossW);
		} else {
			target.set(crossX, crossY, crossZ, crossW);
		}
		return target;
	}

	public Vec4 normalize() {
		float m = mag();
		if (m != 0 && m != 1) {
			div(m);
		}
		return this;
	}

	public Vec4 normalize(Vec4 target) {
		float m = mag();
		if (target == null) {
			target = new Vec4(this);
		} else {
			target.set(this.x, this.y, this.z, this.w);
		}
		if (m != 0 && m != 1) {
			target.div(m);
		}
		return target;
	}

	public Vec4 lerp(Vec4 v, float amt) {
		this.x = PApplet.lerp(this.x, v.x, amt);
		this.y = PApplet.lerp(this.y, v.y, amt);
		this.z = PApplet.lerp(this.z, v.z, amt);
		this.w = PApplet.lerp(this.w, v.w, amt);
		return this;
	}

	public static Vec4 lerp(Vec4 v1, Vec4 v2, float amt) {
		Vec4 v = v1.copy();
		v.lerp(v2, amt);
		return v;
	}

	//angleBetween
	//angleOf

	//Operators
	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof Vec4)) {
		  return false;
		}
		final Vec4 v = (Vec4) obj;
		return x == v.x && y == v.y && z == v.z && w == v.w;
	}

	//hash code

}