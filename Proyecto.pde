
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
Textlabel deadPeople;
Textlabel radiatedPeople;
Textlabel hurtPeople;
CColor colorPrincipal;
CColor colorHiroshima;
CColor colorHidrogeno;
CColor colorTSAR;

Button botonHiroshima, botonHidrogeno, botonTSAR;

void bombInfo() {
  controlP5 = new ControlP5(this);

  totalPeople = controlP5.addTextlabel("totalPeopleLabel")
    .setText("Total de personas: 1.000.000")
    .setPosition(10, 10)
    .setColorValue(#444444)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);


  deadPeople = controlP5.addTextlabel("deadPeopleLabel")
    .setText("Personas muertas: 0")
    .setPosition(10, 50)
    .setColorValue(#FF0313)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

  radiatedPeople = controlP5.addTextlabel("radiatedPeopleLabel")
    .setText("Personas irradiadas: 0")
    .setPosition(10, 90)
    .setColorValue(#39FF14)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);


  hurtPeople = controlP5.addTextlabel("hurtPeopleLabel")
    .setText("Personas heridas: 0")
    .setPosition(10, 130)
    .setColorValue(#FFD700)
    .setFont(createFont("Georgia", 40))
    .setSize(200, 40);

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


  controlP5.setAutoDraw(false);
}

void setup() {
  size(800, 600, OPENGL);
  //fullScreen(OPENGL);
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
  for (int i = explosions.size() - 1; i >= 0; i--){
    Explosion exp = explosions.get(i);
    if(exp.isComplete()){
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

public void updatePeopleCount(long total, long dead, long hurt, long rad) {
  String newText = "Total de personas: " + total;
  totalPeople.setText(newText);
  newText = "Personas muertas: " + dead;
  deadPeople.setText(newText);
  newText = "Personas irradiadas: " + rad;
  radiatedPeople.setText(newText);
  newText = "Personas heridas: " + hurt;
  hurtPeople.setText(newText);
}

public void Hiroshima() {
  println("Se ha seleccionado Hiroshima");
  if (botonHiroshima != null) botonHiroshima.setColor(colorHiroshima);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorPrincipal);
  if (botonTSAR != null) botonTSAR.setColor(colorPrincipal);
  explosionScale = 0.25;
  shockwaveSize = 10;
  deadCircleRadius = 2.5;
  radCircleRadius = 5;
  hurtCircleRadius = 10;
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
  hurtCircleRadius = 20;
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
  hurtCircleRadius = 50;
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

  Explosion explosion = new Explosion(x, y, z, 500, 600, explosionScale, shockwaveSize,a,b,f); // Customize parameters
  explosions.add(explosion); // Add the explosion to the list 100 200
  return explosion;
}

void keyPressed() {
  if (key == 'e') {
    long newCount = 4785060131L;  // Simulamos un número aleatorio
    updatePeopleCount(newCount, 46109212, newCount, newCount);  // Actualizamos el label con el nuevo número

    float x = radius * sin(phi) * cos(theta);
    float y = radius * sin(phi) * sin(theta);
    float z = radius * cos(phi);

    Explosion actualExp = triggerExplosion();
    c.lookForAfectedPeople(actualExp);
    //Temporal
   
  }
  if (key == ESC) {  // Si se presiona la tecla ESC
    isRunning = false;  // Detener la simulación
    exit();  // Llamar a la función exit
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
