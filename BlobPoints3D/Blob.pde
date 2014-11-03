public class Blob{
  public int fingerID;
  public int area;
  public PVector position;
  public boolean isActive;
  Blob(int _fingerID, int _area, PVector _position, boolean _isActive){
    fingerID = _fingerID;
    area = _area;
    position = _position;
    isActive = _isActive;
  }
  public void Reset(){
    area = 0;
    position = new PVector(0,0,0);
    isActive = false;
  }
} 
