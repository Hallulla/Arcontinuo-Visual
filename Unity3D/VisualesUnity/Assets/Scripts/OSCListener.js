private var UDPHost : String = "127.0.0.1";
private var listenerPort : int = 10001;
private var broadcastPort : int = 10001;
private var oscHandler : Osc;

private var eventName : String = "";
private var eventData : String = "";
private var counter : int = 0;
public var output_txt : GUIText;


public function Start ()
{	
	var udp : UDPPacketIO = GetComponent("UDPPacketIO");
	udp.init(UDPHost, broadcastPort, listenerPort);
	oscHandler = GetComponent("Osc");
	oscHandler.init(udp);
			
	oscHandler.SetAddressHandler("/updateBlob", updateText);
	
}
Debug.Log("Running");

function Update () {
	output_txt.text = "Event: " + eventName + " Event data: " + eventData;
	
	var cube = GameObject.Find("Cube");
	var boxWidth:int = counter;
    cube.transform.localScale = Vector3(boxWidth,5,5);	
}	

public function updateText(oscMessage : OscMessage) : void
{	
	eventName = Osc.OscMessageToString(oscMessage);
	eventData = oscMessage.Values[0];
} 