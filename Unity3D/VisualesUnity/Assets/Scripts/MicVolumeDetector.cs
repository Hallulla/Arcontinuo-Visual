using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class MicVolumeDetector : MonoBehaviour {
	
    void Start() {
        audio.clip = Microphone.Start("Built-in Microphone", true,1, 44100);
        audio.Play();
    }
	// Update is called once per frame
	void Update () {
		int dec = 128;
		
		float[] waveData = new float[dec];
		waveData = audio.GetOutputData(dec,0);
		float levelMax = 0;
		/*
		for (int i = 0; i < dec; i++) {		
		    float wavePeak = waveData[i] * waveData[i];
		    if (levelMax < wavePeak) {
		        levelMax = wavePeak;
		    }
		}
		*/
		print(waveData[8]);
		
	}
}
