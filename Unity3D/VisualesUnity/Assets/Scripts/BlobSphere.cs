using UnityEngine;
using System.Collections;

public class BlobSphere : MonoBehaviour {
	public bool simulator = false;
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
	VectorGrid vectorGrid;
	void Awake(){
		myTransform = transform;
		myRenderer = renderer;
		vectorGridForce = GetComponent<VectorGridForce>();
		vectorGrid = GameObject.FindGameObjectWithTag("VectorGrid").GetComponent<VectorGrid>();
		vectorGridForce.m_VectorGrid = vectorGrid;
	}

	void Update(){

		if(on && StageManager.currentStage > 0){
			if(StageManager.currentStage == 3){
				vectorGridForce.enabled = false;
				vectorGrid.AddGridForce(new Vector3(myTransform.position.x,myTransform.position.y,0),.3f,.3f,Color.white,false);
			}
				if(OSCListener.updateBlobMessage != null){
				if(StageManager.currentStage == 2){
					vectorGridForce.enabled = true;
					vectorGridForce.m_ForceScale = 1;
				} else if(StageManager.currentStage == 3){

				} else {
					vectorGridForce.m_ForceScale = 1;
					vectorGridForce.enabled = false;
				}
					

				float oscBlobID = (int)OSCListener.updateBlobMessage.Values[0];
				if(oscBlobID == blobID){
					float x,y,z;
					if(simulator){
						x = (float)OSCListener.updateBlobMessage.Values[1];
						y = (float)OSCListener.updateBlobMessage.Values[2];
						z = (float)OSCListener.updateBlobMessage.Values[3];
					} else {
						x = (float)OSCListener.updateBlobMessage.Values[1]/200f;
						y = (float)OSCListener.updateBlobMessage.Values[2]/(54f*20f);
						z = (float)OSCListener.updateBlobMessage.Values[3]/10000f;
					}


					


					if(z > 0){
//						print(x+","+y+","+z);
						targetPosition = new Vector3(.9f*(-1f+2f*x),-.7f*(-1f+2f*y),.1f);
						targetScale = Vector3.one*.15f*z;
						targetColor = Color.Lerp(bottomColor,topColor,1-y);
					} else {
						targetPosition = myTransform.position;
						targetScale = Vector3.zero;
						targetColor = myRenderer.material.color;
						vectorGridForce.enabled = false;
					}
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
