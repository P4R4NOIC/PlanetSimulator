import java.util.ArrayList;
import java.util.Iterator;

class System {
  PVector pos;
  ArrayList<Particle> particles;
  Queue<PVector> cola; 
  color c;

  System(float x, float y, float z, color c) {
    pos = new PVector(x, y, z);
    particles = new ArrayList();
    this.c = c;
  
    
  }
  void display() {
    for (Particle a : particles) {
      a.display();
    }
  }
  void update(float x, float y, float z) {
   for(int i = 0; i<300; i++){
     addAgent(x,y,z);
   }
    
  }
  
  void addExplosion(){
    
   Iterator<Particle> it = particles.iterator();
   
    while (it.hasNext()) {
    
      Particle a = it.next();
      if (a.isDead()) {
        it.remove();
      } else {
       
        a.update();
        a.display();
       
      } 
      
    }
     
  }
  
  void addGravity(PVector g){
   for(Particle p: particles){
    p.applyGravity(g); 
   }
  }
  
  void applyDrag(float d){
   for(Particle p: particles){
    p.applyDrag(d); 
   }
  }

  void addAgent(float x, float y, float z) {
    Particle a = new Particle(x, y, z,c);
    PVector f = PVector.random3D();
    f.setMag(random(1500));
    a.applyForce(f);
    particles.add(a);
  }
}
