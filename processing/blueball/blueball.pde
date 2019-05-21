// Author: Claire Daniel, building from generic example https://processing.org/examples/bounce.html

int rad = 20;        // Width of the ball
float w = 300;       // Width of the screen
float half = w/2;    // Half width of the screen

float xpos, ypos;    // Starting position of ball 
float xposCircle, yposCircle; // Moving position of ball
float xposBand, yposBand; // Wobbling position of band

boolean bottom, top;
boolean released; 

float xspeed;  // Speed of the shape
float yspeed;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

float tempDirection = 1;
float speedLimit = 7;

int i = 1;

//Setup the screen
void setup(){
  
  size(300,300);
  frameRate(30);
  ellipseMode(RADIUS);
}

void draw(){
  
  i = i + 1; //Count iterations
  background(0); //Wipe backgroud
  fill(0); 
  noFill();
  
  //Ensure ball says within screen
  if (mousePressed == true){

    xpos = mouseX;
    ypos = mouseY;

    if (xpos > w){
      xpos = w;
    }
    if (xpos < 0){
      xpos = 0; 
    }
    if (ypos > w){
      ypos = w;
    }
    if (ypos < 0){
      ypos = 0; 
    }

    //Draw rubber band
    stroke(255);
    strokeWeight(4);
    bezier(0,0, xpos, ypos, xpos, ypos, w, w);
    
    //Draw ball
    xposCircle = bezierPoint(0, xpos, xpos, w, 0.5);
    yposCircle = bezierPoint(0, ypos, ypos, w, 0.5);
    fill(255,0,0);
    noStroke();
    ellipse(xposCircle, yposCircle, rad,rad);
    
  }else{ // i.e if mouse not pressed
    
    xspeed = xspeed * 0.99;
    yspeed = yspeed * 0.99;
    
    // Update the position of the shape
    xpos = xpos + ( xspeed * xdirection );
    ypos = ypos + ( yspeed * ydirection );
    
    // Test to see if the shape exceeds the boundaries of the screen
    // If it does, reverse its direction by multiplying by -1
    if (xpos > width-rad || xpos < rad) {
      xdirection *= -1;
    }
    if (ypos > height-rad || ypos < rad) {
      ydirection *= -1;
    }

    //Once ball is released from the band entirely 
    if (((bottom == true) && (xposBand >= yposBand)) || ((top == true) && (xposBand <= yposBand))){
  
      if (i%3 ==0){
        tempDirection = tempDirection * -1;
      }
        
      float wobbleX = half + xspeed*xspeed/speedLimit*tempDirection;
      float wobbleY = half - yspeed*yspeed/speedLimit*tempDirection;
  
      stroke(max(xspeed, yspeed)/20*255);
      strokeWeight(4);
      noFill();
      bezier(0,0, wobbleX, wobbleY, wobbleX, wobbleY, w, w);
      
      noStroke();
      fill(255, 255 - xspeed/20*255, 255 - yspeed/20 * 255);
      ellipse(xpos, ypos, rad, rad);
        

           
    } else { //If ball still travelling with band
      
      xposBand = xposBand + ( (xspeed*0.99) * xdirection );
      yposBand = yposBand + ( (yspeed*0.99) * ydirection );
      
      stroke(255);
      strokeWeight(4);
      noFill();
      bezier(0,0, xposBand, yposBand, xposBand, yposBand, w, w);
      
      if (released ==true){
        xposCircle = bezierPoint(0, xposBand, xposBand, w, 0.5);
        yposCircle = bezierPoint(0, yposBand, yposBand, w, 0.5);      
        noStroke();
        fill(255, 255 - xspeed/20*255, 255 - yspeed/20 * 255);
        ellipse(xposCircle, yposCircle, rad, rad);
      }
    }
    
    //Otherwise starting position for the ball
    if (released == false) {
      noStroke();
      fill(255,0,0);
      ellipse(half, half, rad, rad);
    }
  }
}

//Determine what direction and initial speed when ball is released
void mouseReleased(){
    
  released = true;

  xpos = bezierPoint(0, xpos, xpos, w, 0.5);
  ypos = bezierPoint(0, ypos, ypos, w, 0.5);
  
  xposBand = xpos;
  yposBand = ypos;
  
  if (xpos <= ypos){
    ydirection = -1;
    xdirection = 1;
    top = false;
    bottom = true;
  } else {
    ydirection = 1;
    xdirection = -1;
    top = true;
    bottom = false;
  }
  
  float xlen = abs(half - xpos);
  float ylen = abs(half - ypos);
  
  xspeed = xlen/speedLimit;
  yspeed = ylen/speedLimit;

}
