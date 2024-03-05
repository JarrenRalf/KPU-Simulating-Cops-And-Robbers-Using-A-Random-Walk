/**
*
*/
class Crime extends Cell
{
    boolean robbed;
  
    Crime(float x, float y, float w)
    {
        super(x, y, w);
    }
    
    /**
    * @return boolean
    */
    boolean isDead()
    {
        if (lifespan < 0)
            return true;
        else 
            return false;
    }
}