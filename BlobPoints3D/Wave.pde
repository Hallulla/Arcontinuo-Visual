public class Wave{
  PVector center;
  float r;
  boolean isActive;
  void Wave(){
    center = new PVector(0,0,0);
    r = 0;
    isActive = false;
  }
  public void Init(PVector _center){
    center = _center;
    r = 0;
    isActive = true;
  }
  public void Refresh(){
    if(isActive){
      //stroke(255);
      //fill(0,0,0,0);
      //ellipse(center.x,center.y,r,r);
      r+=4;
      if(r > 1200)
        isActive = false;
    }
  }
}
