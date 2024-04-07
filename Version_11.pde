/**
* This is the final version of our group project.
*
* @author Jenn Causey, Rebecca McJarrow, Jarren Ralf
* @version 7.0
* @since 2018-04-16
*/
import java.util.*; // Imported for the use of the Random class

UserInterface userInterface;

void setup()
{
    fullScreen();
    userInterface = new UserInterface();
}

void draw()
{
    userInterface.panAndZoom();
    userInterface.mainProgram();
    userInterface.update();
    userInterface.interfaceDesign();
    userInterface.display();
    userInterface.scrollBarAction();
}

void mousePressed()           { userInterface.pressedMouse();  }
void mouseReleased()          { userInterface.releasedMouse(); }
void keyPressed()             { userInterface.pressedKey();    }
void keyReleased()            { userInterface.releasedKey();   }
void mouseDragged()           { userInterface.draggedMouse();  }
void mouseWheel(MouseEvent e) { userInterface.scrollWheel(e);  }
