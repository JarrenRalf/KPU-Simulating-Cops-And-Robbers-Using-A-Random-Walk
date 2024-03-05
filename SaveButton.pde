class SaveButton extends Button
{   
    PImage save;
  
    SaveButton(int x, int y, int size, color b, color o, color p)
    {
        super(x, y, size, b, o, p);
        save = loadImage("save.png");
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
        rect(x, y, size, size);
        
        image(save, width - size, 0, size, size);
    }
}