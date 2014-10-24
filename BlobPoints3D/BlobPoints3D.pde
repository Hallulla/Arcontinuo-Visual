import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fftLog;


float[][] points;
int pointsWidth = 4*24;
int pointsHeight = 3*24;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
Blob[] blobs;



void setup() {
  size(1024,768,P3D);
  minim = new Minim(this);
  in = minim.getLineIn();
  fftLog = new FFT(in.bufferSize(),in.sampleRate());
  fftLog.logAverages( 22, 3 );
  
  points = new float[pointsWidth][pointsHeight];
  for(int i = 0; i < pointsWidth; i++)
    for(int j = 0; j < pointsHeight; j++)
      points[i][j] = 0;
  
  frameRate(60);
  
  oscP5 = new OscP5(this,10001);
  myRemoteLocation = new NetAddress("127.0.0.1",10001);

  
  server = new SyphonServer(this, "Processing Syphon");
  
  
  blobs = new Blob[10];
  for(int i = 0; i < blobs.length; i++)
    blobs[i] = new Blob(i,0,new PVector(0,0,0),false);

}
int frame = 0;
void draw() {
  background(0);
  camera(mouseX,mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100);
  float w = 140;
  float h = w*5f;
  DrawFullEllipses(w,h);
  translate(-width/2, -height/2, -100);
  server.sendScreen();
  frame++;
}

void DrawFullEllipses(float w, float h){
  /*
  for (int i = 0; i < 10; i++) {
    if (blobs[i].isActive) {
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(4);
      float x = blobs[i].position.x*w -w/2;
      float y = blobs[i].position.y*h -h/2;
      float r = blobs[i].position.z*100f;
      ellipse(x, y, r, r);
      textSize(16);
      fill(255);
      text((i+1), x+r*.5f, y+r*.7f);
    }
  }*/
  
  noStroke();
  fill(255);
  for(int x = 0;x < pointsWidth; x++){
    for(int y = 0;y < pointsHeight; y++){
      float xPoint = (x-(pointsWidth/2))*10;
      float yPoint = (y-(pointsHeight/2))*10;
      
      //Get max press from distance between 3D point and blob
      float maxPress = -1;
      int maxBlobIndex = -1;
      for(int i = 0; i < 10; i++){
        if (blobs[i].isActive){
          float d = DistanceFromBlob(xPoint,yPoint,i,w,h);
          float pf = PressFunction(d,100*blobs[i].position.z,100*blobs[i].position.z);
          if(pf > maxPress){
            maxBlobIndex = i;
            maxPress = pf; 
          }
        }
      }
      
      float zTranslate = (maxBlobIndex != -1) ? -maxPress : 0;
      
      
      translate(0,0,zTranslate);
      ellipse((x-(pointsWidth/2))*10,(y-(pointsHeight/2))*10,3,3);
      translate(0,0,-zTranslate);
    }
  }
}

float PressFunction(float d,float maxPress, float maxRatio){
  if(d < 0 || d > maxRatio){
    return 0;
  } else {
    return maxPress*.5f + maxPress*.5f*sin( (PI/maxRatio)*(maxRatio*.5f + d) );
  } 
}

float DistanceFromBlob(float x1, float y1, int blobID, float w, float h){
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
    if(theOscMessage.checkTypetag("ifffi")){
      
      int fingerID = theOscMessage.get(0).intValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      float z = theOscMessage.get(3).floatValue();
      int area = theOscMessage.get(4).intValue();
      blobs[fingerID].isActive = true;
      blobs[fingerID].position = new PVector(x,y,z);
      blobs[fingerID].area = area;
      //println(" "+fingerID+" ("+x+","+y+","+z+") "+area);
    }
  } else if(theOscMessage.checkAddrPattern("/addBlob")){
    if(theOscMessage.checkTypetag("i")){
      int fingerID = theOscMessage.get(0).intValue();
      blobs[fingerID].isActive = true;
    }
  } else if(theOscMessage.checkAddrPattern("/removeBlob")){
    if(theOscMessage.checkTypetag("i")){
      int fingerID = theOscMessage.get(0).intValue();
      blobs[fingerID].isActive = false;
    }
  }
  
}

