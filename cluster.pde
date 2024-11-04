
class Cluster {
  PVector center;
  float distDev;
  float radiusMed;
  float radiusDev;
  ArrayList<Integer> c;
  ArrayList<Star> stars;
 
  Cluster(float x, float y, float z, float distDev, float radiusMed, float radiusDev, ArrayList<Integer> c, int quantity, int limit) {
    center = new PVector(x, y, z);
    this.distDev = distDev;
    this.radiusMed = radiusMed;
    this.radiusDev = radiusDev;
    this.c = c;
    stars = new ArrayList();

    for (int i = 0; i<quantity; i++) {
      float radius = (randomGaussian() * radiusDev) + radiusMed;
      
      float posX = randomGaussian() * distDev * 10;
      float posY = randomGaussian() * distDev * 10;
      float posZ = randomGaussian() * distDev * 10;
      
      Star s = new Star(posX, posY, posZ,  c.get(int(random(0,limit))), radius);
      stars.add(s);
    }
    
  }

  void display() {
    
    for (Star st : stars) {
      st.display();
    }
  }
  
  
}
