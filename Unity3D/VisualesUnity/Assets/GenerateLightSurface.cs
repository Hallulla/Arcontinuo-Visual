using UnityEngine;
using System.Collections;

public class GenerateLightSurface : MonoBehaviour {
	[SerializeField] GameObject lightPrefab;
	[SerializeField] int rows = 5, cols = 5;
	[SerializeField] float xDistance = 1f, zDistance = 1f;
	GameObject[,] lights;
	void Start () {
		lights = new GameObject[rows,cols];
		for(int x = 0; x < rows; x++){
			for(int z = 0; z < cols; z++){
				lights[x,z] = Instantiate(lightPrefab) as GameObject;
				lights[x,z].transform.parent = transform;
				lights[x,z].transform.localPosition = new Vector3(x*xDistance,0,z*zDistance);
			}
		}
	}
	

}
