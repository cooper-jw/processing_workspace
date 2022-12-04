import nervoussystem.obj.*;

void thing(float sz) 
{
  if (sz > 5) 
  {
    for (int i=0; i<2; i++) 
    {
      pushMatrix();
      translate(random(-sz/2, sz/2), -random(sz * 0.8, sz * 1.2), random(-sz/2, sz/2));
      rotateX(random(-0.9, 0.9));
      rotateZ(random(-0.9, 0.9));
      box(sz);
      thing(sz * 0.8);
      popMatrix();
    }
  }
}

void setup() 
{
  size(1000, 1000, P3D);
  beginRecord("nervoussystem.obj.OBJExport", sketchPath() + "/recursiveBoxes.obj");
  thing(250);
  box(50);
  endRecord();
}