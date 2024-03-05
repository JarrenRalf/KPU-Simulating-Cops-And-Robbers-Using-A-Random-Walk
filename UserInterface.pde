/**
*
*/
class UserInterface
{ 
    float interfaceWidth = width;
    float interfaceHeight = height/10;
    PImage background;
    
    // Instantiates the buttons, scroll bars, and other objects
    Button button1, button2, button3;
    SaveButton saveButton;
    CircleButton circButton1, circButton2, circButton3;
    Scrollbar bar1, bar2;
    Radio[] buttons = new Radio[4];
    HotSpot hotspot;
    
    PrintWriter printWriter = createWriter("RobberyData.csv");
    
    int firstTime = 1; // So the headings are only repeated once
    
    // Police Cars
    ArrayList<PoliceCar> policeCarList = new ArrayList<PoliceCar>();
    int initialNumOfRobbers = 10;
    
    // This block is used for the panning and zooming of the program
    float scale = 1;
    float xPan = width/2; // Half of my monitor width 
    float yPan = height/2; // Half of my monitor height
    
    boolean zoomIn   = false;
    boolean zoomOut  = false;
    boolean panUp    = false;
    boolean panDown  = false;
    boolean panLeft  = false;
    boolean panRight = false;
    float panSpeed = 10;
    float zoomSpeed = 1.04;
    
    // Set all of the 'modes' of each button to their initial state
    int mode_button = 1;
    int mode_circButton = 1;
    int mode_radio = 0;
    
    color interfaceColour;
    color gray  = color(204);
    color white = color(255);
    color black = color(0);
    
    PFont font = createFont("Arial Bold", 30);

    UserInterface ()
    {
        background = loadImage("Vancouver.png");
        
        // Set and fill the background colour of the interface
        interfaceColour = color(90, 151, 235);
        
        button1 = new Button((int)(width - 3*interfaceHeight), (int)(interfaceHeight/2), (int)(2*interfaceHeight/5), gray, white, black);
        button2 = new Button((int)(width - 2*interfaceHeight), (int)(interfaceHeight/2), (int)(2*interfaceHeight/5), gray, white, black);
        
        circButton1 = new CircleButton( 2*width/32, 5*height/108, width/96, gray, white, black);
        
        saveButton = new SaveButton(width - (int)interfaceHeight, 0, (int)interfaceHeight, white, gray, black);
        
        bar1 = new Scrollbar((int)(123*interfaceHeight/20),  (int)(4*interfaceHeight/5), width/24, height/108, 0.0, 10.0, 0);
        bar2 = new Scrollbar((int)(width - 4*interfaceHeight),  (int)(4*interfaceHeight/5), width/24, height/108, 1.0, 20.0);
        
        // The grid
        hotspot = new HotSpot(initialNumOfRobbers, interfaceHeight);
        
        // Create 4 instances of the radio buttons
        for (int i = 0; i < buttons.length; i++)
        {
            int x = (int)(38*interfaceHeight/5) + i*(int)(19*interfaceHeight/20);
            buttons[i] = new Radio(x, (int)(7*interfaceHeight/10), (int)(interfaceHeight/4), white, black, i, buttons);
        }
        
        // Check the first radio button because that is the initial state
        buttons[0].checked = true;
    }
    
    /**
    * This is the main program
    */
    void mainProgram()
    {
        pushMatrix(); // Leave this at the beginning
          // Used for the zoom
          translate(width/2, height/2);
          scale(scale);
          translate(-xPan, -yPan);
          background(gray);
          
          image(background, 2*interfaceHeight, interfaceHeight, width - 2*interfaceHeight, height - interfaceHeight);
          
          saveData();
          hotspots();
          police();
          
        popMatrix(); // Leave this at the end
    }
    
    /**
    * Do the police stuff here
    */
    void police()
    {
        if (int(bar1.getPos()) > policeCarList.size())
        {
            for (int i = policeCarList.size(); i < int(bar1.getPos()); i++) 
                policeCarList.add(new PoliceCar(i + 1, random(2*interfaceHeight, width), random(interfaceHeight, height)));
        }
        else if (int(bar1.getPos()) < policeCarList.size())
        {
            for (int j = policeCarList.size(); j > int(bar1.getPos()); j--) 
                policeCarList.remove(j - 1);
        }
      
        for (PoliceCar v : policeCarList) 
        {
            // Path following and separation are worked on in this function
            v.applyBehaviors(policeCarList, hotspot.robberList);
            hotspot.decreaseProbability(int(v.position.x) - (int(v.position.x) % hotspot.w) - int(2*interfaceHeight), 
                                        int(v.position.y) - (int(v.position.y) % hotspot.w) - int(interfaceHeight));
            // Call the generic run method (update, borders, display, etc.)
            v.update();
            v.selectScanningRadius(mode_radio);
            v.drawPoliceCar();   
        }
    }
    
    /**
    * Do hot spot shit
    */
    void hotspots()
    {
        // Add or remove robbers based on the position of the slider
        if (int(bar2.getPos()) > hotspot.robberList.size())
        {
            for (int i = hotspot.robberList.size(); i < int(bar2.getPos()); i++) 
                hotspot.robberList.add(new Robber(int(random(hotspot.columns))*hotspot.w + 2*interfaceHeight, 
                                                  int(random(hotspot.rows))*hotspot.w    +   interfaceHeight, 
                                                  hotspot.w, random(0.01, 0.20), int(random(10, 30)), 
                                                  interfaceHeight));
        }
        else if (int(bar2.getPos()) < hotspot.robberList.size())
        {
            for (int j = hotspot.robberList.size(); j > int(bar2.getPos()); j--) 
                hotspot.robberList.remove(j - 1);
        }  
        
        hotspot.display();
        hotspot.update();
        hotspot.selectRandomWalk(hotspot.columns, hotspot.rows, mode_button);
        hotspot.robbed();     
    }
    
    void interfaceDesign()
    {
        fill(interfaceColour);
        noStroke();
        rect(0, 0, interfaceWidth, interfaceHeight);
        rect(0, interfaceHeight, 2*interfaceHeight, height - interfaceHeight);
        fill(black);
        textAlign(CENTER);
        textFont(font);
        textSize(14);
        text("Brownian", width - 11*interfaceHeight/4, 2*interfaceHeight/10);
        text("Motion",   width - 11*interfaceHeight/4, 2*interfaceHeight/10 + 16);
        text("Levy",     width -  7*interfaceHeight/4, 2*interfaceHeight/10);
        text("Flight",   width -  7*interfaceHeight/4, 2*interfaceHeight/10 + 16);
        textSize(25);
        text("The Police Scanning Radius", 9*interfaceHeight, interfaceHeight/5);
        textSize(50);
        text("Robbers:", width - 5*interfaceHeight, 13*interfaceHeight/20);
        text("Police:", 5*interfaceHeight, 13*interfaceHeight/20);
    }
    
    /**
    * Updates all of the buttons and scroll bars.
    */
    void update()
    {
        button1.update(mouseX, mouseY);
        button2.update(mouseX, mouseY);
 
        circButton1.update(mouseX, mouseY);
        
        saveButton.update(mouseX, mouseY);

        bar1.update(mouseX, mouseY);
        bar2.update(mouseX, mouseY); 
    }
    
    /**
    * Displays all of the buttons and scroll bars.
    */
    void display()
    {
        button1.display();
        button2.display();
        
        circButton1.display();
        
        saveButton.display();
        
        bar1.display();
        bar2.display();
        
        for (Radio r : buttons)
            r.display();
    }
    
    /**
    * Controls the pan and zoom of the program.
    */
    void panAndZoom()
    {
        if(zoomIn)
            scale *= zoomSpeed;
        if(zoomOut)
            scale /= zoomSpeed;
        if(panUp)
            yPan -= panSpeed;
        if(panDown)
            yPan += panSpeed;
        if(panLeft)
            xPan -= panSpeed;
        if(panRight)
            xPan += panSpeed;
    }
    
    /**
    * This method will be called when there is a 'mousePressed()' event.
    */
    void pressedMouse()
    {
        bar1.press();
        bar2.press();
          
        if (button1.press() == true) { mode_button = 1; }
        if (button2.press() == true) { mode_button = 2; }
        
        if (circButton1.press() == true) { mode_circButton = 1; }
        
        if (saveButton.press() == true) { saveDataButton(); }
        
        for (int i = 0; i < buttons.length; i++)
        {
            buttons[i].press(mouseX, mouseY);
            
            if (buttons[i].checked)
                mode_radio = i;
        }
    }
    
    /**
    * This method will be called when their is a 'mouseReleased()' event.
    */
    void releasedMouse()
    {
        bar1.release();
        bar2.release();
        
        button1.release();
        button2.release();
        
        circButton1.release();
        
        saveButton.release();
    }
    
    /**
    * This method will be called when there is a 'keyPressed()' event.
    */
    void pressedKey()
    {
        if(key == 'w' || key == 'W')
        {
            zoomIn = true;
            zoomOut = false;
        }
        if(key == 's' || key == 'S')
        {
            zoomOut = true;
            zoomIn = false;
        }
        if(keyCode == UP)
        {
            panUp = true;
            panDown = false;
        }
        if(keyCode == DOWN)
        {
            panDown = true;
            panUp = false;
        }
        if(keyCode == LEFT)
        {
            panLeft = true;
            panRight = false;
        }
        if(keyCode == RIGHT)
        {
            panRight = true;
            panLeft = false;
        }
    }
    
    /**
    * This method will be called when there is a 'keyReleased()' event.
    */
    void releasedKey()
    {
        if(key == 'w' || key == 'W')
            zoomIn = false;
    
        if(key == 's' || key == 'S')
            zoomOut = false;
    
        if(keyCode == UP)
            panUp = false;
    
        if(keyCode == DOWN)
            panDown = false;
    
        if(keyCode == LEFT)
            panLeft = false;
    
        if(keyCode == RIGHT)
            panRight = false;
    }
    
    /**
    * This method will be called when there is a 'mouseDragged()' event.
    */
    void draggedMouse()
    {
        if (mouseY > interfaceHeight)
        {
            xPan = xPan - (mouseX - pmouseX);
            yPan = yPan - (mouseY - pmouseY);
        }
    }
    
    /**
    * This method will be called when there is a 'mouseWheel()' event.
    */
    void scrollWheel(MouseEvent e)
    {
        xPan -= mouseX;
        yPan -= mouseY;
        float delta = e.getCount() > 0 ? 1.05 : e.getCount() < 0 ? 1.0/1.05 : 1.0;
        scale *= delta;
        xPan *= delta;
        yPan *= delta;
        xPan += mouseX;
        yPan += mouseY;
    }
    
    /**
    *
    */
    void saveData()
    {
        if (firstTime == 1) // Print headings only the first time
        {
            printWriter.append("Number of:");
            printWriter.println();
            printWriter.append("Robbers");
            printWriter.append(",");
            printWriter.append("Police");
            printWriter.append(",");
            printWriter.append("Robberies");
            printWriter.println();
            firstTime++;
        }
        
        printWriter.append(Integer.toString(hotspot.robberList.size())); // Number of Robbers
        printWriter.append(",");
        printWriter.append(Integer.toString(policeCarList.size()));      // Number of Police
        printWriter.append(",");
        printWriter.append(Integer.toString(hotspot.robberies.size()));  // Number of Robberies
        printWriter.println();
    }
    
    void saveDataButton()
    {
        printWriter.flush(); // Writes the remaining data to the file
        printWriter.close(); // Finishes the file
        exit(); // Stops the program
    }
    
    void scrollBarAction()
    {
        PFont font = createFont("Courier New", 80);
        textFont(font);
        textAlign(CENTER);
        
        fill(0);
        int pos1 = int(bar1.getPos());
        text(nf(pos1, 2), 13*interfaceHeight/2, 3*interfaceHeight/4);
        
        int pos2 = int(bar2.getPos());
        text(nf(pos2, 2), width - 18*interfaceHeight/5, 3*interfaceHeight/4);
        
        textSize(16);
        textAlign(CENTER);
    }
}