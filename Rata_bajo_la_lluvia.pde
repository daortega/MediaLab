Catcher catcher;    
Timer timer;        
Drop[] drops;       
int totalDrops = 0; 

boolean gameOver = false;

// Variables de puntaje, nivel y vidas restantes 
int score = 0;      // Puntaje actual
int level = 1;      // Qué nivel se está jugando
int lives = 10;     // 10 vidas por nivel, una gota elimina un 
int levelCounter = 0;

PFont f;

void setup() {
  size(640, 500);
  catcher = new Catcher(50); // Zona que atrapa las gotas, de radio 50
  drops = new Drop[1000];    // Genera 1000 gotas
  timer = new Timer(300);    // Create a timer that goes off every 300 milliseconds
  timer.start();             // Inicio temporizador

  f = createFont("Courier New", 12, true); // tipografía para textos
}

void draw() {
  background(255);

   // Si se acaba el juego
  if (gameOver) {
    background(30);
    textFont(f, 48);
    textAlign(CENTER);
    fill(200,160,43);
    text("ESTÁS MOJADO", width/2, height/2);
  } else {
    
    // Localización catcher
  catcher.setLocation(mouseX+10, 400); 
  // Display the catcher
  catcher.display(); 

 // Revisión tiempo
    if (timer.isFinished()) {
      // Deal with raindrops
      // Initialize one drop
      if (totalDrops < drops.length) {
        drops[totalDrops] = new Drop();
        // Increment totalDrops
        totalDrops++;
    }
    timer.start();
  }

   // Movimiento gotas
    for (int i = 0; i < totalDrops; i++ ) {
      if (!drops[i].finished) {
        drops[i].move();
        drops[i].display();
        if (drops[i].reachedBottom()) {
          levelCounter++;
          drops[i].finished(); 
          // Una vida menos si llega una gota al final de la ventana
          lives--;
          // Se acaba el juego con 0 vidas
          if (lives <= 0) {
            gameOver = true;
          }
        } 
  
   //RATONCITO
    noStroke();  //sin borde
    fill(102,51,51); 
     arc(mouseX+20,430,60,50,0,PI); //  poto base
    fill(150,100,89);
     quad(mouseX-10,430, mouseX+50,430, mouseX+35,360, mouseX+5,360);  //cuerpo
     
     ellipse(mouseX, 365, 25,25); 
     triangle(mouseX+34,360, mouseX+50,360, mouseX+39,380); //boca
     
   fill(255);
     ellipse(mouseX+30,370,10,10);  //ojito
   fill(150,100,89);
     ellipse(mouseX+32,369,6,6);
     
 //COLA
   stroke(102,51,51);        //COLOR LÍNEA
     strokeWeight(5);        //ESPESOR LINEA
     noFill();               // NO RELLENO
       line(mouseX+20,452, mouseX-50,452);
       arc(mouseX-52,427, 50,50, PI/2, 3*PI/2);          //primera vuelta
       arc(mouseX-50,420, 35,35, 3*PI/2, 5*PI/2); 
       arc(mouseX-51,427, 20,20, PI/2, 3*PI/2);
   
//PARAGUA
   noStroke();
    fill(200,160,43);
   arc(mouseX+20,330, 80,50, PI, 2*PI);
   stroke(102,51,51);
   strokeWeight(3);
   line(mouseX+20,360, mouseX+20,330);
   
// El marcador aumenta al atrapar una gota
        if (catcher.intersect(drops[i])) {
          drops[i].finished();
          levelCounter++;
          score++;
        }
      }
    }

    // Si 10 gotas no son atrapadas, termina el juego
    if (levelCounter >= drops.length) {
      // Aumentar nivel
      level++;
      // reiniciar elementos del nivel
      levelCounter = 0;
      lives = 10;
      timer.setTime(constrain(300-level*25, 0, 300));
      totalDrops = 0;
    }
    
    // Mostrar vidas restantes
    textFont(f, 14);
    fill(0);
    text("Vidas: " + lives, 10, 20);
    rect(10, 24, lives*10, 10);

    text("Nivel: " + level, 300, 20);
    text("Gotas: " + score, 300, 40);
  }
}

class Catcher {
  float r;    // radius
  color col;  // color
  float x, y; // location

  Catcher(float tempR) {
    r = tempR;
    col = color(50, 10, 10, 150);  //modifiqué aquí
    x = 0;
    y = 0;
  }

  void setLocation(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void display() {  //Características del catcher
    noStroke();     //sin borde
    noFill();       //sin color
    ellipse(x, y, r*2, r*2);
  }

  // Si el catcher toca una gota
  boolean intersect(Drop d) {
    float distance = dist(x, y, d.x, d.y);   // Calcular distancia
    // Compare distance to sum of radii
    if (distance < r + d.r) { 
      return true;
    } else {
      return false;
    }
  }
}

class Drop {
  float x, y;   // variables ubicación gotas
  float speed;  // velocidad gotas
  color c;
  float r;      // radio de las gotas

 boolean finished = false;
 
  Drop() {
    r = random(7, 12);       // Las gotitas son de tamaño random
    x = random(width);       // Start with a random x location
    y = -r*4;                // Start a little above the window
    speed = random(2, 5);    // Velocidad random entre 2-5
    c = color(200,160,43);   // Color dorado
  }

  // Que las gotas caigan
  void move() {
    y += speed;   // Aumenta velocidad
  }

  boolean reachedBottom() {
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(c);
    noStroke();
    for (int i = 2; i < r; i++ ) {
      ellipse(x, y + i*4, i*2, i*2);
    }
  }

  void finished() {
    finished = true;
  }
}

class Timer {
  int savedTime;
  int totalTime; 
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  void setTime(int t) {
    totalTime = t;
  }
  
 //iniciar el temporizador
  void start() {
    savedTime = millis();
  }
  boolean isFinished() { 
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}