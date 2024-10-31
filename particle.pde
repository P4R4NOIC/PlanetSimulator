import java.util.LinkedList;
import java.util.Queue;
import processing.core.PVector;

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  color c;
  float maxSpeed;
  float mass;
  float massLoss;
  Queue<PVector> cola;
  int largoCola;
  int save = 2;
  int counter = 0;
 
  public Particle(float x, float y, float z, color c) {
    pos = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    cola = new LinkedList<>();
    largoCola = 10; 
    colorMode(HSB);
    this.c = c;
    colorMode(RGB);
    maxSpeed = 15;
    mass = 700;
    massLoss = 2.5;
  }

  private float r(int val) {
    return pow(val * mass / 4 / PI, 1.0 / 3.0);
  }

  boolean isDead() {
    return mass < 0.1;
  }

  void display() {
    int radius = 0;

    fill(c);
    noStroke();
    
    for (PVector p : cola) {
      pushMatrix();
      PVector offsetParticle = p.add(acc);
      translate(offsetParticle.x, offsetParticle.y, offsetParticle.z);
      sphereDetail(3);
      sphere(r(radius));
      popMatrix();
      radius++;
    }
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphereDetail(2);
    sphere(r(10));
    popMatrix();
  }

  void update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
    counter++;
    
    if (counter >= save) {
      cola.add(pos.copy());
      if (cola.size() > largoCola) {
        cola.poll(); 
      }
      counter = 0;
    }

    mass -= massLoss;
  }

  void applyForce(PVector f) {
    PVector force = PVector.div(f, mass);
    acc.add(force);
  }

  void applyGravity(PVector g) {
    acc.add(g);
  }

  void applyFriction(float m) {
    PVector fric = vel.copy();
    fric.normalize();
    fric.mult(-m);
    applyForce(fric);
  }

  void applyDrag(float d) {
    PVector drag = vel.copy();
    drag.normalize();
    drag.mult(pow(vel.mag(), 2));
    drag.mult(-d);
    applyForce(drag);
  }
}
