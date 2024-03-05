class Radio
{
    int x, y;                 // The x- and y-coordinates of the circle
    int size, dotSize;        // Dimension of circle, inner circle
    color baseGray, dotGray;  // Circle gray value, inner gray value
    boolean checked = false;  // True when the button is selected
    int me;                   // ID number for this Radio object
    Radio[] others;           // Array of all other Radio objects
    
    Radio(int x, int y, int s, color b, color d, int me, Radio[] o)
    {
        this.x = x;
        this.y = y;
        size = s;
        dotSize = 2*size/3;
        baseGray = b;
        dotGray = d;
        this.me = me;
        others = o;
    }
    
    /**
    * Return true if particular button is pressed, then 
    * set the rest of them to false.
    *
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    * @return boolean
    */
    boolean press(float mx, float my)
    {
        if (dist(x, y, mx, my) < size/2)
        {
            checked = true;
            
            for (int i = 0; i < others.length; i++)
            {
                if (i != me)
                    others[i].checked = false;
            }
            
            return true;
        }
        else
            return false;
    }
    
    /**
    * Draw the element to the display window.
    */
    void display()
    {
        noStroke();
        fill(baseGray);
        ellipse(x, y, size, size);
        if (checked == true)
        {
            fill(dotGray);
            ellipse(x, y, dotSize, dotSize);
        }
    }
}