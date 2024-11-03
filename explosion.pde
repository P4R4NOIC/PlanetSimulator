class Explosion {
    PVector pos;
    PVector upDirection;
    ArrayList<Particle> columnParticles;
    ArrayList<Particle> capParticles;
    ArrayList<Shockwave> shockwaves;
    boolean isAnimating; // State variable to control animation state

    Explosion(float x, float y, float z, int columnCount, int capCount, int shockwaveSize) {
        pos = new PVector(x, y, z);
        upDirection = pos.copy().normalize();
        columnParticles = new ArrayList<Particle>();
        capParticles = new ArrayList<Particle>();
        shockwaves = new ArrayList<Shockwave>();
        isAnimating = false; // Initially not animating

        // Initialize particles for the rising column
        for (int i = 0; i < columnCount; i++) {
            PVector startPos = pos.copy().add(PVector.random3D().mult(random(2)));
            PVector velocity = upDirection.copy().mult(random(1, 2));
            columnParticles.add(new Particle(startPos, velocity, 120, 2));
        }

        // Initialize particles for the mushroom cap
        for (int i = 0; i < capCount; i++) {
            PVector capPos = pos.copy().add(upDirection.copy().mult(20));
            PVector randomOutward = PVector.random3D().mult(random(0.5, 1.0));
            PVector capVelocity = upDirection.copy().mult(0.1).add(randomOutward);
            capParticles.add(new Particle(capPos, capVelocity, 100, 2));
        }

        // Create a shock wave
        shockwaves.add(new Shockwave(pos, shockwaveSize));
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
    }

    boolean isComplete() {
        return columnParticles.isEmpty() && capParticles.isEmpty() && shockwaves.isEmpty();
    }
}
