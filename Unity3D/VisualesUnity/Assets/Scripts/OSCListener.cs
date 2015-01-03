using UnityEngine;
using System.Collections;

public class OSCListener : MonoBehaviour {
	public static OSCListener instance;
	public string UDPHost = "127.0.0.1";
	public int listenerPort = 10001;
	public int broadcastPort = 10001;

	Osc oscHandler;
	public static OscMessage updateBlobMessage = null;
	public static OscMessage removeBlobMessage = null;
	bool newUpdateBlobMessageFrame = false;
	bool newRemoveBlobMessageFrame = false;
	OscMessage newUpdateBlobMessage = null;
	OscMessage newRemoveBlobMessage = null;
	void Awake(){
		instance = this;

	}
	void Start () {
		UDPPacketIO udp = GetComponent<UDPPacketIO>();
		udp.init(UDPHost,broadcastPort,listenerPort);
		oscHandler = GetComponent<Osc>();
		oscHandler.init(udp);
		oscHandler.SetAddressHandler("/updateBlob",UpdateBlob);
		oscHandler.SetAddressHandler("/removeBlob",RemoveBlob);

	}

	void Update(){
		if(newUpdateBlobMessageFrame){
			OSCListener.updateBlobMessage = newUpdateBlobMessage;
			newUpdateBlobMessageFrame = false;
		} else {
			OSCListener.updateBlobMessage = null;
		}

		if(newRemoveBlobMessageFrame){
			OSCListener.removeBlobMessage = newRemoveBlobMessage;
			newRemoveBlobMessageFrame = false;
		} else {
			OSCListener.removeBlobMessage = null;
		}

	}
	void UpdateBlob(OscMessage message){
		newUpdateBlobMessageFrame = true;
		newUpdateBlobMessage = message;
	}
	void RemoveBlob(OscMessage message){
		newRemoveBlobMessageFrame = true;
		OSCListener.removeBlobMessage = message;
	}
}
