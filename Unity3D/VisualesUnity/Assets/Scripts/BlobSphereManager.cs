using UnityEngine;
using System.Collections;

public class BlobSphereManager : MonoBehaviour {
	public GameObject blobSphere;
	BlobSphere[] blobSpheres;
	void Start () {
		blobSpheres = new BlobSphere[11];
		for(int i = 0; i < 11; i++){
			GameObject newBlobSphere = Instantiate(blobSphere) as GameObject;
			newBlobSphere.GetComponent<BlobSphere>().blobID = i;
			newBlobSphere.transform.parent = transform;
			blobSpheres[i] = newBlobSphere.GetComponent<BlobSphere>();
		}
	}
	void Update(){
		if(OSCListener.updateBlobMessage != null && (float)OSCListener.updateBlobMessage.Values[3] > 0){
			int blobID = (int)OSCListener.updateBlobMessage.Values[0];
			blobSpheres[blobID].on = true;
		}
		if(OSCListener.removeBlobMessage != null){
			int removeBlobID = (int)OSCListener.removeBlobMessage.Values[0];
			blobSpheres[removeBlobID].on = false;
		}
		
	}

}
