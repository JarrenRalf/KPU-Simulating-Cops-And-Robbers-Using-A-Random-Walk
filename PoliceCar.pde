/**
* This is a flocking algorithm. Nice work Jennifer!
*/
class PoliceCar
{
    float r, borderDist; // Radius of some sort? It roughly knows where the border is?
    float wandertheta;   // Some angle?
    float maxforce;      // Maximum steering force
    float maxspeed;      // Maximum speed
    int pcNum;           // Police Car number stored as an integer
    String number;       // Police car number stored as a string
    float scannerRadius;
    PVector position, velocity, acceleration;
    PFont fontBOLD, fontPOLICE;
    float interfaceHeight = height/10;
  
    PoliceCar(int num, float x, float y)
    {
        acceleration = new PVector(0, 0); // Initial Acceleration
        velocity = new PVector(0, 0);     // Initial Velocity
        position = new PVector(x, y);     // Initial Position
        r = 50;          //
        wandertheta = 0; //
        maxspeed = 2;    //
        maxforce = 0.1;  //
        
        fontBOLD = createFont("Arial Bold", 14/5);
        fontPOLICE = createFont("Arial Bold", 8/5);
        pcNum = num;
        number = nf(pcNum, 3); // Format number to string
    }
    
    /**
    * @param force Is a pVector
    */
    void applyForce(PVector force) { acceleration.add(force); }
    
    /**
    * @param policeCars is an arrylist of policeCar objects
    */
    void applyBehaviors(ArrayList<PoliceCar> policeCars, ArrayList<Robber> robberList) 
    {
        PVector separateForce = separate(policeCars); 
        PVector seekForce = seek(findRobbers(robberList));
        
        separateForce.mult(2);
        seekForce.mult(1);
         
        applyForce(separateForce);
        applyForce(seekForce);
    }
    
    /**
    * @param target A PVector
    * @return PVector
    */
    PVector seek(PVector target) 
    {  
        PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
  
        // Normalize desired and scale to maximum speed
        desired.normalize();
        desired.mult(maxspeed);
        
        // Steering = Desired minus velocity
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce);  // Limit to maximum steering force
        
        return steer;
    }
    
    /**
    * @param policeCars is an arrylist of policeCar objects
    * @return PVector
    */
    PVector separate (ArrayList<PoliceCar> policeCars) 
    {
        float desiredseparation = r/2;
        PVector sum = new PVector();
        int count = 0;
        
        // For every boid in the system, check if it's too close
        for (PoliceCar other : policeCars)
        {
            float d = PVector.dist(position, other.position);
            
            // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
            if ((d > 0) && (d < desiredseparation))
            {
                // Calculate vector pointing away from neighbor
                PVector diff = PVector.sub(position, other.position);
                diff.normalize();
                diff.div(d);        // Weight by distance
                sum.add(diff);
                count++;            // Keep track of how many
            }
        }
        
        // Average -- divide by how many
        if (count > 0)
        {
            sum.div(count);
            
            // Our desired vector is the average scaled to maximum speed
            sum.normalize();
            sum.mult(maxspeed);
            
            // Implement Reynolds: Steering = Desired - Velocity
            sum.sub(velocity);
            sum.limit(maxforce);
        }
        return sum;
    }
    
    /**
    * @return PVector
    */
    PVector wander() 
    {
        float wanderR = 25;         // Radius for our "wander circle"
        float wanderD = 80;         // Distance for our "wander circle"
        float change = 0.3;
        wandertheta += random(-change,change);     // Randomly change wander theta
    
        // Now we have to calculate the new position to steer towards on the wander circle
        PVector circlepos = velocity.copy();    // Start with velocity
        circlepos.normalize();                  // Normalize to get heading
        circlepos.mult(wanderD);                // Multiply by distance
        circlepos.add(position);                // Make it relative to boid's position
    
        float h = velocity.heading();           // We need to know the heading to offset wandertheta
    
        PVector circleOffSet = new PVector(wanderR*cos(wandertheta + h), wanderR*sin(wandertheta + h));
        PVector target = PVector.add(circlepos, circleOffSet);
        return target;
    }
    
    PVector findRobbers(ArrayList<Robber> robberList) 
    {
        PVector smallestDistance = new PVector(scannerRadius, 0);
        PVector robberPosition = new PVector(0,0);
        
        for (Robber robber : robberList)
        {
            PVector robberVector = new PVector(robber.x,robber.y);
            float distance = PVector.dist(position, robberVector);
            if((0 < distance) && (distance < scannerRadius) && (distance < smallestDistance.mag()))
            {
                smallestDistance = PVector.sub(position, robberVector);
                robberPosition = robberVector;
            }
        }
        
        if(smallestDistance.mag() <= scannerRadius)
            return robberPosition;
        else 
            return wander();
    }

    void update() 
    {
        position.x = constrain(position.x, 1, width);
        position.y = constrain(position.y, 1, height);
        // Update velocity
        velocity.add(acceleration);
        
        // Limit speed
        velocity.limit(maxspeed);
        position.add(velocity);
        
        // Reset accelertion to 0 each cycle
        acceleration.mult(0);
    }
    
    /**
    * @param mode
    */
    void selectScanningRadius(int mode)
    {
        scannerRadius = (mode + 5)*r;
        
        fill(0, 125, 255, 20);
        stroke(0);
        ellipse(position.x, position.y, scannerRadius, scannerRadius);
    }
  
    void drawPoliceCar()
    {
        float theta = velocity.heading() + PI/2;
        fill(175);
        stroke(0);
        pushMatrix();
          translate(position.x, position.y);
          rotate(theta - PI/2);
         
          noStroke();
          rectMode(CENTER);
          //car body
          fill(0);
          rect(0, 0, 100/5, 44/5, 50/5);
          //windows
          fill(50);
          rect(20/5, 0, 20/5, 40/5, 10/5);
          rect(-20/5, 0, 20/5, 40/5, 10/5);
          //cab
          fill(255);
          rect(0, 0, 40/5, 42/5, 10/5);
          
          //top lights
          fill(255, 0, 0);
          rect(10/5, -7/5, 8/5, 14/5);
          fill(0,0,255);
          rect(10/5, 7/5, 8/5, 14/5);
          
          //policeCar number
          pushMatrix();
            fill(0);
            translate(-10/5, 0);
            rotate(PI/2);
            textAlign(CENTER);
            textFont(fontBOLD);
            text(number, 0, 0);
          popMatrix();
          
          //POLICE label
          pushMatrix();
            fill(255);
            translate(-40/5, 0);
            rotate(PI/2);
            textAlign(CENTER);
            textFont(fontPOLICE);
            text("POLICE", 0, 0);
          popMatrix();
      
          
          //front left head light
          pushMatrix();
            translate(45/5, -17/5);
            fill(255, 255, 153);
            rotate(-PI/6);
            ellipseMode(CENTER);
            ellipse(0, 0, 6/5, 9/5);
          popMatrix();
          
          //front right head light
          pushMatrix();
            translate(45/5, 17/5);
            fill(255, 255, 153);
            rotate(PI/6);
            ellipseMode(CENTER);
            ellipse(0, 0, 6/5, 9/5);
          popMatrix();
          
          //back left break light
          pushMatrix();
            translate(-45/5, -17/5);
            fill(255, 0, 0);
            rotate(PI/6);
            ellipseMode(CENTER);
            ellipse(0, 0, 6/5, 9/5);
          popMatrix();
          
          //back right break light
          pushMatrix();
            translate(-45/5, 17/5);
            fill(255, 0, 0);
            rotate(-PI/6);
            ellipseMode(CENTER);
            ellipse(0, 0, 6/5, 9/5);
          popMatrix();
        popMatrix();
            
        rectMode(CORNER); // Change the rectangle drawing mode back to the default
        textFont(fontBOLD);
    }
}