class CircleButton extends Button
{
    CircleButton (int x, int y, int size, color b, color o, color p)
    {
        super(x, y, size, b, o, p); // Call the super class constructor
    }
    
    /** 
    * Return true if the cursor is over a button.
    *
    * @override
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    * @return boolean
    */
    boolean over(int mx, int my)
    {
        float disX = x - mx;
        float disY = y - my;
        
        if (sqrt(sq(disX) + sq(disY)) < size/2)
            return true;
        else
            return false;
    }
    
    /** 
    * @override
    */
    void display()
    {
        if (pressed == true)
            fill(pressColour);
        else if (over == true)
            fill(overColour);
        else
            fill(baseColour);
        
        stroke(255);
        ellipse(x, y, size, size);
    }
}