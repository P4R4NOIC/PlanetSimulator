class Explosion {
    PVector pos;
    PVector upDirection;
    ArrayList<Particle> columnParticles;
    ArrayList<Particle> capParticles;
    ArrayList<Shockwave> shockwaves;
    Esfera deadSphere;
    Esfera radSphere;
    Esfera hurtSphere;
    boolean isAnimating; // State variable to control animation state
    float explosionScale; // Parameter to control the scale of the explosion
    float shockwaveSize; // Parameter to control the size of the shockwave

    Explosion(float x, float y, float z, int columnCount, int capCount, float explosionScale, float shockwaveSize, Esfera deadSphere, Esfera radSphere, Esfera hurtSphere) {
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

        // Initialize particles for the rising column
        for (int i = 0; i < columnCount; i++) {
            float offsetX = random(-5 * explosionScale, 5 * explosionScale); // Scale the offset
            float offsetZ = random(-5 * explosionScale, 5 * explosionScale); // Scale the offset
            PVector startPos = pos.copy().add(new PVector(offsetX, 0, offsetZ)); // Use the scaled offsets for a wider base
            PVector velocity = upDirection.copy().mult(random(1, 2)).mult(explosionScale); // Scale velocity
            columnParticles.add(new Particle(startPos, velocity, 120, 2 * explosionScale)); // Scale size
        }

        // Initialize particles for the mushroom cap
        for (int i = 0; i < capCount; i++) {
            // Position the cap particles directly above the explosion center with less outward spread
            PVector capPos = pos.copy().add(upDirection.copy().mult(20 * explosionScale)); // Scale position
            // Reduce the spread by limiting the range of random outward movement
            PVector randomOutward = PVector.random3D().mult(random(0.2 * explosionScale, 0.5 * explosionScale)); // Adjusted scale
            PVector capVelocity = upDirection.copy().mult(0.1).add(randomOutward);
            capParticles.add(new Particle(capPos, capVelocity, 100, 2 * explosionScale)); // Scale size
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
                p.velocity.mult(0.96);
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
        deadSphere.draw();
        radSphere.draw();
        hurtSphere.draw();
    }

    boolean isComplete() {
        return columnParticles.isEmpty() && capParticles.isEmpty() && shockwaves.isEmpty();
    }
}
