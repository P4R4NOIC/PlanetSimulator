// TODO:
// 2. mejorar el comportamiento de los agentes aleatorios que representan humanos
// 3. poner edificios
// 4. ver si se mejora el movimiento al rededor del globo
import peasy.*;
import controlP5.*;
ControlP5 controlP5;
PImage img;
PeasyCam cam;
int numSpheres = 3000;
float radius = 1200;
PVector[] smallSpheres;
ArrayList<PVector> newSpheres;
float whiteSphereSpeed = 0.02;
float theta = 0;
float phi = HALF_PI;

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
  newSpheres = new ArrayList<PVector>();

  String name = "tierra2.jpg";
  img = loadImage(name);

  cam = new PeasyCam(this, 1500);



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
  explosions = new ArrayList<Explosion>();
}

void draw() {
  background(0);
  // lights();


  C1.display();
  
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion exp = explosions.get(i);
    exp.draw(); // Call the draw method of Explosion
    if (exp.isComplete()) {
      explosions.remove(i); // Remove completed explosions
    }
  }

  c.draw();


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

  Esfera whiteSphere = new Esfera(x, y, z, 10, #FFFFFF, 10, null, 255);
  whiteSphere.draw();

  for (PVector pos : newSpheres) {
    Esfera a = new Esfera(pos.x, pos.y, pos.z, 5, #F70000, 5, null, 255);
    a.draw();
    Esfera b = new Esfera(pos.x, pos.y, pos.z, 10, #EEF231, 5, null, 100);
    b.draw();
    Esfera f = new Esfera(pos.x, pos.y, pos.z, 20, #62F525, 5, null, 100);
    f.draw();
   
  }

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

public void updatePeopleCount(int total, int dead, int hurt, int rad) {
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
}

public void Hidrogeno() {
  println("Se ha seleccionado Hidrogeno");
  if (botonHiroshima != null) botonHiroshima.setColor(colorPrincipal);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorHidrogeno);
  if (botonTSAR != null) botonTSAR.setColor(colorPrincipal);
}

public void TSAR() {
  println("Se ha seleccionado TSAR");
  if (botonHiroshima != null) botonHiroshima.setColor(colorPrincipal);
  if (botonHidrogeno != null) botonHidrogeno.setColor(colorPrincipal);
  if (botonTSAR != null) botonTSAR.setColor(colorTSAR);
}

void triggerExplosion() {
  // Get the explosion position based on the white sphere position
  float x = radius * sin(phi) * cos(theta);
  float y = radius * sin(phi) * sin(theta);
  float z = radius * cos(phi);

  // Create a new explosion with specified parameters
  Explosion explosion = new Explosion(x, y, z, 500, 600, 1, 50); // Customize parameters
  explosions.add(explosion); // Add the explosion to the list 100 200
}

void keyPressed() {
  if (key == 'e') {
    int newCount = int(random(0, 100));  // Simulamos un número aleatorio
    updatePeopleCount(newCount, newCount, newCount, newCount);  // Actualizamos el label con el nuevo número

    float x = radius * sin(phi) * cos(theta);
    float y = radius * sin(phi) * sin(theta);
    float z = radius * cos(phi);
    
    newSpheres.add(new PVector(x, y, z));
    
    c.lookForAfectedPeople(new PVector(x, y, z),40);
    //Temporal
    triggerExplosion();
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
