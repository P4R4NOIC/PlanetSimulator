class Explosion {
    PVector pos;
    PVector upDirection;
    ArrayList<Particle> columnParticles;
    ArrayList<Particle> capParticles;
    ArrayList<Shockwave> shockwaves;
    Esfera deadSphere;
    Esfera radSphere;
    Esfera hurtSphere;
    int bombType;
    boolean isAnimating; // State variable to control animation state
    float explosionScale; // Parameter to control the scale of the explosion
    float shockwaveSize; // Parameter to control the size of the shockwave

    Explosion(float x, float y, float z, int columnCount, int capCount, float explosionScale, float shockwaveSize, Esfera deadSphere, Esfera radSphere, Esfera hurtSphere, int bombType) {
        pos = new PVector(x, y, z);
        upDirection = pos.copy().normalize();
        columnParticles = new ArrayList<Particle>();
        capParticles = new ArrayList<Particle>();
        shockwaves = new ArrayList<Shockwave>();
        isAnimating = false; // Initially not animating
        this.explosionScale = explosionScale; // Store the explosion scale
        this.shockwaveSize = shockwaveSize; // Store the shockwave size
        this.deadSphere = deadSphere;
        this.radSphere = radSphere;
        this.hurtSphere = hurtSphere;
        this.bombType = bombType;

        // Initialize particles for the rising column with reduced speed
        for (int i = 0; i < columnCount; i++) {
            float offsetX = random(-5 * explosionScale, 5 * explosionScale); // Scale the offset
            float offsetZ = random(-5 * explosionScale, 5 * explosionScale); // Scale the offset
            PVector startPos = pos.copy().add(new PVector(offsetX, 0, offsetZ)); // Use the scaled offsets for a wider base
            PVector velocity = upDirection.copy().mult(random(0.5, 1)).mult(explosionScale); // Reduced initial velocity for slower movement
            columnParticles.add(new Particle(startPos, velocity, 180, 2 * explosionScale)); // Increased lifespan
        }

        // Initialize particles for the mushroom cap with reduced speed
        for (int i = 0; i < capCount; i++) {
            PVector capPos = pos.copy().add(upDirection.copy().mult(20 * explosionScale)); // Scale position
            PVector randomOutward = PVector.random3D().mult(random(0.1 * explosionScale, 0.3 * explosionScale)); // Adjusted scale for slower spread
            PVector capVelocity = upDirection.copy().mult(0.05).add(randomOutward); // Reduced velocity
            capParticles.add(new Particle(capPos, capVelocity, 160, 2 * explosionScale)); // Increased lifespan
        }

        // Create a shock wave with the specified size
        shockwaves.add(new Shockwave(pos, shockwaveSize)); // Use the shockwave size parameter
    }

    void draw() {
        // Draw and update shock waves first
        for (int i = shockwaves.size() - 1; i >= 0; i--) {
            Shockwave shockwave = shockwaves.get(i);
            shockwave.update();
            shockwave.display();

            if (shockwave.isDead()) {
                shockwaves.remove(i);
                isAnimating = true; // Start animating the explosion after shockwave fades
            }
        }

        // Animate the explosion if the shockwave has finished
        if (isAnimating) {
            // Draw and update column particles
            for (int i = columnParticles.size() - 1; i >= 0; i--) {
                Particle p = columnParticles.get(i);
                p.update();
                p.velocity.mult(0.5); // Slower velocity decay for smoother movement
                p.display();

                if (p.isDead()) {
                    columnParticles.remove(i);
                }
            }

            // Draw cap particles
            for (int i = capParticles.size() - 1; i >= 0; i--) {
                Particle p = capParticles.get(i);
                p.update();
                p.display();

                if (p.isDead()) {
                    capParticles.remove(i);
                }
            }
        }   
    }

    void drawDead(){
       deadSphere.draw();
    }
    void drawRad(){
       radSphere.draw();
    }
    void drawHurt(){
       hurtSphere.draw();
    }
    Esfera getDeadS(){
      return this.deadSphere;
    }
    Esfera getRadS(){
      return this.radSphere;
    }
    
    Esfera getHurtS(){
      return this.hurtSphere;
    }

    boolean isComplete() {
        return columnParticles.isEmpty() && capParticles.isEmpty() && shockwaves.isEmpty();
    }
}
