class Button
{
    int x, y;                // The x- and y-coordinates
    int size;                // Dimension (width and height)
    color baseColour;        // Default colour 
    color overColour;        // Colour when mouse is over the button
    color pressColour;       // Colour when mouse is over and pressed
    boolean over = false;    // True when the mouse is over 
    boolean pressed = false; // True when the mouse is over and pressed
    
    Button(int x, int y, int size, color b, color o, color p)
    {
        this.x = x;
        this.y = y;
        this.size = size;
        baseColour = b;
        overColour = o;
        pressColour = p;
    }
    
    /**
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    */
    void update(int mx, int my)
    {
        if (over(mx, my) == true)
            over = true;
        else
            over = false;
    }
    
    /**
    * @return boolean
    */
    boolean press()
    {  
        if (over == true) 
        {
            pressed = true;
            return true;
        }
        else
            return false;
    }
    
    void release() { pressed = false; }
    
    /**
    * Return true if the cursor is over a button.
    *
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    * @return boolean
    */
    boolean over(int mx, int my)
    {
        if ((mx >= x) && (mx <= x + size) && (my >= y) && (my <= y + size))
            return true;
        else
            return false;
    }

    void display()
    {
        if (pressed == true)
            fill(pressColour);
        else if (over == true)
            fill(overColour);
        else
            fill(baseColour);
        
        stroke(255);
        rect(x, y, size, size);
    }
}