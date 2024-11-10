class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  float size;

  Particle(PVector position, PVector velocity, float lifespan, float size) {
    this.position = position;
    this.velocity = velocity;
    this.lifespan = lifespan;
    this.size = size;
  }

  void update() {
    position.add(velocity);
    velocity.mult(0.98);  // Slow down slightly over time
    lifespan -= 1;      // Decrease lifespan for fading effect
  }

  void display() {
    noStroke();

    // Set color based on lifespan to create a greyish smoke effect with less transparency
    if (lifespan > 200) {
      fill(220, 220, 220, 200);  // Light grey for the hottest part with less transparency
    } else if (lifespan > 100) {
      fill(170, 170, 170, 180);  // Medium grey as it cools with less transparency
    } else {
      fill(100, 100, 100, 150);   // Dark grey for dissipating smoke with less transparency
    }

    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(size);  // Size of each particle based on its type
    popMatrix();
  }

  boolean isDead() {
    return lifespan <= 0;
  }
}
