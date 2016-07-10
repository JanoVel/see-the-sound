import ddf.minim.*;

Minim minim;
AudioPlayer sound;

float blinkFrame = 0;
float blinkChange = 0.04;
int blinkDir = 1;
boolean finishedBlink = false;
color colorBG;

boolean recording = true;

void setup(){
  size(960, 540);
  frameRate(30);
  
  colorBG = color(221, 218, 210);
  background(colorBG);
  
  minim = new Minim(this);
  sound = minim.loadFile("TheThingDoesNotExist.mp3");
  sound.play();
}

void draw(){
  float a = mouseX - width/2;
  float b = mouseY - height/2;
  float rad = sqrt(a * a + b * b);
  if(rad > 40){
    rad = 40;
  }
  
  float angle = atan2(b, a);
  
  int buffSize = sound.bufferSize();
  int soundIntensity = 40;
  
  noStroke();
  fill(colorBG, 100);
  rect(0, 0, width, height);
  
  translate(width/2, height/2);
  strokeWeight(4);
  stroke(56, 55, 53);
  noFill();
  float waveNum = 0; 
  waveNum += round(map(mouseX, 0, width, 3, 18));
  waveNum += round(map(mouseY, 0, height, 3, 18));
  
  pushMatrix();
  rotate(angle);
  for(int i = 0; i <= int(waveNum); i++){
    rotate(radians(360/waveNum));
    beginShape();
    float circDist = 10;
    for(int j = 100; j < buffSize/2 + 100; j++){
      float offset = 0;
      float intensity = height/3;
      vertex(j, offset + sound.left.get(j) * intensity);
      if(j % 10 == 0){
        float circSize = map(j, 100, buffSize/2 + 100, 10, 100);
        pushMatrix();
        rotate(radians(180/waveNum));
        ellipse(j + circDist, offset + sound.left.get(j) * circSize * 15, circSize, circSize);
        popMatrix();
        circDist += circSize;
      }
    }
    endShape();
  }
  popMatrix();
  
  fill(colorBG);
  noStroke();
  fill(242, 242, 234);
  drawSoundCircle(0, buffSize/4, 80, soundIntensity);
  
  pushMatrix();
  
  rotate(angle);
  translate(rad, 0);
  
  stroke(120, 118, 114);
  strokeWeight(4);
  fill(183, 180, 173);
  drawSoundCircle(buffSize/4, buffSize/2, 40, soundIntensity);
  stroke(56, 55, 53);
  strokeWeight(3);
  fill(color(120, 118, 114));
  drawSoundCircle(buffSize/2, buffSize/4 *3, 30 - (rad / 4), soundIntensity);
  
  popMatrix();
  
  pushMatrix();
  
  rotate(PI);
  drawEyelid(buffSize, color(56, 55, 53), blinkFrame + 0.1, soundIntensity);
  
  popMatrix();
  
  drawEyelid(buffSize, color(56, 55, 53), blinkFrame, soundIntensity);
  
  stroke(56, 55, 53);
  noFill();
  strokeWeight(3);
  
  strokeWeight(4);
  stroke(56, 55, 53);
  noFill();
  pushMatrix();
  rotate(angle);
  for(int i = 0; i < waveNum; i++){
    rotate(radians(360/waveNum));
    ellipse(100, sound.left.get(100) * height/3, 5 + sound.left.get(100) * 10, 5 + sound.left.get(100) * 10);
  }
  popMatrix();
  
  if(blinkFrame > 1){
    blinkDir = -1;
  } else if(blinkFrame < 0.2 && blinkDir == -1){
    blinkDir = 1;
    finishedBlink = true;
  }
  
  if(!finishedBlink){
    blinkFrame += blinkChange * blinkDir;
  }
  
  if(millis() % 6000 < 600){
    finishedBlink = false;
  }
  
  /*if(keyPressed && recording){
    recording = false;
    sound.play();
    println("playing sound");
  }*/
}

void drawSoundCircle(int minX, int maxX, float radius, float intensity){
  beginShape();
  for(int i = minX; i < maxX; i++){
    float theta = map(i, minX, maxX, -PI, PI);
    float x;
    float y;
    x = (radius + sound.left.get(i) * intensity) * cos(theta);
    y = (radius + sound.left.get(i) * intensity) * sin(theta);
    vertex(x, y);
  }
  endShape(CLOSE);
}

void drawEyelid(int buffSize, color col, float _lerpAmnt, int intensity){
  fill(colorBG);
  noStroke();
  beginShape();
  vertex(88, 0);
  for(int i = 80; i > -80; i -= 4){
    float theta = map(i, -80, 80, -PI, 0);
    float x = 90 * cos(theta);
    float y = 90 * sin(theta);
    vertex(x, y);
  }
  vertex(-88, 0);
  for(int i = -80; i < 80; i += 2){
    float theta = map(i, -80, 80, -PI, 0);
    float soundDistort = (sound.left.get(i + buffSize/4 * 3) * intensity);
    float x1 = (soundDistort + 80) * cos(theta);
    float y1 = (soundDistort + 80) * sin(theta);
    float x2 = i;
    float y2 = soundDistort;
    float lerpAmnt = _lerpAmnt;
    float x = lerp(x1, x2, lerpAmnt);
    float y = lerp(y1, y2, lerpAmnt);
    vertex(x, y);
  }
  endShape();
  
  noFill();
  stroke(col);
  strokeWeight(6);
  beginShape();
  vertex(-88, 0);
  for(int i = -80; i < 80; i += 2){
    float theta = map(i, -80, 80, -PI, 0);
    float soundDistort = (sound.left.get(i + buffSize/4 * 3) * intensity);
    float x1 = (soundDistort + 80) * cos(theta);
    float y1 = (soundDistort + 80) * sin(theta);
    float x2 = i;
    float y2 = soundDistort;
    float lerpAmnt = _lerpAmnt;
    float x = lerp(x1, x2, lerpAmnt);
    float y = lerp(y1, y2, lerpAmnt);
    vertex(x, y);
  }
  vertex(88, 0);
  endShape();
}