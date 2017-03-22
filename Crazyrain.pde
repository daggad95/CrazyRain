import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileReader;

ArrayList<Droplet> droplets; 
ArrayList<AccelBox> boxes;
float rainTimer; //keeps track of when drops are spawned
float boxTimer; //keeps track of when boxes are spawned
float levelTimer; //keeps track of when to increase level
float dropInterval; //time between rain drops;
float boxInterval; //time between new box spawns
float levelInterval; //time between levels;
int maxDrops; //Max number of droplets on screen at once
int maxBoxes; //Max number of boxes in play at once
PVector gravity;
int level;
int score;
int highscore;
boolean alive;
boolean again; //selection for end game screen

void setup() {
  droplets = new ArrayList<Droplet>();
  boxes = new ArrayList<AccelBox>();
  
  rainTimer = millis();
  boxTimer = millis();
  levelTimer = millis();
  
  dropInterval = 500;
  boxInterval = 1000;
  levelInterval = 10000;
  maxDrops = 100;
  maxBoxes = 5;
  again = true;
  
  gravity = new PVector(0, 0.1);
  level = 1;
  score = 0;
  alive = true;
  
  //reading in highscore
  try {
    BufferedReader fr = new BufferedReader(new FileReader("highscore.txt")); 
    highscore = Integer.parseInt(fr.readLine());
  } catch (Exception e) {
    highscore = 0;
    print("crap");
  }
  
  
  noCursor();
  fullScreen();
}
//////////////////////////////////////
////////////MAIN GAME LOOP////////////
//////////////////////////////////////
void draw() {
  if (alive) {
        
    //level up!
    if (millis() - levelTimer > levelInterval) {
      level += 1;
      dropInterval *= 0.5;
      gravity.add(0, 0.05);
      
      levelTimer = millis();
    }
    
    
    //spawning new drop
    if (millis() - rainTimer > dropInterval && droplets.size() < maxDrops) {
      spawnDrop();
      rainTimer = millis();
    }
    
    //spawning new box
    if (millis() - boxTimer > boxInterval) {
      if (boxes.size() == maxBoxes) {
        boxes.remove(0);
      }
     
      spawnBox();
      boxTimer = millis();
    }
    
    background(0); //clearing screen for drawing
    
    //drawing level text
    fill(255);
    textSize(32);
    text("Level: " + level, width - 200, 50);
    text("Score: " + score, width - 200, 100);
    
    //drawing boxes (debug only)
    /*
    for (AccelBox box : boxes) {
      box.draw();
    }*/
    
    //drawing player
    fill(176, 23, 31);
    ellipse(mouseX, mouseY, 25, 25);
    
    //updating and drawing drops
    for (Droplet drop : droplets) {
      if (!drop.touchingPlayer()) {
        //applying gravity
        drop.accelerate(gravity);
        
        //applying accelbox if intersecting
        for (AccelBox box : boxes) {
          if (box.intersect(drop)) {
            drop.accelerate(box.getAccel());
          }
        }
        
        drop.update();
        drop.draw();
      } else {
        alive = false;
        updateHS();
      }
    }
    
    //removing out of bound drops
    for (int i = 0; i < droplets.size(); i++) {
      if (droplets.get(i).getPos().y > height) {
        droplets.remove(i);
        score += level;
      }
    }
  } else {
    int xOff = 100;
    int yOff = 100;
    
    background(0); //clearing screen for drawing
    fill(255);
    textSize(48);
    text("GAME OVER", width / 2 - xOff, height / 2 - yOff);
    textSize(32);
    text("Level: " + level, width / 2 - xOff, height / 2 + 100 - yOff);
    text("Score: " + score, width / 2 - xOff, height / 2 + 150 - yOff);
    text("High Score: " + highscore, width / 2 - xOff, height / 2 + 200 - yOff);
    text("PLAY AGAIN!", width / 2 - xOff, height / 2 + 250 - yOff);
    text("EXIT", width / 2 - xOff, height / 2 + 300 - yOff);
    
    fill(255, 70);
    if (again) {
      rect(width / 2 - xOff - 10, height /2 + 210 - yOff, 250, 50);
    } else {
      rect(width / 2 - xOff - 10, height /2 + 260 - yOff, 250, 50);
    }
  }
}
//////////////////////////////////////
//////////END MAIN GAME LOOP//////////
//////////////////////////////////////

//////////////////////////////////////
//////////////USER INPUT//////////////
//////////////////////////////////////
void keyPressed() {
  if (key == CODED) {
    if (keyCode == ESC) {
      exit();
    }
    
    if (!alive) {
      if (keyCode == UP || keyCode == DOWN) {
        again = !again;
      }
      
    }
  }
  
  if (!alive) {
    if (keyCode == ENTER) {
      if (again) {
        alive = true;
        setup();
      } else {
        exit();
      }
    }
  }
  
}


//////////////////////////////////////
////////////END USER INPUT////////////
//////////////////////////////////////

//updates highscore if neccesary; 
void updateHS() {
  if (score > highscore) {
    try {
      FileWriter output = new FileWriter("highscore.txt",false); //the true will append the new data
      output.write(Integer.toString(score));
      output.flush();
      output.close();
    }
    catch(IOException e) {
      println("It Broke");
      e.printStackTrace();
    }
  }
}

//Spawns a droplet above the screen
void spawnDrop() {
  PVector pos = new PVector(random(width), -100 + random(50));
  float size = 10 + random(level*10);
  
  droplets.add(new Droplet(pos, size));
}

//Spawns an accelbox randomly on the screen with a random size and acceleration vector
void spawnBox() {
   float MA = level*0.5; //max acceleration
  
   PVector pos = new PVector(random(width), random(height));
   PVector size = new PVector(100+random(width/2), 100+random(height/2));
   PVector accel = new PVector(-MA + random(2*MA), -MA + random(2*MA));
   
   boxes.add(new AccelBox(pos, accel, size));
}