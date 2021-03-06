import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fftLog;

int maxWaves = 20;
int lastWaveIndex = 0;
Wave[] waves;
float[][] points;
int pointsWidth = 4*24;
int pointsHeight = 3*24;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
Blob[] blobs;

int status = 0; 

int NextWaveIndex(){
  lastWaveIndex = (lastWaveIndex + 1 >= maxWaves) ? 0 : lastWaveIndex + 1;
  return lastWaveIndex;
}
void setup() {
  
  size(1024,768,P3D);
  frameRate(60);
  
  minim = new Minim(this);
  in = minim.getLineIn();
  fftLog = new FFT(in.bufferSize(),in.sampleRate());
  fftLog.logAverages( 22, 3 );
  
  points = new float[pointsWidth][pointsHeight];
  for(int i = 0; i < pointsWidth; i++)
    for(int j = 0; j < pointsHeight; j++)
      points[i][j] = 0;
  
  waves = new Wave[maxWaves];
  for(int i = 0; i < maxWaves; i++){
    waves[i] = new Wave();
  }
  
  oscP5 = new OscP5(this,10001);
  myRemoteLocation = new NetAddress("127.0.0.1",10001);
  server = new SyphonServer(this, "Processing Syphon");
  
  blobs = new Blob[10];
  for(int i = 0; i < blobs.length; i++)
    blobs[i] = new Blob(i,0,new PVector(0,0,0),false);

}

float perspX = width/2, perspY = height/2;
int drawPointsW = 18;

int frame = 0;
float w = 140;
float h = w*5f;
void draw() {
  background(0);
  smooth();
  if(status == 0){
    perspX = lerp(perspX,0,2/60f);
    perspY = lerp(perspY,0,1/60f);
    drawPointsW = 18;
  } else if(status == 1){
    perspX = lerp(perspX,-width,1/60f);
    perspY = lerp(perspY,height*.1f,2/60f);
    drawPointsW = 18;
  }
  
  camera(width/2,height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  ortho(-80, width+80, -80, height+80); 
  float yRotation = (perspX/(float)width)*PI/4;
  float xRotation = (perspY/(float)height)*PI/4;
  rotateY(yRotation);
  rotateX(xRotation);
  translate(width/2, height/2, -100);
  
  DrawEllipses(drawPointsW);
  if(status == 2){
    RefreshWaves();
  }
  
  
  translate(-width/2, -height/2, -100);
  rotateX(-xRotation);
  rotateY(-yRotation);
  
  server.sendScreen();
  frame++;
}

void RefreshWaves(){
  for(int i = 0; i < maxWaves; i++)
    waves[i].Refresh();
}

void DrawEllipses(int drawPointsWidth){
  noStroke();
  fill(255);
  for(int x = pointsWidth/2 - drawPointsWidth/2;x < pointsWidth/2 + drawPointsWidth/2; x++){
    for(int y = 0;y < pointsHeight; y++){
      float xPoint = (x-(pointsWidth/2))*10;
      float yPoint = (y-(pointsHeight/2))*10;
      
      //Get max press from distance between 3D point and blob
      float maxPress = -1;
      int maxBlobIndex = -1;
      for(int i = 0; i < 10; i++){
        if (blobs[i].isActive){
          float d = DistanceFromBlob(xPoint,yPoint,i);
          float pf = PressFunction(d,100*blobs[i].position.z,100*blobs[i].position.z);
          if(pf > maxPress){
            maxBlobIndex = i;
            maxPress = pf; 
          }
        } 
      }
      
      
      float minDistanceWaves = MinDistanceWaves(xPoint,yPoint);
      
      float zTranslatePress = (maxBlobIndex != -1) ? -maxPress : 0;
      float zTranslateCurve = -pow((y-35)*.2f,2f);
      float zTranslateWave = -PressFunction(minDistanceWaves,1,30)*20f;
      float zTranslateTotal = zTranslatePress+zTranslateCurve + zTranslateWave;
      
      float rWaves = PressFunction(minDistanceWaves,1,30);
      float rTotal = rWaves + (-.1f*zTranslatePress)*.2f;
     /* if(zTranslateWaves != 0 && zTranslatePress != 0 && zTranslateWaves != 9999999){
        println("press "+zTranslatePress); 
        println("waves "+zTranslateWaves);
      }*/
      translate(0,0,zTranslateTotal);
      if(status == 2){
         
        fill(255,255,255);
      } else {
        float rPress = -zTranslatePress/60f;
        fill(255-220*rPress,255-204*rPress,255-45*rPress);
      }
      ellipse((x-(pointsWidth/2))*10,(y-(pointsHeight/2))*10,7-2*rTotal,7-2*rTotal);
      translate(0,0,-zTranslateTotal);
    }
  }
}
float MinDistanceWaves(float x1, float y1){
  float min = 9999999;
  for(int i = 0; i < maxWaves; i++){
    if(waves[i].isActive){
      float dPointCenter = distance(new PVector(x1,y1),waves[i].center);
      float deltaR = abs(dPointCenter - waves[i].r);
      if(deltaR < min){
        min = deltaR;
      }
      
    }
  }
  return min;
}

float distance(PVector a, PVector b){
    return sqrt(pow(b.x - a.x,2) + pow(b.y - a.y,2) + pow(b.z - a.z,2));
  }

float PressFunction(float d,float maxPress, float maxRatio){
  if(d < 0 || d > maxRatio){
    return 0;
  } else {
    return maxPress*.5f + maxPress*.5f*sin( (PI/maxRatio)*(maxRatio*.5f + d) );
  } 
}

float DistanceFromBlob(float x1, float y1, int blobID){
  if (blobs[blobID].isActive){
    float x2 = blobs[blobID].position.x*w -w/2;
    float y2 = blobs[blobID].position.y*h -h/2;
    float z2 = blobs[blobID].position.z*100f;
    return sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
  } else {
    return 999999;
  }
}

void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.addrPattern());
  //print(" "+theOscMessage.typetag());
  
  if(theOscMessage.checkAddrPattern("/updateBlob")){
    if(theOscMessage.checkTypetag("ifffi") || theOscMessage.checkTypetag("iffff") || theOscMessage.checkTypetag("ifff")){
      int fingerID = theOscMessage.get(0).intValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      float z = theOscMessage.get(3).floatValue();
      //int area = theOscMessage.get(4).intValue();
      blobs[fingerID].isActive = true;
      if(theOscMessage.checkTypetag("ifff")){
        blobs[fingerID].setPosition(new PVector(x/200f, y/(54f*20f), z/9000f),waves[NextWaveIndex()]);
      } else {
        blobs[fingerID].setPosition(new PVector(x,y,z),waves[NextWaveIndex()]);
      }
      //blobs[fingerID].area = area;
    }
  } else if(theOscMessage.checkAddrPattern("/removeBlob")){
    if(theOscMessage.checkTypetag("i")){
      int fingerID = theOscMessage.get(0).intValue();
      blobs[fingerID].isActive = false;
    }
  }
  
}

void keyPressed() {
  println(key);
  if (key == '0') {
    status = 0;
  } else if(key == '1') {
    status = 1;
  } else if(key == '2'){
    status = 2;
  } else if(key == '3'){
    status = 3;
  } else if(key == '4'){
    status = 4;
  }
}

