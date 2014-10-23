
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
  for (int i = 0; i < 10; i++) {
    if (blobs[i].isActive) {
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(4);
      float x = blobs[i].position.x*w;
      float y = blobs[i].position.y*h;
      float r = blobs[i].position.z*100f;
      ellipse(x, y, r, r);
      textSize(16);
      fill(255);
      text((i+1), x+r*.5f, y+r*.7f);
    }
  }
}
void draw() {
  background(0);
  float w = 140;
  float h = w*5f;
  DrawRectangle(w, h);
  translate(width/2 - w/2, height/2 - h/2);
  DrawCircles(w, h);
  translate(-(width/2 - w/2), -(height/2 - h/2));

  server.sendScreen();
}


void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.addrPattern());
  //print(" "+theOscMessage.typetag());

  if (theOscMessage.checkAddrPattern("/updateBlob")) {
    if (theOscMessage.checkTypetag("ifffi")) {

      int fingerID = theOscMessage.get(0).intValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      float z = theOscMessage.get(3).floatValue();
      int area = theOscMessage.get(4).intValue();
      blobs[fingerID].isActive = true;
      blobs[fingerID].position = new PVector(x, y, z);
      blobs[fingerID].area = area;
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

