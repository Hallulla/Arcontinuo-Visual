import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400,400, P3D);
  frameRate(60);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,10001);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",10001);
  server = new SyphonServer(this, "Processing Syphon");

}
boolean messageReceived = false;

void draw() {
  background(0);  
  if(messageReceived){
    fill(255);
    ellipse(200,200,100,100);
    messageReceived = false;
  }
  server.sendScreen();
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/test");
  
  //myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  //oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  print(theOscMessage.addrPattern());
  println(" "+theOscMessage.typetag());
  messageReceived = true;
  
}
