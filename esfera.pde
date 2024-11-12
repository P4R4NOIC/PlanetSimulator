class Esfera {
  PVector pos;
  float diameter;
  color c;
  int detail;
  PImage texture; 
  PShape globe;
  int opacity;
  ArrayList<peopleComul> populationClusters;
  float scaleOffset;

  ArrayList<PVector> americaPos;
  ArrayList<PVector> asiaPos;
  ArrayList<PVector> oceniaPos;
  ArrayList<PVector> euPos;
  ArrayList<PVector> africaPos;
  long deadPeoplePerBomb;
  long hurtPeoplePerbomb;
  long irradietedPeoplePerBomb;
  

  Esfera(float x, float y, float z, float d, color c, int detail, PImage texture, int opacity) {
    pos = new PVector(x, y, z);
    diameter = d;
    this.c = c;
    this.detail = detail;
    this.texture = texture;
    this.opacity = opacity;
    populationClusters = new ArrayList<peopleComul>();
    this.globe = createShape(SPHERE, diameter / 2);  
    this.globe.setTexture(texture); 
    this.globe.setStroke(false);
 
    
     
}
  float[] multiplyByConstant(float[] arr, float constant) {
  for (int i = 0; i < arr.length; i++) {
    arr[i] *= constant;
  }
  return arr; 
}
  boolean itTouch(PVector centro1, float diametro1, PVector centro2, float diametro2) {
    float radio1 = diametro1;
    float radio2 = diametro2;

   
    float distancia = PVector.dist(centro1, centro2);

  
    return distancia <= (radio1 + radio2);
  }
  
 void lookForAfectedPeople(Explosion actualExp) {
    deadPeoplePerBomb = 0;
    hurtPeoplePerbomb = 0;
    irradietedPeoplePerBomb = 0;
    
    for (peopleComul peopleGroup : populationClusters) {
        
        float distanceToExplosion = dist(
            peopleGroup.pos.x, peopleGroup.pos.y, peopleGroup.pos.z,
            actualExp.pos.x, actualExp.pos.y, actualExp.pos.z
        );

       
        if (distanceToExplosion <= actualExp.getDeadS().diameter ) {
            peopleGroup.redZone();
            deadPeoplePerBomb += peopleGroup.getDeadPoblation();
        }
        
        
        else if (distanceToExplosion <= actualExp.getRadS().diameter ) {
            float distanceEffect = distanceEffect(distanceToExplosion, actualExp.getRadS().diameter );
            
            if (actualExp.bombType == 1) {  // Hiroshima
                peopleGroup.changeHurtPoblation(60 * distanceEffect);
                peopleGroup.changeDeadPoblation(55 * distanceEffect);
                peopleGroup.changeIrraditedPoblation(60 * distanceEffect);
            } else if (actualExp.bombType == 2) {  // Hydrogen
                peopleGroup.changeHurtPoblation(60 * distanceEffect);
                peopleGroup.changeDeadPoblation(45 * distanceEffect);
                peopleGroup.changeIrraditedPoblation(60 * distanceEffect);
            } else if (actualExp.bombType == 3) {  // Tsar
                peopleGroup.changeHurtPoblation(70 * distanceEffect);
                peopleGroup.changeDeadPoblation(60 * distanceEffect);
                peopleGroup.changeIrraditedPoblation(60 * distanceEffect);
            }
            
            hurtPeoplePerbomb += peopleGroup.getHurtPoblation();
            deadPeoplePerBomb += peopleGroup.getDeadPoblation();
            irradietedPeoplePerBomb += peopleGroup.getPeopleRadiated();
        }
        
        // Hurt Zone
        else if (distanceToExplosion <= actualExp.getHurtS().diameter ) {
            float distanceEffect = distanceEffect(distanceToExplosion, actualExp.getHurtS().diameter );

            if (actualExp.bombType == 1) {  
                peopleGroup.changeHurtPoblation(50 * distanceEffect);
                peopleGroup.changeDeadPoblation(40 * distanceEffect);
            } else if (actualExp.bombType == 2) {  
                peopleGroup.changeHurtPoblation(35 * distanceEffect);
                peopleGroup.changeDeadPoblation(25 * distanceEffect);
            } else if (actualExp.bombType == 3) {  
                peopleGroup.changeHurtPoblation(40 * distanceEffect);
                peopleGroup.changeDeadPoblation(30 * distanceEffect);
            }
            
            hurtPeoplePerbomb += peopleGroup.getHurtPoblation();
            deadPeoplePerBomb += peopleGroup.getDeadPoblation();
        }
    }
}
float distanceEffect(float distance, float maxRadius) {
    return 1 - (distance / maxRadius);  
}
  long getDeadPeoplePerBomb(){
   return this.deadPeoplePerBomb;
  }
  long getHurtPeoplePerBomb(){
   return this.hurtPeoplePerbomb;
  }
  long getIrraditedPeoplePerBomb(){
   return this.irradietedPeoplePerBomb;
  }

  void draw() {
    noStroke();

    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    sphereDetail(detail);

    if (texture != null) {
      
      fill(255);
      globe = createShape(SPHERE, diameter);
      globe.setTexture(texture);

      shape(globe);
    } else {
      colorMode(HSB);
      fill(c, opacity);
      sphere(diameter);
    }

    
    drawPopulationClusters();

    popMatrix();
  }

  void drawPopulationClusters() {
    for (peopleComul cluster : populationClusters) {
      if(!cluster.isDead()){
        cluster.draw();
      }
    }
  }
  
  long getTotalDeadPeople() {
    long tdPeople =0;
    for (peopleComul cluster : populationClusters) {
      tdPeople += cluster.getDeadPoblation();
    }
    return tdPeople;
  }
  
  long getTotalAlivePeople() {
    long AlivePeople =0;
    for (peopleComul cluster : populationClusters) {
      if(!cluster.isDead()){
        AlivePeople += cluster.getPoblationN();
      }

    }
    return AlivePeople;
  }
  long getTotalHurtPoblation() {
    long hurtPeople =0;
    for (peopleComul cluster : populationClusters) {
      if(!cluster.isDead()){
        hurtPeople += cluster.getHurtPoblation();
      }

    }
    return hurtPeople;
  }
  long getTotalRadiatedPoblation() {
    long IrradiatedPeople =0;
    for (peopleComul cluster : populationClusters) {
      if(!cluster.isDead()){
        IrradiatedPeople += cluster.getPeopleRadiated();
      }

    }
    return IrradiatedPeople;
  }
  
  long countLines(String fileName){
      long contadorLineas = 0;
      BufferedReader reader = createReader(fileName);
      try {
        // Leer el archivo línea por línea
        while (reader.readLine() != null) {
          contadorLineas++;
        }
        
        // Cerrar el archivo después de leer
        reader.close();
      }catch (IOException e) {
        println("Error al leer el archivo: " + e.getMessage());
      }
      
      // Mostrar el número total de líneas
      return contadorLineas;
    
  }


  void generatePopulationClusters() {

    long  AsiaTotal = 4785060131L;
    long  AfricaTotal = 1494993923;
    long  AmericaTotal = 1051020865;
    long EUTotal = 741651866;
    long  OceaniaTotal = 46109212;
    
    long AmericaNodes =countLines("AmericaPVector.txt");
    long EUNodes = countLines("EUPVector.txt");
    long AfricaNodes=countLines("AfricaPVector.txt");
    long AsiaNodes=countLines("AsiaPVector.txt");
    long OceaniaNodes=countLines("OceaniaPVector.txt");
    
    float maxRadius =3;

    randomSeed(123);
    
    String files[] = {"AsiaPVector.txt","OceaniaPVector.txt","AmericaPVector.txt","EUPVector.txt","AfricaPVector.txt"};
    
    for(int i = 0;i<5;i++){
       BufferedReader reader;
       long remainingPopulation=0;
       long generalNodes=0;
       long totalPopulation=0;
       float scaleFactor=0;
       String linea="no";
       color colorNode= color(0,0,0);
       if(i==0){
         remainingPopulation = AsiaTotal;
         generalNodes=AsiaNodes;
         totalPopulation = AsiaTotal;
         colorNode =  color(#f4d03f);
       }else if(i==1){
         remainingPopulation = OceaniaTotal;
         generalNodes=OceaniaNodes;
         totalPopulation = OceaniaTotal;
         colorNode =  color(#82e0aa);
       }else if(i==2){
         remainingPopulation = AmericaTotal;
         generalNodes=AmericaNodes;
         totalPopulation = AmericaTotal;
         colorNode =  color(#ff0000);
       }else if(i==3){
         remainingPopulation = EUTotal;
         generalNodes=EUNodes;
         totalPopulation = EUTotal;
         colorNode =  color(#1e88e5);
       }else if(i==4){
         remainingPopulation = AfricaTotal;
         generalNodes=AfricaNodes;
         totalPopulation = AfricaTotal;
         colorNode =  color(#5e35b1);
       }
       scaleFactor=maxRadius / sqrt(totalPopulation / generalNodes);
       reader = createReader(files[i]);
       try {
         int j =0;
         while ((linea = reader.readLine()) != null) {
            String[] valores = linea.split(",");
            
            // Convertir los valores a flotantes
            float valor1 = float(valores[0]);
            float valor2 = float(valores[1]);
            float valor3 = float(valores[2]);
            
            long maxPopulationPerNode = remainingPopulation / (generalNodes - j);
            j++;
            long populationPerNode = (long) random(1, maxPopulationPerNode + 1);
            
            float radius = min(maxRadius, sqrt(populationPerNode) * scaleFactor);
            
            
            
            
            
            peopleComul cluster = new peopleComul(
              valor1, valor2, valor3, 
              radius, colorNode, 6, 255, populationPerNode
            );
            populationClusters.add(cluster);
            remainingPopulation -= populationPerNode;
        }
        reader.close();
      }catch (IOException e) {
        println("Error al leer el archivo: " + e.getMessage());
      }
    }
  }



 
  boolean isLand(color pixelColor) {
  
    int redValue = int(red(pixelColor));
    int greenValue = int(green(pixelColor));
    int blueValue = int(blue(pixelColor));


    boolean isWhite = (redValue == 255 && greenValue == 255 && blueValue ==255);

    return isWhite;
  }



  void update(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
}
