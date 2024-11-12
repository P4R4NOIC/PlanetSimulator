/*TODO Gabo 
Pensar metodo para calcular el radio de las esferas de explosion,ademas pensar la logica
para pensar en cual rango de explosion se encuentra el comul.

Logrando lo de arriba se puede calcular los danos hechos por la bomba, sea de radiacion y demas (hablar con joseph para que haga un objeto bomba con los radios)

Calculando lo de arriba modificar el metodo para el cumulo de la cantidad de personas, la gente muerta,etc.

Modificar opacidad dependinendo de los muerto, ya se hizo un prototipo 

Metodo is kill para roberto para saber si una poblacion ya murio y borrarla del arreglo

randomizar con una semilla (gacha roberto) la el tamano y la cantidad de poblacion por continenente


*/
 class peopleComul {
    PVector pos;
    float diameter;
    color c;
    int detail;
    PShape globe;
    float opacity;
    long poblationN;
    long totalPoblationN;
    long deadPoblation;
    long hurtPoblation;
    long peopleRadiated;

    peopleComul(float x, float y, float z, float d, color c, int detail,float opacity,long poblationN) {
        pos = new PVector(x, y, z);
        diameter = d;
        this.c = c;
        this.detail = detail;
        this.opacity = opacity;
        this.poblationN=poblationN;
        this.totalPoblationN=poblationN;
        this.peopleRadiated=0;
        this.deadPoblation=0;
        this.hurtPoblation=0;
        
    }
    peopleComul(PVector pos,float d, color c, int detail,float opacity,long poblationN) {
        this.pos = pos;
        diameter = d;
        this.c = c;
        this.detail = detail;
        this.opacity = opacity;
        this.poblationN=poblationN;
        this.totalPoblationN=poblationN;
        this.peopleRadiated=0;
        this.deadPoblation=0;
        this.hurtPoblation=0;
        
    }

    void draw() {
        noStroke();
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        sphereDetail(detail);
        colorMode(HSB);
        fill(c, opacity);
        sphere(diameter);
        popMatrix();
    }
    void changeOpasity(){
      println(poblationN);
      println(totalPoblationN);
      float calc = (float)poblationN/totalPoblationN;
      this.opacity = 255*calc;
      
    }
    void update(float x, float y) {
        pos.x = x;
        pos.y = y;
    }
    void changeHurtPoblation(float percent){
      long p = poblationN;
      for(int i =0;i<p;i++){
         float liveProb = random(0,100);
         if(liveProb<percent){
           hurtPoblation +=1;
           if(hurtPoblation>=poblationN*0.7){
              hurtPoblation-=1;
              poblationN-=1;
              deadPoblation +=1;
              
           }  
         }
      }
      changeOpasity();
    }
    
    void changeDeadPoblation(float percent){
      long p = poblationN;
      for(int i =0;i<p;i++){
         float liveProb = random(0,100);
         if(liveProb<percent){
           poblationN-=1;
           deadPoblation +=1;
           
           
         }
      }
      changeOpasity();
    }
    
    void changeIrraditedPoblation(float percent){
      long p = poblationN;
      for(int i =0;i<p;i++){
         float liveProb = random(0,100);
         if(liveProb<percent){
           peopleRadiated +=1;
           if(peopleRadiated>=poblationN*0.7){
              peopleRadiated-=1;
              poblationN-=1;
              deadPoblation +=1;
              
           }  
         }
      }
      changeOpasity();
    }
    
    void redZone(){
      deadPoblation+=poblationN;
      poblationN =0;
    }
    float distanceEffect(float distance, float maxRadius) {
        return 1 - (distance / maxRadius);  // Returns a fraction between 1 (close) and 0 (far)
    }
    boolean isDead(){
      
      if(opacity<10 || poblationN*0.10>=poblationN){
         return true; 
      }
      return false;
    }
    
    long getPoblationN(){
        return this.poblationN;
    }
    
    long getDeadPoblation(){
        return this.deadPoblation;
    }
    long getHurtPoblation(){
        return this.hurtPoblation;
    }
    long getPeopleRadiated(){
        return this.peopleRadiated;
    }
 }
