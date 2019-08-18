int maxW =          30;
int maxH =          30;
int minW =          5;
int minH =          5;
int fallingSpeed =  1;

ArrayList<Square> squares = new ArrayList<Square>();

int gameTimeCurrent =          0;
int gameTimeIntervall =        25;
int lastDamagedTime =          0;
int recentlyDamagedIntervall = 2000; //immunity timer after damage
int lastHealedTime =           0;
int lastHOSpawnedTime =        0;
int autoHOSpawnTimePeriod =    6673;
int recentlyHealedIntervall =  autoHOSpawnTimePeriod;

SpaceShip player;
color playerColor =            color(0, 150, 150);
color objectColor =            color(150, 0, 0);
int playerMoveSpeed =          0;
int relativeDistanceValue =    20;
int defaultPlayerLives =       3;
int playerLives;
boolean recentlyDamaged =      false;
boolean recentlyHealed =       false;

int lastSquareSpawnedTime =            0;
int autoSquareSpawnTimePeriod =        0;
int defaultAutoSquareSpawnTimePeriod = 1500;
int autoSquareSpawnTimeAcceperation =  100;
int minimumAutoSquareSpawnTimePeriod = 200;

ArrayList<HealthOrb> healthOrbs = new ArrayList<HealthOrb>();
color healthColor = color(0,255,0);


float DEFAULT_SQUARE_FALLING_SPEED = 1.2;
float DEFAULT_SQUARE_ACCELERATION =  1.4;
float DEFAULT_SQUARE_TOPSPEED =      7;

float DEFAULT_PLAYER_SPEED =        0;
float DEFAULT_PLAYER_ACCELERATION = 3.6;
float DEFAULT_PLAYER_TOPSPEED =     4;

int a, b, c, d; //for mouse

void setup() {
  size(500, 500);
  background(255);
  newGame();
}

void draw() {
  if(playerLives > 0){
      if (millis() - gameTimeCurrent >= gameTimeIntervall) {
        gravity();
        gameTimeCurrent = millis();
      }
      if (millis() - lastSquareSpawnedTime >= autoSquareSpawnTimePeriod) {
        spawnSquare();
        if(autoSquareSpawnTimePeriod > minimumAutoSquareSpawnTimePeriod){
          autoSquareSpawnTimePeriod -= autoSquareSpawnTimeAcceperation;
        }
        
        lastSquareSpawnedTime = millis();
      }
      if (millis() - lastHOSpawnedTime >= autoHOSpawnTimePeriod) {
        spawnHealthOrb();
        
        lastHOSpawnedTime = millis();
      }
      
    
      background(255);
      drawSquares();
      drawHealthOrbs();
      drawSpaceShip();
      moveSpaceShip();
  }
  if (millis() - lastDamagedTime >= recentlyDamagedIntervall) {
    lastDamagedTime = millis();
    recentlyDamaged = false;
  }
  if (millis() - lastHealedTime >= recentlyHealedIntervall) {
    lastHealedTime = millis();
    recentlyHealed = false;
  }
}

void mousePressed() {
  a=mouseX;
  b=mouseY;
}
void mouseDragged() {
  fill(objectColor);
  stroke(0);
  c=mouseX-a;
  d=mouseY-b;
  rect(a, b, c, d);
}
void mouseReleased() {
  spawnSquare(a, b, c, d);
  a=b=c=d=0;
}
void keyPressed() {

  switch(key) {
  case 's':
    spawnSquare();
    break;
  case 'c':
    newGame();
    break;
  case 'a':
    moveSpaceShip('a');
    break;
  case 'd':
    moveSpaceShip('d');
    break;
  }
}
void newGame() {
  autoSquareSpawnTimePeriod = defaultAutoSquareSpawnTimePeriod;
  squares = new ArrayList<Square>();
  healthOrbs = new ArrayList<HealthOrb>();
  background(255);
  println("New Game Starts");
  spawnSpaceShip();
  playerLives = defaultPlayerLives;
}

void spawnSquare(int pX_, int pY_, int w_, int h_) {

  int pX, pY, w, h;

  w = w_;
  h = h_;
  pX = pX_;
  pY = pY_;

  squares.add(new Square(pX, pY, w, h));
}

void spawnSquare() {

  int pX, pY, w, h;

  w = int(random(minW, maxW));
  h = int(random(minH, maxH));
  pX = int(random(0, width-w));
  pY = int(random(0, height/2-h));

  squares.add(new Square(pX, pY, w, h));
}

void spawnHealthOrb() {

  int pX, pY, w, h;

  w = int(random(minW, maxW));
  h = w;
  pX = int(random(0, width-w));
  pY = int(random(0, height/2-h));

  healthOrbs.add(new HealthOrb(pX, pY, w, h));
}

void gravity() {
  
  for (int i=0; i<squares.size(); i++) {
    if (squares.get(i).getPosY() > height) {
      squares.remove(i);
    } else {
      if(playerLives > 0){
        
        if(squares.get(i).getTopSpeed() > squares.get(i).getPS() )
          squares.get(i).setPS(squares.get(i).getPS()*squares.get(i).getPA());
        
        squares.get(i).setPosY(squares.get(i).getPosY()+squares.get(i).getPS());

        if(
      
          ( player.getPosX() <= squares.get(i).getPosX() + squares.get(i).getW() &&
            player.getPosX() >= squares.get(i).getPosX() &&
            player.getPosY() <= squares.get(i).getPosY() + squares.get(i).getH() &&
            player.getPosY() >= squares.get(i).getPosY()
            
            )
            ||
           
          ( player.getPosX()+player.getW() <= squares.get(i).getPosX() + squares.get(i).getW() && 
            player.getPosX()+player.getW() >= squares.get(i).getPosX() && 
            player.getPosY() <= squares.get(i).getPosY() + squares.get(i).getH() &&
            player.getPosY() >= squares.get(i).getPosY()
          )
    
            ||
          (
            player.getPosX() <= squares.get(i).getPosX() &&
            player.getPosX()+player.getW() >= squares.get(i).getPosX() &&
            player.getPosY() <= squares.get(i).getPosY() + squares.get(i).getH() &&
            player.getPosY() >= squares.get(i).getPosY()
    
            )
            ||
          (
            player.getPosX() <= squares.get(i).getPosX() &&
            player.getPosX()+player.getW() >= squares.get(i).getPosX()+squares.get(i).getW() &&
            player.getPosY() <= squares.get(i).getPosY() + squares.get(i).getH() &&
            player.getPosY() >= squares.get(i).getPosY()
          )
        )
          
          if(playerLives > 0 && !recentlyDamaged){
            playerLives--;
            println("HÁTRALÉVŐ ÉLETEK:"+playerLives);
            
            recentlyDamaged = true;
            
          }
          if(playerLives == 0){
            println("Game over");
          }
            
        }
    }
  }
  
  for (int i=0; i<healthOrbs.size(); i++) {
    if (healthOrbs.get(i).getPosY() > height) {
      healthOrbs.remove(i);
    } else {
      if(playerLives > 0){
        
        if(healthOrbs.get(i).getTopSpeed() > healthOrbs.get(i).getPS() )
          healthOrbs.get(i).setPS(healthOrbs.get(i).getPS()*healthOrbs.get(i).getPA());
        
        healthOrbs.get(i).setPosY(healthOrbs.get(i).getPosY()+healthOrbs.get(i).getPS());

        if(
      
          ( player.getPosX() <= healthOrbs.get(i).getPosX() + healthOrbs.get(i).getW() &&
            player.getPosX() >= healthOrbs.get(i).getPosX() &&
            player.getPosY() <= healthOrbs.get(i).getPosY() + healthOrbs.get(i).getH() &&
            player.getPosY() >= healthOrbs.get(i).getPosY()
            
            )
            ||
           
          ( player.getPosX()+player.getW() <= healthOrbs.get(i).getPosX() + healthOrbs.get(i).getW() && 
            player.getPosX()+player.getW() >= healthOrbs.get(i).getPosX() && 
            player.getPosY() <= healthOrbs.get(i).getPosY() + healthOrbs.get(i).getH() &&
            player.getPosY() >= healthOrbs.get(i).getPosY()
          )
    
            ||
          (
            player.getPosX() <= healthOrbs.get(i).getPosX() &&
            player.getPosX()+player.getW() >= healthOrbs.get(i).getPosX() &&
            player.getPosY() <= healthOrbs.get(i).getPosY() + healthOrbs.get(i).getH() &&
            player.getPosY() >= healthOrbs.get(i).getPosY()
    
            )
            ||
          (
            player.getPosX() <= healthOrbs.get(i).getPosX() &&
            player.getPosX()+player.getW() >= healthOrbs.get(i).getPosX()+healthOrbs.get(i).getW() &&
            player.getPosY() <= healthOrbs.get(i).getPosY() + healthOrbs.get(i).getH() &&
            player.getPosY() >= healthOrbs.get(i).getPosY()
          )
        ){
          if(!recentlyHealed){
            playerLives++;
            println("HÁTRALÉVŐ ÉLETEK:"+playerLives);
            recentlyHealed = true;
            
          }
        }
      }
    }
  }
}

void drawHealthOrbs() {
  fill(healthColor);
  stroke(0);
  for (HealthOrb ss : healthOrbs) {
    ellipse(ss.getPosX(), ss.getPosY(), ss.getW(), ss.getH());
  }
}

void drawSquares() {
  fill(objectColor);
  stroke(0);
  for (Square ss : squares) {
    rect(ss.getPosX(), ss.getPosY(), ss.getW(), ss.getH());
  }
}

void drawSpaceShip() {
  fill(playerColor);
  stroke(playerColor);
  rect(player.getPosX(), player.getPosY(), player.getW(), player.getH());
}
void spawnSpaceShip() {

  int x, y, w, h;
  w = 20;
  h = 10;
  x = (width/2)-(w/2);
  y = height-h;

  player = new SpaceShip(x, y, w, h);
}

void moveSpaceShip() {
  if(player.getPosX() > 0 && player.getPosX()+player.getW() < width ){
    player.setPS(player.getPS()*0.96);
    player.setPosX(player.getPosX()+player.getPS());
  }else{
    player.setPS(0);
  }
  
}

void moveSpaceShip(char c) {
  
  switch(c) {
    case 'a':
  
      if(abs(player.getPS()) < player.getTopSpeed()){
        if(player.getPosX() > 0){
          player.setPS(player.getPS()-player.getPA());
          player.setPosX(player.getPosX()+player.getPS());
        }else{
        player.setPS(0);
        }
        
      }
  
      break;
    case 'd':
  
      if(player.getPS() < player.getTopSpeed()){
        if(player.getPosX()+player.getW() < width){
          player.setPS(player.getPS()+player.getPA());
          player.setPosX(player.getPosX()+player.getPS());
        }else{
          player.setPS(0);
        }
  
      }
      break;
  }
}

class HealthOrb {
  float w, h, posX, posY;
  float speed;
  float acceleration;
  float topSpeed;

  HealthOrb(float posX_, float posY_, float w_, float h_) {
    w = w_;
    h = h_;
    posX = posX_;
    posY = posY_;
    speed = DEFAULT_SQUARE_FALLING_SPEED + random(0.1,0.7);
    acceleration = DEFAULT_SQUARE_ACCELERATION  + random(0.1,0.7);
    topSpeed = DEFAULT_SQUARE_TOPSPEED  + random(0.1,0.7);
  }
  void setTopSpeed(float tS_) {
    topSpeed = tS_;
  }
  float getTopSpeed() {
    return topSpeed;
  }
  float getW() {
    return w;
  }
  float getH() {
    return h;
  }
  float getPosX() {
    return posX;
  }
  float getPosY() {
    return posY;
  }
  void setW(float w_) {
    w = w_;
  }
  void setH(float h_) {
    h = h_;
  }
  void setPosX(float posX_) {
    posX = posX_;
  }
  void setPosY(float posY_) {
    posY = posY_;
  }

  float getPS() {
    return speed;
  }
  float getPA() {
    return acceleration;
  }

  void setPS(float pS_) {
    speed = pS_;
  }
  void setPA(float pA_) {
    acceleration = pA_;
  }
}

class Square {
  float w, h, posX, posY;
  float speed;
  float acceleration;
  float topSpeed;

  Square(float posX_, float posY_, float w_, float h_) {
    w = w_;
    h = h_;
    posX = posX_;
    posY = posY_;
    speed = DEFAULT_SQUARE_FALLING_SPEED + random(0.1,0.7);
    acceleration = DEFAULT_SQUARE_ACCELERATION  + random(0.1,0.7);
    topSpeed = DEFAULT_SQUARE_TOPSPEED  + random(0.1,0.7);
  }
  void setTopSpeed(float tS_) {
    topSpeed = tS_;
  }
  float getTopSpeed() {
    return topSpeed;
  }
  float getW() {
    return w;
  }
  float getH() {
    return h;
  }
  float getPosX() {
    return posX;
  }
  float getPosY() {
    return posY;
  }
  void setW(float w_) {
    w = w_;
  }
  void setH(float h_) {
    h = h_;
  }
  void setPosX(float posX_) {
    posX = posX_;
  }
  void setPosY(float posY_) {
    posY = posY_;
  }

  float getPS() {
    return speed;
  }
  float getPA() {
    return acceleration;
  }

  void setPS(float pS_) {
    speed = pS_;
  }
  void setPA(float pA_) {
    acceleration = pA_;
  }
}
class SpaceShip {

  float w, h, posX, posY;
  float speed;
  float acceleration;
  float topSpeed;

  SpaceShip(float posX_, float posY_, float w_, float h_) {
    w = w_;
    h = h_;
    posX = posX_;
    posY = posY_;
    speed = DEFAULT_PLAYER_SPEED;
    acceleration = DEFAULT_PLAYER_ACCELERATION;
    topSpeed = DEFAULT_PLAYER_TOPSPEED;
  }
  void setTopSpeed(float tS_) {
    topSpeed = tS_;
  }
  float getTopSpeed() {
    return topSpeed;
  }
  float getW() {
    return w;
  }
  float getH() {
    return h;
  }
  float getPosX() {
    return posX;
  }
  float getPosY() {
    return posY;
  }
  void setW(float w_) {
    w = w_;
  }
  void setH(float h_) {
    h = h_;
  }
  void setPosX(float posX_) {
    posX = posX_;
  }
  void setPosY(float posY_) {
    posY = posY_;
  }

  float getPS() {
    return speed;
  }
  float getPA() {
    return acceleration;
  }

  void setPS(float pS_) {
    speed = pS_;
  }
  void setPA(float pA_) {
    acceleration = pA_;
  }
}