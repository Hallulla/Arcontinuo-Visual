import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fftLog;


float[][] points;
int pointsWidth = 4*20;
int pointsHeight = 3*20;

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
  noStroke();
  fill(255);
  ShiftPoints();
  FillFirstColumnWithVolume();
  DrawEllipsesFromVolume();
  server.sendScreen();
  frame++;
}
void FillFirstColumnWithVolume(){
  fftLog.forward( in.mix );
  for(int y = 0;y < fftLog.avgSize(); y++){
    
    points[0][2*y] = fftLog.getAvg(y);
    points[0][2*y+1] = fftLog.getAvg(y);
  }
}
void ShiftPoints(){
  for(int x = pointsWidth-1;x > 0; x--)
    for(int y = 0;y < pointsHeight; y++)
      points[x][y] = points[x-1][y];
}
void DrawEllipsesFromVolume(){
  for(int x = 0;x < pointsWidth; x++){
    for(int y = 0;y < pointsHeight; y++){
      float zTranslate = points[x][y]*20;
      translate(0,0,zTranslate);
      ellipse((x-(pointsWidth/2))*10,(y-(pointsHeight/2))*10,3,3);
      translate(0,0,-zTranslate);
    }
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

