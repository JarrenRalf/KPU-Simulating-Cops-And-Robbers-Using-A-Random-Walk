class Scrollbar
{
    int x, y;             // The x- and y-coordinates
    float w, h;           // Width and height of scrollbar
    float pos;            // Position of thumb
    float posMin, posMax; // Min and max values of thumb
    boolean rollover;     // True when the mouse is over 
    boolean locked;       // True when its the active scrollbar 
    float minVal, maxVal; // Min and max values for the thumb
    
    Scrollbar (int x, int y, int w, int h, float miv, float mav)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        minVal = miv;
        maxVal = mav;
        pos = x + w/2 - h/2; // Move thumb to chosen position
        posMin = x;
        posMax = x + w - h;
    }
    
    /**
    * This constructor allows for a change in the initial position of the thumb.
    */
    Scrollbar (int x, int y, int w, int h, float miv, float mav, int p)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        minVal = miv;
        maxVal = mav;
        pos = x + p + 3 - h/2; // Move thumb to chosen position
        posMin = x;
        posMax = x + w - h;
    }
    
    /**
    * Update the boolean value over and the position of the thumb.
    *
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    */
    void update(int mx, int my)
    {
        if (over(mx, my) == true)
            rollover = true;
        else
            rollover = false;
        if (locked == true)
            pos = constrain(mx - h/2, posMin, posMax);
    }
    
    /**
    * Lock the thumb so the mouse can move off and still update.
    */
    void press()
    {
        if (rollover == true)
            locked = true;
        else
            locked = false;
    }
    
    /**
    * Reset the scrollbar to neutral.
    */
    void release() { locked = false; }
    
    /**
    * Return true if the cursor is over the scrollbar.
    *
    * @param mx The horizontal position of the mouse.
    * @param my The vertical position of the mouse.
    * @return boolean
    */
    boolean over(int mx, int my)
    {
        if ((mx > x) && (mx < x + w) && (my > y) && (my < y + h))
            return true;
        else
            return false;
    }
    
    /**
    * Draw the scrollbar to the screen.
    */
    void display()
    {
        fill(255);
        rect(x, y, w, h);  // Draw bar
        if ((rollover == true) || (locked == true))
            fill(0);
        else
            fill(102);
        rect(pos, y, h, h);  // Draw thumb
    }
    
    /**
    * Return the current value of the thumb.
    * 
    * @return float
    */
    float getPos()
    {
        float scalar = w/(w - h);
        float ratio = ((pos - x)*scalar) / w;
        float thumbPos = minVal + (ratio*(maxVal - minVal));
        return thumbPos;
    }
}