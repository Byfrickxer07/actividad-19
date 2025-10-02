

//  Variables para múltiples elipses
class Elipse {
  float x, y;
  float xSpeed, ySpeed;
  float diametro;
  color colorElipse;
  
  Elipse(float _x, float _y, float _xSpeed, float _ySpeed, float _d) {
    x = _x;
    y = _y;
    xSpeed = _xSpeed;
    ySpeed = _ySpeed;
    diametro = _d;
    colorElipse = color(random(255), random(255), random(255));
  }
  
  void actualizar() {
    // Actualizar posición
    x += xSpeed;
    y += ySpeed;
    
    // Rebote contra bordes
    if (x > width - diametro/2 || x < diametro/2) {
      xSpeed *= -1;
    }
    if (y > height - diametro/2 || y < diametro/2) {
      ySpeed *= -1;
    }
  }
  
  void dibujar() {
    fill(colorElipse);
    noStroke();
    ellipse(x, y, diametro, diametro);
    
    // Efecto de brillo
    fill(255, 255, 255, 100);
    ellipse(x - diametro/6, y - diametro/6, diametro/3, diametro/3);
  }
  
  void cambiarColor() {
    colorElipse = color(random(255), random(255), random(255));
  }
  
  void aumentarVelocidad() {
    xSpeed *= 1.5;
    ySpeed *= 1.5;
  }
}

//  Variables para las imágenes
PImage fondo;
PImage logo;

//  Lista de elipses
ArrayList<Elipse> elipses;

//  Variables de estado
boolean mostrarInstrucciones = true;
int tiempoInstrucciones = 0;

void setup() {
  size(800, 600);
  
  //  Cargar imágenes (si no existen, usar colores de fondo)
  try {
    fondo = loadImage("fondo.jpg");
  } catch (Exception e) {
    println("No se encontró fondo.jpg - usando degradado");
  }
  
  try {
    logo = loadImage("imagen.png");
  } catch (Exception e) {
    println("No se encontró imagen.png - dibujando logo personalizado");
  }
  
  //  Inicializar lista de elipses
  elipses = new ArrayList<Elipse>();
  
  // Crear 3 elipses iniciales
  elipses.add(new Elipse(width/2, height/2, 3, 2, 50));
  elipses.add(new Elipse(200, 300, -2, 3, 40));
  elipses.add(new Elipse(600, 200, 2.5, -2.5, 45));
  
  tiempoInstrucciones = millis();
}

void draw() {
  //  Dibujar fondo
  if (fondo != null) {
    image(fondo, 0, 0, width, height);
    // Overlay semi-transparente para mejor visibilidad
    fill(0, 0, 0, 100);
    rect(0, 0, width, height);
  } else {
    // Degradado de fondo alternativo
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      color c = lerpColor(color(25, 25, 112), color(70, 130, 180), inter);
      stroke(c);
      line(0, i, width, i);
    }
  }
  
  // 📷 Mostrar logo/imagen adicional
  if (logo != null) {
    image(logo, width - 110, 10, 90, 90);
  } else {
    // Dibujar logo personalizado alternativo
    dibujarLogoPersonalizado(width - 65, 55, 40);
  }
  
  //  Actualizar y dibujar todas las elipses
  for (Elipse e : elipses) {
    e.actualizar();
    e.dibujar();
  }
  
  //  Dibujar iniciales (cambiar por las tuyas)
  drawInitials();
  
  //Información en pantalla
  dibujarInfo();
  
  // Instrucciones (se ocultan después de 5 segundos)
  if (mostrarInstrucciones && millis() - tiempoInstrucciones < 5000) {
    dibujarInstrucciones();
  }
}

//  Función para dibujar THOMAS con figuras geométricas
void drawInitials() {
  pushMatrix();
  translate(50, 450);
  
  stroke(255, 215, 0); // Color dorado
  strokeWeight(7);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  noFill();
  
  //  Letra T
  line(0, 0, 50, 0);      // Línea horizontal superior
  line(25, 0, 25, 80);    // Línea vertical central
  
  //  Letra H
  translate(70, 0);
  line(0, 0, 0, 80);      // Línea vertical izquierda
  line(0, 40, 40, 40);    // Línea horizontal media
  line(40, 0, 40, 80);    // Línea vertical derecha
  
  //  Letra O - usando ellipse()
  translate(65, 0);
  ellipse(20, 40, 40, 80); // Elipse vertical
  
  //  Letra M
  translate(60, 0);
  line(0, 80, 0, 0);      // Línea vertical izquierda
  line(0, 0, 20, 30);     // Diagonal izquierda
  line(20, 30, 40, 0);    // Diagonal derecha
  line(40, 0, 40, 80);    // Línea vertical derecha
  
  //  Letra A
  translate(65, 0);
  line(0, 80, 20, 0);     // Diagonal izquierda
  line(20, 0, 40, 80);    // Diagonal derecha
  line(10, 50, 30, 50);   // Barra horizontal
  
  // Letra S - usando arc()
  translate(65, 0);
  noFill();
  // Arco superior
  arc(20, 20, 35, 40, PI, TWO_PI);
  // Arco inferior
  arc(20, 60, 35, 40, 0, PI);
  
  popMatrix();
  
  // Texto con el nombre debajo
  fill(255, 215, 0);
  textSize(20);
  textAlign(LEFT);
  text("THOMAS", 50, 555);
}

// Función para dibujar logo personalizado (si no hay imagen)
void dibujarLogoPersonalizado(float x, float y, float tam) {
  pushMatrix();
  translate(x, y);
  
  // Estrella rotante
  fill(255, 215, 0);
  noStroke();
  rotate(frameCount * 0.02);
  
  beginShape();
  for (int i = 0; i < 10; i++) {
    float angle = TWO_PI / 10 * i;
    float r = (i % 2 == 0) ? tam : tam/2;
    float px = cos(angle) * r;
    float py = sin(angle) * r;
    vertex(px, py);
  }
  endShape(CLOSE);
  
  popMatrix();
}

// Mostrar información en pantalla
void dibujarInfo() {
  fill(255, 255, 255, 200);
  textAlign(RIGHT);
  textSize(14);
  text("Elipses: " + elipses.size(), width - 10, height - 40);
  text("FPS: " + int(frameRate), width - 10, height - 20);
}

// Instrucciones iniciales
void dibujarInstrucciones() {
  fill(0, 0, 0, 180);
  rect(width/2 - 200, 20, 400, 160, 10);
  
  fill(255, 255, 100);
  textAlign(CENTER);
  textSize(18);
  text(" INSTRUCCIONES", width/2, 45);
  
  fill(255);
  textSize(14);
  text("Click izquierdo: Cambiar colores", width/2, 75);
  text("Click derecho: Agregar nueva elipse", width/2, 95);
  text("Tecla ESPACIO: Aumentar velocidad", width/2, 115);
  text("Tecla 'R': Reiniciar", width/2, 135);
  text("Tecla 'H': Ocultar/Mostrar ayuda", width/2, 155);
}

//  Interacción con click del mouse
void mousePressed() {
  if (mouseButton == LEFT) {
    // Click izquierdo: cambiar color de todas las elipses
    for (Elipse e : elipses) {
      e.cambiarColor();
    }
  } else if (mouseButton == RIGHT) {
    // Click derecho: agregar nueva elipse en posición del mouse
    float velocidadX = random(-4, 4);
    float velocidadY = random(-4, 4);
    float diam = random(30, 60);
    elipses.add(new Elipse(mouseX, mouseY, velocidadX, velocidadY, diam));
  }
}

//  Interacción con teclado
void keyPressed() {
  if (key == ' ') {
    // Espacio: aumentar velocidad de todas las elipses
    for (Elipse e : elipses) {
      e.aumentarVelocidad();
    }
  } else if (key == 'r' || key == 'R') {
    // R: reiniciar programa
    elipses.clear();
    elipses.add(new Elipse(width/2, height/2, 3, 2, 50));
    elipses.add(new Elipse(200, 300, -2, 3, 40));
    elipses.add(new Elipse(600, 200, 2.5, -2.5, 45));
  } else if (key == 'h' || key == 'H') {
    // H: mostrar/ocultar instrucciones
    mostrarInstrucciones = !mostrarInstrucciones;
    if (mostrarInstrucciones) {
      tiempoInstrucciones = millis();
    }
  }
}

