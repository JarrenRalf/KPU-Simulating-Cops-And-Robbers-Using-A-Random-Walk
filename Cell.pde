/**
* This class is inspired by the object-oriented cells presented in Chapter 7.8 in Nature of Code.
* Our own adaptation comes in the form
*/
class Cell
{
    float x, y;       // The x- and y-coordinates of a cell
    float w;          // The width of each cell
    int probability;  // The current probability of each cell being robbed
    int previousProb; // The previous probability of each cell
    int lifespan;     //
    boolean robbed;   //

    Cell(float x, float y, float w)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        
        lifespan = 125;
        probability = int(random(1, 50)); // There is a 1% to 50% chance of being robbed initially
        previousProb = probability;
    }
    
    /**
    * Set the probability of the cell.
    *
    * @param p The probability of the cell
    */
    void newProbability(int p) { probability = p; }
    
    void display()
    {
        if (robbed == true)
            fill(255, 0, 0, lifespan--); // Transparent red
        else 
            noFill(); // Keep blank
        stroke(0);
        rect(x, y, w, w);
    }
}