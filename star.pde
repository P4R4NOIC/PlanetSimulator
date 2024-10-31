
class Star{
 PVector pos;
 color c;
 float r;
 
 Star(float x,float y,float z, color c, float r){
  pos = new PVector(x,y,z);
  this.c = c;
  this.r = r;
 }
 
 void display(){
  noStroke();
  fill(c);
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphereDetail(5);
  sphere(r);
  popMatrix();
   
 }
 
 
 
}
