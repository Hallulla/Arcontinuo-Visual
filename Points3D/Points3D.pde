
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
Blob[] blobs;

void setup() {

  size(1024,768,P3D);


  frameRate(60);
  oscP5 = new OscP5(this,10001);
  myRemoteLocation = new NetAddress("127.0.0.1",10001);

  
  server = new SyphonServer(this, "Processing Syphon");
  
  
  blobs = new Blob[10];
  for(int i = 0; i < blobs.length; i++)
    blobs[i] = new Blob(i,0,new PVector(0,0,0),false);

}

void draw() {
  background(0);
  camera(mouseX,mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100);
  stroke(255);
  
  
  for(int y=0;y <45;y++){
    for(int x=0;x <60;x++){
      ellipse((x-30)*15,(y-23)*15,3,3);
    }
  }
  
  
  //perspective(radians(45),float(width)/float(height),10,5000);
  
  
  //box(200);
  
  server.sendScreen();
  
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

