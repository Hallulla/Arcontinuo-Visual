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





	public float positionAmp = 1;
	public SaveFLoats noise;

	void Awake(){
		VGForces = new VectorGridForce[10];
		logSpect = new float[64];
		logSpectDiff = new float[64];
		vg = GameObject.FindGameObjectWithTag("VectorGrid").GetComponent<VectorGrid>();

	}
	void Start () {

		for(int i = 0; i < 10; i++){
			VGForces[i] = (Instantiate(mountainGeneratorPrefab) as GameObject).GetComponent<VectorGridForce>();
			VGForces[i].gameObject.transform.position = new Vector3(Mathf.Lerp(minX,maxX,(float)(10-i)/10f),0,65.15071f);
			VGForces[i].gameObject.transform.parent = transform;
			VGForces[i].m_VectorGrid = vg;
			VGForces[i].m_ForceScale = 0;
		}
	}

	void UpdateSpherePosition(){
		for(int i = 0; i < 10; i++){
			VGForces[i].gameObject.transform.position = new Vector3(Mathf.Lerp(minX,maxX*positionAmp,(float)(10-i)/10f),0,65.15071f);
		}

	}
	public float[] logBand;
	void FixedUpdate(){
		UpdateSpherePosition();
		int logBandLength = 10;
		logBand = new float[logBandLength];

		for(int i = 0; i < logBandLength; i++){

			logBand[i] = (micManager.spectrum[i] > .00001f) ? Mathf.Pow(micManager.spectrum[i],1/12f) : 0;
			VGForces[i].m_ForceScale = logBand[i];
		}


//		string s = "";
//		int i = 0;
//		for(int p = 0; p < logBandLength; p++){
//			logBand[p] = 0;
//			s += p+": ";
//			for(int band=0; band < 1+p; band++){
//				logBand[p] += (Mathf.Log(micManager.spectrum[i]+10)-2)*amp - logBand[p];
//				s+=  (Mathf.Log(micManager.spectrum[i]+10)-2)*amp-logBand[p]+" ";
//				i++;
//			}
//			s+='\n';
//		}
//		
//		print (s);



//		for(i = 0; i < micManager.spectrum.Length-1; i++){
//			Debug.DrawLine(new Vector3(i - 1, micManager.spectrum[i]*amp + 10, 0), new Vector3(i, micManager.spectrum[i + 1]*amp + 10, 0), Color.green);
//		}
		for(int i = 0; i < logBandLength-1; i++){
			Debug.DrawLine(new Vector3(i - 1, logBand[i], 0), new Vector3(i, logBand[i + 1], 0), Color.green);
		}
//		for(i = 0; i < 15; i++){
//			Debug.DrawLine(new Vector3((i - 1)*10, micManager.spectrum[i]*amp + 10, 0), new Vector3(i*10, micManager.spectrum[i + 1]*amp + 10, 0), Color.cyan);
//		}

//
//		maxIndex = -1;
//		float maxVal = -999f;
//		for(int i = fromIndex; i < 63; i++) {
//			//Debug.DrawLine(new Vector3(i - 1, micManager.spectrum[i] + 10, 0), new Vector3(i, micManager.spectrum[i + 1] + 10, 0), Color.red);
//
//
//			logSpect[i] = Mathf.Log(micManager.spectrum[i]) + 10 - noise.floats[i];
//			logSpect[i] *= amp;
//			if(logSpect[i] > maxVal){
//				maxVal = logSpect[i];
//				maxIndex = i;
//			}
//			Debug.DrawLine(new Vector3(i - 1,logSpect[i-1], 2), new Vector3(i, logSpect[i], 2), Color.cyan);
//			Debug.DrawLine(new Vector3(Mathf.Log(i - 1)*graphicAmp, micManager.spectrum[i - 1]*10 - 10, 1), new Vector3(Mathf.Log(i)*graphicAmp, micManager.spectrum[i]*10 - 10, 1), Color.green);
//			Debug.DrawLine(new Vector3(Mathf.Log(i - 1)*graphicAmp, Mathf.Log(micManager.spectrum[i - 1]), 3), new Vector3(Mathf.Log(i)*graphicAmp, Mathf.Log(micManager.spectrum[i]), 3), Color.yellow);
//		}
//
//
//	
//		int bandsPerIndex = 63/10;
//		string a = "";
//		float max = -1;
//		float[] sphereVol = new float[10];
//		for(int i = 0; i < 10; i++){
//
//			float bandsVolume = 0;
//			for(int j = 0; j < bandsPerIndex;j++){
//				bandsVolume += logSpect[(bandsPerIndex*i+j)];
//			}
//			sphereVol[i] = bandsVolume;
//			if(max < bandsVolume){
//				max = bandsVolume;
//			}
//		}
//
//		if(max > 0){
//			for(int i = 0; i < sphereVol.Length; i++){
//				if(sphereVol[i] > .01f){
//					sphereVol[i] /= max;
//					VGForces[i].m_ForceScale =  Mathf.Pow(sphereVol[i],5);
//				} else {
//					VGForces[i].m_ForceScale = 0;
//				}
//			}
//		}
//

	}

	

}
