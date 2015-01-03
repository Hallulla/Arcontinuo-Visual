using UnityEngine;
using System.Collections;

public class StageManager : MonoBehaviour {
	public static StageManager instance;
	[SerializeField] int m_currentStage = 0;
	public static int currentStage{
		get{ return instance.m_currentStage; }
		set{ instance.m_currentStage = value; }
	}

	void Awake(){
		instance = this;
	}

}
