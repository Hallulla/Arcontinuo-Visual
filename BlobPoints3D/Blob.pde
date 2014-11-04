public class Blob{
  public int fingerID;
  public int area;
  public PVector position;
  public boolean isActive;
  PVector lastWavePosition = new PVector(0,0,0);
  Blob(int _fingerID, int _area, PVector _position, boolean _isActive){
    fingerID = _fingerID;
    area = _area;
    position = _position;
    isActive = _isActive;
    lastWavePosition = _position;
  }
  
  public void setPosition(PVector newPosition, Wave wave){
    position = newPosition;
    println(distance(lastWavePosition,newPosition));
    if(distance(lastWavePosition,newPosition) > .1f){
      lastWavePosition = newPosition;
      wave.Init(newPosition);
    }
  }
  float distance(PVector a, PVector b){
    return sqrt(pow(b.x - a.x,2) + pow(b.y - a.y,2) + pow(b.z - a.z,2));
  }
  public void Reset(){
    area = 0;
    position = new PVector(0,0,0);
    isActive = false;
  }
} 
