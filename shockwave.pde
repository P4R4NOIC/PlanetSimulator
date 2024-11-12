class Shockwave {
  PVector position; // The position of the shockwave
  float radius;     // Current radius of the shockwave
  float maxRadius;  // Maximum radius the shockwave will reach
  float lifespan;   // Lifespan of the shockwave

  Shockwave(PVector position, float maxRadius) {
    this.position = position;
    this.radius = 0; // Start with radius 0
    this.maxRadius = maxRadius;
    this.lifespan = 255; // Full opacity at the start
  }

  void update() {
    radius += 1; // Increase the radius over time
    lifespan -= 1; // Decrease lifespan for fading effect
  }

  void display() {
    noFill();
    fill(255, 255, 255, lifespan * 0.5); // White with alpha for fading
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphereDetail(10);
    sphere(radius); // Draw the shockwave as a sphere
    popMatrix();
  }

  boolean isDead() {
    return lifespan <= 0 || radius >= maxRadius;
  }
}
