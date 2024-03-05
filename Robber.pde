/**
* 
*/
Random intGenerator;

class Robber extends Crime
{
    float interfaceHeight; // The interface height, need to constrain the robber
    float levyProbability; // The probability of taking a large step
    int maxLevyStepSize;   // The max levy flight step
    PImage robber;
    
    Robber(float x, float y, float w, float p, int s, float interfaceH)
    {
        super(x, y, w);

        maxLevyStepSize = s;
        levyProbability = p;
        interfaceHeight = (int)interfaceH;
        intGenerator = new Random();
        robber = loadImage("robber.png");
    }
    
    /**
    * @override
    */
    void display() { image(robber, x, y, w, w); }
    
    /**
    * Randomly move up, down, left, right, or stay in one place
    *
    * @param col The total number of columns the grid is made of.
    * @param row The total number of rows the grid is made of.
    */
    void walk(int col, int row)
    {
        /*
        Randomly generate -1, 0, or 1.
        Then multiply it by the size of a single cell.
        */
        int vx = (int)w*(intGenerator.nextInt(3)-1);
        int vy = (int)w*(intGenerator.nextInt(3)-1);
        x += vx;
        y += vy;
        
        // Stay on the screen
        x = constrain(x, 2*interfaceHeight, w*(col - 1) + 2*interfaceHeight);
        y = constrain(y,   interfaceHeight, w*(row - 1) +   interfaceHeight);
    }
    
    
    /**
    * Randomly move up, down, left, right, or stay in one place.
    * Then there's a small probability that the robber takes a large step.
    * This simulates taking a bus for example, to new crime location.
    *
    * @param col The total number of columns the grid is made of.
    * @param row The total number of rows the grid is made of.
    */
    void levywalk(int col, int row)
    {
        int stepx;
        int stepy;
        
        float r = random(1);
        
        // A 1% chance of taking a large step
        if (r < levyProbability)
        {
            // Restrict these steps from producing a step size of (x, y) = (1, 1) or less
            do
            {
                stepx = (int)w*(intGenerator.nextInt(2*maxLevyStepSize + 1) - maxLevyStepSize);
                stepy = (int)w*(intGenerator.nextInt(2*maxLevyStepSize + 1) - maxLevyStepSize);
            }
            while (abs(stepx) <= 1 && abs(stepy) <= 1);
        }
        else
        {
            stepx = (int)w*(intGenerator.nextInt(3) - 1);
            stepy = (int)w*(intGenerator.nextInt(3) - 1);
        }
        
        x += stepx;
        y += stepy;
        
        // Stay on the screen
        x = constrain(x, 2*interfaceHeight, w*(col - 1) + 2*interfaceHeight);
        y = constrain(y,   interfaceHeight, w*(row - 1) +   interfaceHeight);
    }  
}  