
import peasy.*;
import controlP5.*;
ControlP5 controlP5;
PImage img;
PeasyCam cam;
int numSpheres = 3000;
float radius = 1200;
PVector[] smallSpheres;


float whiteSphereSpeed = 0.02;
float theta = 0;
float phi = HALF_PI;

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

import processing.opengl.*;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

Textlabel totalPeople;
Textlabel totalDeadPeople;
Textlabel totalRadiatedPeople;
Textlabel totalHurtPeople;

Textlabel deadPeoplePerBomb;
Textlabel radPeoplePerBomb;
Textlabel hurtPeoplePerBomb;

CColor colorPrincipal;
CColor colorHiroshima;
CColor colorHidrogeno;
CColor colorTSAR;

Button botonHiroshima, botonHidrogeno, botonTSAR;
Group infoGroup;
Textlabel infoLabel;

void bombInfo() {
  controlP5 = new ControlP5(this);

  // Labels principales
  totalPeople = controlP5.addTextlabel("totalPeopleLabel")
    .setText("Total de personas: 0")
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

  // Información
  infoGroup = controlP5.addGroup("Mostrar informacion sobre la bomba:")
                 .setPosition(10, 350)
                 .setWidth(400)
                 .setHeight(20)
                 .close()
                 .setBackgroundColor(color(255,80))
                 .setBackgroundHeight(220)
                 .setFont(createFont("Georgia", 15));
  
  infoLabel = controlP5.addTextlabel("infoLabel")
                 .setPosition(10, 10)
                 .setWidth(430)
                 .setFont(createFont("Georgia", 15))
                 .setGroup(infoGroup);


  controlP5.setAutoDraw(false);
}

void setup() {
  //size(800, 600, OPENGL);
  fullScreen(OPENGL);
  g3 = (PGraphics3D)g;
  background(0);
  smallSpheres = new PVector[numSpheres];


  String name = "tierra2.jpg";
  img = loadImage(name);

  cam = new PeasyCam(this, 2000);


  cam.setMinimumDistance(1500);
  cam.setMaximumDistance(2500);




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
}

void draw() {
  background(0);
  // lights();


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
  String newText = "Total de personas: " + total;
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
  radCircleRadius = 6;
  hurtCircleRadius = 10;
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
  radCircleRadius = 13;
  hurtCircleRadius = 20;
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
  radCircleRadius = 30;
  hurtCircleRadius = 50;
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

Explosion triggerExplosion() {
  // Get the explosion position based on the white sphere position
  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);


  Esfera a = new Esfera(x, y, z, deadCircleRadius, #F70000, 5, null, 200);

  Esfera b = new Esfera(x, y, z, radCircleRadius, #EEF231, 5, null, 100);

  Esfera f = new Esfera(x, y, z, hurtCircleRadius, #62F525, 5, null, 100);

  // Create a new explosion with specified parameters

  Explosion explosion = new Explosion(x, y, z, 500, 600, explosionScale, shockwaveSize, a, b, f, bombType); // Customize parameters
  explosions.add(explosion); // Add the explosion to the list 100 200

  return explosion;
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
  }
}

void exit() {

  // Llama a la función exit original para cerrar el programa
  super.exit();
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
