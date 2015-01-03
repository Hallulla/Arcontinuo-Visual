using UnityEngine;
using System.Collections;

public class BlobSphere : MonoBehaviour {
	public int blobID = 0;
	public bool on = false;
	public Color topColor;
	public Color bottomColor;

	Vector3 targetPosition;
	Vector3 targetScale;

	Color targetColor;
	Transform myTransform;
	Renderer myRenderer;

	VectorGridForce vectorGridForce;
	void Awake(){
		myTransform = transform;
		myRenderer = renderer;
		vectorGridForce = GetComponent<VectorGridForce>();
		vectorGridForce.m_VectorGrid = GameObject.FindGameObjectWithTag("VectorGrid").GetComponent<VectorGrid>();
	}

	void Update(){

		if(on && StageManager.currentStage > 0){
			if(OSCListener.updateBlobMessage != null){
				if(StageManager.currentStage == 2)
					vectorGridForce.enabled = true;
				else
					vectorGridForce.enabled = false;

				float oscBlobID = (int)OSCListener.updateBlobMessage.Values[0];
				if(oscBlobID == blobID){
					float x = (float)OSCListener.updateBlobMessage.Values[1];
					float y = (float)OSCListener.updateBlobMessage.Values[2];
					float z = (float)OSCListener.updateBlobMessage.Values[3];
//					print(x+","+y+","+z);
					targetPosition = new Vector3(.9f*(-1f+2f*x),-.7f*(-1f+2f*y),.1f);
					targetScale = Vector3.one*.15f*z;
					targetColor = Color.Lerp(bottomColor,topColor,1-y);
				}
			}
		} else {
			vectorGridForce.enabled = false;
			targetPosition = myTransform.position;
			targetScale = Vector3.zero;
			targetColor = myRenderer.material.color;
		}

		myTransform.position = Vector3.Lerp(myTransform.position,targetPosition,15f*Time.deltaTime);
		myTransform.localScale = Vector3.Lerp(myTransform.localScale,targetScale,15f*Time.deltaTime);
		myRenderer.material.color = Color.Lerp(myRenderer.material.color,targetColor,15*Time.deltaTime);

	}
}
