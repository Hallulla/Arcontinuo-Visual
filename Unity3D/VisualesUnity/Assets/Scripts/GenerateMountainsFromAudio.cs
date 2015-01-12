using UnityEngine;
using System.Collections;

public class GenerateMountainsFromAudio : MonoBehaviour {
	public float maxX;
	public float minX;
	public GameObject mountainGeneratorPrefab;
	[SerializeField] MicManager micManager;
	VectorGridForce[] VGForces;
	VectorGrid vg;
	float[] logSpect;
	float[] logSpectDiff;
	[Range(1,6)]
	[SerializeField] float amp;

	int maxIndex;


	float m_positionAmp = 1;



	public float positionAmp = 1;
			

	void Awake(){
		VGForces = new VectorGridForce[10];
		logSpect = new float[64];
		logSpectDiff = new float[64];
		vg = GameObject.FindGameObjectWithTag("VectorGrid").GetComponent<VectorGrid>();
	}
	void Start () {

		for(int i = 0; i < 10; i++){
			VGForces[i] = (Instantiate(mountainGeneratorPrefab) as GameObject).GetComponent<VectorGridForce>();
			VGForces[i].gameObject.transform.position = new Vector3(Mathf.Lerp(minX,maxX,(float)i/10f),0,65.15071f);
			VGForces[i].gameObject.transform.parent = transform;
			VGForces[i].m_VectorGrid = vg;
			VGForces[i].m_ForceScale = 0;
		}
	}

	void UpdateSpherePosition(){
		for(int i = 0; i < 10; i++){
			VGForces[i].gameObject.transform.position = new Vector3(Mathf.Lerp(minX,maxX*positionAmp,(float)i/10f),0,65.15071f);
		}

	}
	void FixedUpdate(){
		UpdateSpherePosition();

		maxIndex = -1;
		float maxVal = -999f;
		for(int i = 1; i < 63; i++) {
			//Debug.DrawLine(new Vector3(i - 1, micManager.spectrum[i] + 10, 0), new Vector3(i, micManager.spectrum[i + 1] + 10, 0), Color.red);

			logSpectDiff[i] = logSpect[i] - Mathf.Log(micManager.spectrum[i],10) + 10;
			logSpect[i] = Mathf.Log(micManager.spectrum[i],10) + 10;
			logSpect[i] *= amp;
			if(logSpectDiff[i] > maxVal){
				maxVal = logSpectDiff[i];
				maxIndex = i;
			}
			Debug.DrawLine(new Vector3(i - 1,logSpectDiff[i-1], 2), new Vector3(i, logSpectDiff[i], 2), Color.cyan);
			//Debug.DrawLine(new Vector3(Mathf.Log(i - 1), micManager.spectrum[i - 1] - 10, 1), new Vector3(Mathf.Log(i), micManager.spectrum[i] - 10, 1), Color.green);
			//Debug.DrawLine(new Vector3(Mathf.Log(i - 1), Mathf.Log(micManager.spectrum[i - 1]), 3), new Vector3(Mathf.Log(i), Mathf.Log(micManager.spectrum[i]), 3), Color.yellow);
		}


	
		int mountainIndex = (int)Mathf.Round((float)maxIndex/10f);
		for(int i = 0; i < 10; i++){
			if(i == mountainIndex)
				VGForces[i].m_ForceScale = 1f;
			else
				VGForces[i].m_ForceScale = 0;
		}
	}
	

}
