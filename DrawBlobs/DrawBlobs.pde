
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
Blob[] blobs;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);
  oscP5 = new OscP5(this, 10001);
  myRemoteLocation = new NetAddress("127.0.0.1", 10001);
  PFont font = loadFont("Menlo-Regular-11.vlw"); 
  textFont(font,20);
  server = new SyphonServer(this, "Processing Syphon");


  blobs = new Blob[10];
  for (int i = 0; i < blobs.length; i++)
    blobs[i] = new Blob(i, 0, new PVector(0, 0, 0), false);
}
void DrawRectangle(float w, float h) {
  strokeWeight(2);
  stroke(255);
  fill(0);
  translate(width/2, height/2);
  rect(-w/2, -h/2, w, h);
  translate(-width/2, -height/2);
}
void DrawCircles(float w, float h) {
  translate(width/2 - w/2, height/2 - h/2);
  for (int i = 0; i < 10; i++) {
    if (blobs[i].isActive) {
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(2);
      println("x"+blobs[i].position.x+" y"+blobs[i].position.y+" z"+blobs[i].position.z);
      float x = blobs[i].position.x*w;
      float y = blobs[i].position.y*h;
      float r = blobs[i].position.z*100f;
      
      
      ellipse(x, y, r, r);
      textSize(11);
      fill(255);
      text((i), x+r*.5f, y+r*.7f);
    }
  }
  translate(-(width/2 - w/2), -(height/2 - h/2));
}
void draw() {
  background(0);
  smooth();
  float w = 140;
  float h = w*5f;
  DrawRectangle(w, h);
  DrawCircles(w, h);
  server.sendScreen();
}


void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.addrPattern());
  //println(" "+theOscMessage.typetag());

  if (theOscMessage.checkAddrPattern("/updateBlob")) {
    if (theOscMessage.checkTypetag("ifffi") || theOscMessage.checkTypetag("ifff")) {

      int fingerID = theOscMessage.get(0).intValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      float z = theOscMessage.get(3).floatValue();
      if(z > 0){
      //int area = theOscMessage.get(3).intValue();
        blobs[fingerID].isActive = true;
        blobs[fingerID].position = new PVector(x/200f, y/(54f*20f), z/9000f);
        blobs[fingerID].area = 1;
      } else {
        blobs[fingerID].isActive = false;
      }
      //println(" "+fingerID+" ("+x+","+y+","+z+") "+area);
    }
  } else if (theOscMessage.checkAddrPattern("/addBlob")) {
    if (theOscMessage.checkTypetag("i")) {
      int fingerID = theOscMessage.get(0).intValue();
      blobs[fingerID].isActive = true;
    }
  } else if (theOscMessage.checkAddrPattern("/removeBlob")) {
    if (theOscMessage.checkTypetag("i")) {
      int fingerID = theOscMessage.get(0).intValue();
      blobs[fingerID].isActive = false;
    }
  }
}

