/**
*
*/
class HotSpot
{
    int w = 10;          // The width and height of the cells
    int columns, rows;   // Number of columns, number of rows
    int interfaceHeight; // The interface height, need to draw grid
    int numOfRobbers;    // The inititial number of robbers
    
    Cell[][] grid; // A grid of cells
    
    ArrayList<Robber> robberList = new ArrayList<Robber>();
    ArrayList<Crime>  robberies  = new ArrayList<Crime>();

    HotSpot(int numRob, float interfaceH)
    {
        interfaceHeight = (int)interfaceH; // Cast the variable to an integer
      
        // Initialize rows, columns and set-up arrays
        columns = (width - 2*interfaceHeight)/w;
        rows = (height - interfaceHeight)/w;
        grid = new Cell[columns][rows];
        numOfRobbers = numRob;
        
        // Fill the grid with cell objects
        init(interfaceHeight);
    }
    
    /**
    * Fill the grid with cell objects.
    *
    * @param interfaceHeight The interface Height
    */
    void init(int interfaceHeight)
    {
        for (int i = 0; i < columns; i++)
        {
            for (int j = 0; j < rows; j++)
            {
                grid[i][j] = new Cell(i*w + 2*interfaceHeight, j*w + interfaceHeight, w);   
            }
        }
        
        /*
        Mention what this is doing...
        */
        for (int i = 0; i < numOfRobbers; i++) 
            robberList.add(new Robber(int(random(columns))*w + 2*interfaceHeight, 
                                      int(random(rows))*w    +   interfaceHeight, w, 
                                      random(0.01, 0.20), int(random(10, 50)), interfaceHeight));
    }

    /**
    * When there is a succesful burglary, this cop creates a 9x9 grid with the the burgled
    * location at the centre. Next it increases the probability of all of those locations 
    * by 1. The modulus function is used for the code to behave properly around the edges
    * of the grid.
    *
    * @param x The x-location of the cell
    * @param y The y-location of the cell
    */
    void increaseProbability(int x, int y)
    {
        for (int u = -1; u <= 1; u++)
        {
            for (int v = -1; v <= 1; v++)
                grid[(x + u + columns)%columns][(y + v + rows)%rows].probability += 1;
        }
    }
    
    /**
    * @param x The x-location of the cell
    * @param y The y-location of the cell
    */
    void decreaseProbability(int x, int y)
    {
        for (int u = -1; u <= 1; u++)
        {
            for (int v = -1; v <= 1; v++)
            {
                grid[(x + u + columns)%columns][(y + v + rows)%rows].probability -= 1;
                
                // Ensure the probabilities don't fall below zero
                if(grid[(x + u + columns)%columns][(y + v + rows)%rows].probability < 1)
                    grid[(x + u + columns)%columns][(y + v + rows)%rows].probability = 1;
            }
        }
    }
    
    /**
    * Check whether that cell is robbed.
    *
    * @return boolean
    */
    void robbed()
    {   
        for (int i = 0; i < columns; i++)
        {
            for (int j = 0; j < rows; j++)
            {
                for (Robber r : robberList) 
                {
                    if (r.x == grid[i][j].x && r.y == grid[i][j].y)
                    {
                        if(grid[i][j].probability > 48) // Arbitrary
                        {
                            robberies.add(new Crime(r.x, r.y, w));
                            grid[i][j].robbed = true;
                            increaseProbability(i, j);
                        }
                    }
                }
            }
        }
    }
    
    /**
    * Update the cells to decrease the lifespan of a hotspot.
    * This also decreases the alpha value, or red robbery cell.
    * Hence the cell eventually loses all colour.
    */
    void update()
    {
        for (Crime c : robberies)
            c.lifespan--;
         
        for (int i = 0; i < robberies.size(); i++)
        {
            Crime c = robberies.get(i);
            if (c.isDead() == true)
                    robberies.remove(i);
        }
    }
    
    /**
    * @param col  The total number of columns the grid is made of.
    * @param row  The total number of rows the grid is made of.
    * @param mode The type of random walk.
    */
    void selectRandomWalk(int col, int row, int mode)
    {
        for (Robber r : robberList) 
        {
            r.display();
            if (mode == 1)
                r.walk(col, row);
            else
                r.levywalk(col, row);
        }
    }

    /**
    * Display the cells.
    */
    void display()
    {
        for (int i = 0; i < columns; i++)
        {
            for (int j = 0; j < rows; j++)
                grid[i][j].display();
        }
    }
}