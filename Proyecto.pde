
import peasy.*;
import controlP5.*;


ControlP5 controlP5;
PImage img;
PeasyCam cam;
int numSpheres = 3000;
float radius = 1200;
PVector[] smallSpheres;


float whiteSphereSpeed = 0.005;
int speedText = 1;

float theta = 0;
float phi = HALF_PI;

int flagNW=0;
int bombCount=0;
ArrayList<Explosion> nuclearExplosions;
ArrayList<Explosion> threeBombs;


float explosionScale;
float shockwaveSize;
float deadCircleRadius;
float radCircleRadius;
float hurtCircleRadius;
int bombType;

ArrayList<Explosion> explosions;
PVector launch;
PVector gravity;
System principal;
System secondary;
Boolean updated = false;
color c1;
color c2;
int rocketCounter = 0;
Cluster C1;
Cluster C2;
Esfera c;
boolean isRunning = true;
PrintWriter output;

import processing.opengl.*;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

Textlabel totalPeople, totalDeadPeople, totalRadiatedPeople, totalHurtPeople, deadPeoplePerBomb, radPeoplePerBomb, hurtPeoplePerBomb, infoLabel, speedLabel;

CColor colorPrincipal;
CColor colorHiroshima;
CColor colorHidrogeno;
CColor colorTSAR;

Button botonHiroshima, botonHidrogeno, botonTSAR, botonSimHiro, incSpd, decSpd,botonSimGuerra;
Group infoGroup;

ArrayList<Esfera> esferasEscritura;

FileHandler fileHandlerA = new FileHandler("AasiaVector.txt");
void bombInfo() {
  controlP5 = new ControlP5(this);

  // Labels principales
  totalPeople = controlP5.addTextlabel("totalPeopleLabel")
    .setText("Total de personas vivas: 0")
    .setPosition(10, 10)
    .setColorValue(#444444)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  totalDeadPeople = controlP5.addTextlabel("totalDeadPeople")
    .setText("Total de personas muertas: 0")
    .setPosition(10, 50)
    .setColorValue(#FF0313)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  totalRadiatedPeople = controlP5.addTextlabel("totalRadiatedPeopleLabel")
    .setText("Total de personas irradiadas: 0")
    .setPosition(10, 90)
    .setColorValue(#39FF14)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  totalHurtPeople = controlP5.addTextlabel("totalHurtPeopleLabel")
    .setText("Total de personas heridas: 0")
    .setPosition(10, 130)
    .setColorValue(#FFD700)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  // Labels secundarios
  deadPeoplePerBomb = controlP5.addTextlabel("deadPeoplePerBombLabel")
    .setText("Personas muertas por la bomba individual: 0")
    .setPosition(10, 180)
    .setColorValue(#B22222)
    .setFont(createFont("Georgia", 27))
    .setSize(300, 30);

  radPeoplePerBomb = controlP5.addTextlabel("radPeoplePerBombLabel")
    .setText("Personas irradiadas por la bomba individual: 0")
    .setPosition(10, 220)
    .setColorValue(#3CB371)
    .setFont(createFont("Georgia", 27))
    .setSize(300, 30);

  hurtPeoplePerBomb = controlP5.addTextlabel("hurtPeoplePerBombLabel")
    .setText("Personas heridas por la bomba individual: 0")
    .setPosition(10, 260)
    .setColorValue(#DAA520)
    .setFont(createFont("Georgia", 27))
    .setSize(300, 30);


  controlP5.addTextlabel("selectBomb")
    .setText("Seleccionar bomba:")
    .setPosition(50, height-150)
    .setColorValue(#FFFFFF)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  // Color principal para todos los botones (gris oscuro)
  colorPrincipal = new CColor().setBackground(#555555);

  // Colores específicos para cada botón
  colorHiroshima = new CColor().setBackground(#C04C36); // Rojo ladrillo
  colorHidrogeno = new CColor().setBackground(#1E90FF); // Azul eléctrico
  colorTSAR = new CColor().setBackground(#8B0000);      // Rojo oscuro


  // Botón Hiroshima
  botonHiroshima = controlP5.addButton("Hiroshima")
    .setValue(0)
    .setPosition(100, height - 100)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  // Botón Hidrogeno
  botonHidrogeno = controlP5.addButton("Hidrogeno")
    .setValue(0)
    .setPosition(200, height - 100)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  // Botón TSAR
  botonTSAR = controlP5.addButton("TSAR")
    .setValue(0)
    .setPosition(300, height - 100)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  // Botón Simulacion Hiroshima
  botonSimHiro = controlP5.addButton("SimularHiroshima")
    .setValue(0)
    .setPosition(400, height - 100)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  // Botón Simulacion GuerraMundial
  botonSimGuerra = controlP5.addButton("SimGuerraMundial")
    .setValue(0)
    .setPosition(500, height - 100)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  // Información
  infoGroup = controlP5.addGroup("Mostrar informacion sobre la bomba:")
    .setPosition(10, 350)
    .setWidth(400)
    .setHeight(20)
    .close()
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(220)
    .setFont(createFont("Georgia", 15));

  infoLabel = controlP5.addTextlabel("infoLabel")
    .setPosition(10, 10)
    .setWidth(430)
    .setFont(createFont("Georgia", 15))
    .setGroup(infoGroup);

  incSpd = controlP5.addButton("incSpd")
    .setValue(0)
    .setPosition(300, height - 200)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  speedLabel = controlP5.addTextlabel("speedLabel")
    .setText("Vel: 1")
    .setPosition(200, height - 200)
    .setColorValue(#FFFFFF)
    .setSize(300, 30)
    .setFont(createFont("Georgia", 30));

  decSpd = controlP5.addButton("decSpd")
    .setValue(0)
    .setPosition(100, height - 200)
    .setSize(80, 50)
    .setColor(colorPrincipal);

  controlP5.setAutoDraw(false);
}

void setup() {
  //size(800, 600, OPENGL);
  fullScreen(OPENGL);
  g3 = (PGraphics3D)g;
  background(0);
  smallSpheres = new PVector[numSpheres];
  output = createWriter("PVTEMP.txt");
  esferasEscritura = new ArrayList<Esfera>();
  String name = "tierra2.jpg";
  img = loadImage(name);

  cam = new PeasyCam(this, 2000);


  cam.setMinimumDistance(1500);
  cam.setMaximumDistance(2500);
  randomSeed(1234);



  launch = new PVector(0, 0, 0);

  ArrayList<Integer> colors = new ArrayList();
  colors.add(#FFFFFF);
  colors.add(#B7C7FF);
  colors.add(#90DEFA);
  colors.add(#4B73FF);
  colors.add(#F0C757);
  colors.add(#FF6B4D);
  colors.add(#FF4E1C);
  colors.add(#F72525);
  c = new Esfera(0, 0, 0, radius, #0C18EA, 30, img, 255);
  C1 = new Cluster(0, 0, 0, 1000, 1.5, 1, colors, 5000, 6);


  c.generatePopulationClusters();
  bombInfo();
  Hiroshima();
  
  explosions = new ArrayList<Explosion>();
  threeBombs = new ArrayList<Explosion>();
  theta = 0;
  phi = HALF_PI;
  flagNW=0;
}

void draw() {
  background(0);
  // lights();

  for (Esfera es : esferasEscritura) {
    es.draw();
  }
  C1.display();
  c.draw();
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion exp = explosions.get(i);
    exp.draw(); // Call the draw method of Explosion
    /*if (exp.isComplete()) {
     explosions.remove(i); // Remove completed explosions
     }*/
  }
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion exp = explosions.get(i);
    if (exp.isComplete()) {
      exp.drawDead();
      exp.drawRad();
      exp.drawHurt();
    }
  }
  if(flagNW==1){
    if(threeBombs.size()==0 && nuclearExplosions.size()==0){
      flagNW=0;
    }else{
      if(nuclearExplosions.size()>0){
        while(bombCount<10){
          int indexRand = (int)random(0, nuclearExplosions.size()-1);
          threeBombs.add(nuclearExplosions.get(indexRand));
          nuclearExplosions.remove(indexRand);
          bombCount++; 
        }
      }
      for (int i = threeBombs.size() - 1; i >= 0; i--) {
        Explosion exp = threeBombs.get(i);
        exp.draw(); // Call the draw method of Explosion
        if (exp.isComplete()) {
           explosions.add(exp);
           threeBombs.remove(i);
           bombCount--;
           c.lookForAfectedPeople(exp);
          long deadPeoplePB = c.getDeadPeoplePerBomb();
          long deadPeople = c.getTotalDeadPeople();
          long hurtPeople =c.getTotalHurtPoblation();
          long radPeople = c.getTotalRadiatedPoblation();
          long radPb =c.getIrraditedPeoplePerBomb();
          long hurtPb = c.getHurtPeoplePerBomb();
          long totalP=c.getTotalAlivePeople();
          updatePeopleCount(totalP, deadPeople, hurtPeople, radPeople, deadPeoplePB, radPb, hurtPb); 
         }
      }
    }
  }




  if (keyPressed) {
    if (key == 'w') {
      theta -= whiteSphereSpeed;
    }
    if (key == 's') {
      theta += whiteSphereSpeed;
    }
    if (key == 'a') {
      phi -= whiteSphereSpeed;
    }
    if (key == 'd') {
      phi += whiteSphereSpeed;
    }
    if (key == 'r') {
      theta = 0;
      phi = HALF_PI;
    }
  }

  theta = (theta + TWO_PI) % TWO_PI;


  phi = (phi + TWO_PI) % TWO_PI;

  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);

  Esfera whiteSphere = new Esfera(x, y, z, deadCircleRadius, #FFFFFF, 10, null, 255);
  whiteSphere.draw();




  gui();
}

void gui() {
  // Deshabilitar la prueba de profundidad para el HUD
  hint(DISABLE_DEPTH_TEST);

  cam.beginHUD();  // Activar HUD para dibujar elementos de interfaz
  controlP5.draw();      // Dibujar los controles
  cam.endHUD();    // Finalizar el HUD

  // Habilitar nuevamente la prueba de profundidad para elementos 3D
  hint(ENABLE_DEPTH_TEST);
}

public void updatePeopleCount(long total, long dead, long hurt, long rad, long deadPB, long radPB, long hurtPB) {
  String newText = "Total de personas vivas: " + total;
  totalPeople.setText(newText);

  newText = "Total de personas muertas: " + dead;
  totalDeadPeople.setText(newText);

  newText = "Total de personas irradiadas: " + rad;
  totalRadiatedPeople.setText(newText);

  newText = "Total de personas heridas: " + hurt;
  totalHurtPeople.setText(newText);

  newText = "Personas muertas por la bomba individual: " + deadPB;
  deadPeoplePerBomb.setText(newText);
  newText = "Personas irradiadas por la bomba individual: " + radPB;
  radPeoplePerBomb.setText(newText);
  newText = "Personas heridas por la bomba individual: " + hurtPB;
  hurtPeoplePerBomb.setText(newText);
}

public void Hiroshima() {
  println("Se ha seleccionado Hiroshima");
  if (botonHiroshima != null) botonHiroshima.setColor(colorHiroshima);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorPrincipal);
  if (botonTSAR != null) botonTSAR.setColor(colorPrincipal);
  explosionScale = 0.25;
  shockwaveSize = 10;
  deadCircleRadius = 2.5;
  radCircleRadius = 4;
  hurtCircleRadius = 7;
  bombType = 1;

  String info = "Bomba de Hiroshima (\"Little Boy\")\n" +
    "Fecha: 6 de agosto de 1945\n" +
    "Explosivo: Uranio-235\n" +
    "Peso del explosivo: 64kg\n" +
    "Peso de la bomba: 4400kg\n"+
    "Potencia: 16 kilotones\n" +
    "Efectos: Destrucción masiva en Hiroshima, \n"+
    "~200,000 muertos en pocos meses. \n" +
    "La radiación causó enfermedades, mutaciones \n"+
    "genéticas y una gran contaminación.\n"+
    "Fue uno de los primeros usos de la bomba atómica en \n"+
    "un conflicto.";
  if (infoLabel != null) infoLabel.setText(info);
}

public void Hidrogeno() {
  println("Se ha seleccionado Hidrogeno");
  if (botonHiroshima != null) botonHiroshima.setColor(colorPrincipal);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorHidrogeno);
  if (botonTSAR != null) botonTSAR.setColor(colorPrincipal);
  explosionScale = 0.5;
  shockwaveSize = 25;
  deadCircleRadius = 4;
  radCircleRadius = 10;
  hurtCircleRadius = 14;
  bombType = 2;

  String info = "Bomba de Hidrógeno (\"Mike\")\n" +
    "Fecha: 1 de noviembre de 1952\n" +
    "Ubicación: Enewetak atoll en las islas Marshall\n" +
    "Tipo: Fusión nuclear (Criogénico líquido deuterio)\n" +
    "Potencia: 10.4 megatones\n" +
    "Efectos: En su primera fracción de segundo, la explosión\n" +
    "creó una bola de fuego de un cuarto del tamaño de \n" +
    "Manhattan. Sólo dos minutos después de la detonación, \n" +
    "la nube alcanzó una altura de 12,2 kilómetros. En su \n" +
    "máximo, la nube se extendió a lo largo de 160 kilómetros\n" +
    "de ancho, a través de la estratosfera y envió una columna \n" +
    "explosiva de 40 kilómetros, por encima del punto de \n" +
    "detonación.";
  if (infoLabel != null) infoLabel.setText(info);
}

public void TSAR() {
  println("Se ha seleccionado TSAR");
  if (botonHiroshima != null) botonHiroshima.setColor(colorPrincipal);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorPrincipal);
  if (botonTSAR != null) botonTSAR.setColor(colorTSAR);
  explosionScale = 1;
  shockwaveSize = 50;
  deadCircleRadius = 10;
  radCircleRadius = 20;
  hurtCircleRadius = 35;
  bombType = 3;

  String info = "Tsar Bomba\n" +
    "Fecha: 30 de octubre de 1961\n" +
    "Tipo: Fusión nuclear, diseño de tres etapas\n" +
    "Potencia: ~50 megatones (~3,000 veces Hiroshima)\n" +
    "Efectos: Onda expansiva que rompió ventanas a 900 km,\n" +
    "nube de hongo de 60 km de altura. La bomba más \n"+
    "poderosa probada.";
  if (infoLabel != null) infoLabel.setText(info);
}

public void SimularHiroshima() {
  Hiroshima();
  theta = 5.489243;
  phi = 0.91484404;
}


BufferedReader reader;
public void SimGuerraMundial() {
   if (nuclearExplosions == null) {
    nuclearExplosions = new ArrayList<Explosion>();
  }
  reader = createReader("nuclearWarCoordenates.txt");
  String linea="no";
  println("AQUI");
  try{
     while ((linea = reader.readLine()) != null) {
            String[] valores = linea.split(",");
            float deadCircleRadiusN = 0;
            float radCircleRadiusN = 0;
            float hurtCircleRadiusN = 0;
            float shockwaveSizeN =0;
            float explosionScaleN = 0;
            int bombTypeN =0;
            int chooseBomb =int(random(100));
            if (chooseBomb < 50) {
                explosionScaleN = 1;
                shockwaveSizeN = 50;
                deadCircleRadiusN = 10;
                radCircleRadiusN = 20;
                hurtCircleRadiusN = 35;
                bombTypeN = 3;
            } else if (chooseBomb < 90) {
                explosionScaleN = 0.5;
                shockwaveSizeN = 25;
                deadCircleRadiusN = 4;
                radCircleRadiusN = 10;
                hurtCircleRadiusN = 14;
                bombTypeN = 2;
            } else {
                explosionScaleN = 0.25;
                shockwaveSizeN = 10;
                deadCircleRadiusN = 2.5;
                radCircleRadiusN = 4;
                hurtCircleRadiusN = 7;
                bombTypeN = 1;
            }
            // Convertir los valores a flotantes
            float valor1 = float(valores[0]);
            float valor2 = float(valores[1]);
            float valor3 = float(valores[2]);
            Esfera a = new Esfera(valor1, valor2, valor3, deadCircleRadiusN, #F70000, 20, null, 200);
            Esfera b = new Esfera(valor1, valor2, valor3, radCircleRadiusN, #EEF231, 20, null, 100);
            Esfera f = new Esfera(valor1, valor2, valor3, hurtCircleRadiusN, #62F525, 20, null, 100);
            
            Explosion explosion = new Explosion(valor1, valor2, valor3, 500, 600, explosionScaleN, shockwaveSizeN, a, b, f, bombTypeN); // Customize parameters
            nuclearExplosions.add(explosion);
            
    }
    reader.close();
    flagNW=1;
    
  }catch (IOException e) {
        println("Error al leer el archivo: " + e.getMessage());
 }
}

public void incSpd() {
  String newText;
  if (speedText<5) {
    whiteSphereSpeed+=0.01;
    speedText++;
  }
  newText = "Vel: " + speedText;
  if (speedLabel != null)speedLabel.setText(newText);
}

public void decSpd() {
  String newText;
  if (speedText>1) {
    whiteSphereSpeed-=0.01;
    speedText--;
  }
  newText = "Vel: " + speedText;
  if (speedLabel != null)speedLabel.setText(newText);
}




Explosion triggerExplosion() {
  // Get the explosion position based on the white sphere position
  bombCount++;
  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);


  Esfera a = new Esfera(x, y, z, deadCircleRadius, #F70000, 20, null, 200);

  Esfera b = new Esfera(x, y, z, radCircleRadius, #EEF231, 20, null, 100);

  Esfera f = new Esfera(x, y, z, hurtCircleRadius, #62F525, 20, null, 100);

  // Create a new explosion with specified parameters

  Explosion explosion = new Explosion(x, y, z, 500, 600, explosionScale, shockwaveSize, a, b, f, bombType); // Customize parameters
  explosions.add(explosion); // Add the explosion to the list 100 200

  return explosion;
}
void positionLogic() {
  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);

  // Guardar valores en archivos sin cerrar
  output.println(x + "," + y + "," + z);
  output.flush();
}

void keyPressed() {
  if (key == 'e') {



    Explosion actualExp = triggerExplosion();
    c.lookForAfectedPeople(actualExp);

    long deadPeoplePB = c.getDeadPeoplePerBomb();
    long deadPeople = c.getTotalDeadPeople();
    long hurtPeople =c.getTotalHurtPoblation();
    long radPeople = c.getTotalRadiatedPoblation();
    long radPb =c.getIrraditedPeoplePerBomb();
    long hurtPb = c.getHurtPeoplePerBomb();
    long totalP=c.getTotalAlivePeople();




    updatePeopleCount(totalP, deadPeople, hurtPeople, radPeople, deadPeoplePB, radPb, hurtPb); // Tot - Dead - Hurt - Rad - deadPB - radPB - hurtPB
  } else if (key == 'p') {
    placeSphere();
  } else if (key == ESC) {
    exitSimulation();
  }
}

void placeSphere() {
  // Colocar una esfera en la posición actual de x, y, z
  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);
  Esfera newSphere = new Esfera(x, y, z, 3, #FF0000, 10, null, 255);
  esferasEscritura.add(newSphere);
  positionLogic();
}
void exitSimulation() {
  // Guarda los datos pendientes en el archivo
  output.close();
  exit();
}

PVector randomPositionOnSphere(float radius) {
  float u, theta, r, x, y, z;


  u = random(-1, 1);
  theta = random(TWO_PI);
  r = radius * sqrt(1 - u * u);

  x = r * cos(theta);
  y = r * sin(theta);
  z = radius * u;


  return new PVector(x, y, z);
}
