using UnityEngine;
using System.Collections;

public class CameraMovement : MonoBehaviour {
	public Transform center;
	public float vel;


	void Update () {
		transform.position = new Vector3(2f*12.02545f*Mathf.Sin(Time.time*vel),transform.position.y,transform.position.z);
		transform.LookAt(center);
	}
}
