/*
 * Bubbles v2
 * ==========
 *
 * Jorge Ivan Meza Martinez <jimezam [at] gmail [dot] com>
 * http://jorgeivanmeza.com/
 *
 * This source code is licensed under Attribution-
 * NonCommercial 3.0 Unported.
 * http://creativecommons.org/licenses/by-nc/3.0/
 *
 * Images was taken from Game Marbles - Shapes:
 * http://www.openclipart.org/detail/3154
 *
 */

import java.awt.event.KeyEvent;

// Global variables
//////////////////////////////////////////////////

/**
 * The game board.
 */

Universe universe;

/**
 * The software version.
 */

final static String version = "20100822";

// General language functions
//////////////////////////////////////////////////

/**
 * Draw everything in the windows.
 *
 * This function is called in an infinite loop.
 */

void draw()
{
  // Background for the game when its active.

  color gameOn = color(255, 255, 255);

  // Background for the game with its over.

  color gameOff = color(255, 0, 0);

  // Set the background of the game.

  background((universe.isGameOver()) ? gameOff : gameOn);

  if(universe != null)
  {
    if(universe.isGameOver())
    {
      // Set the information message over the background.

      textAlign(CENTER, CENTER);
      fill(100, 100, 100);
      textSize(35);

      text("Bubbles 2",
      50, 120, width - 100, 100);

      text("http://jorgeivanmeza.com/",
      50, 230, width - 100, 100);
    }

    // Draw the game board.

    universe.draw();

    // Set the headers message.

    String header = "Shots: " + universe.shots + "; Points: " + universe.exploded + ".";

    if(universe.isHintMode())
      header = "[In hint mode]";

    // Draw the headers message.

    fill(color(0, 0, 0));
    textAlign(CENTER, CENTER);
    textSize(30);
    text(header, 10, 5, width - 20, 40);
  }
}

//////////////////////////////////////////////////

/**
 * This function is called when any key is pressed.
 *
 * It handles the general keystrokes of the game.
 *
 *    - R:  Resets the game.
 *    - H:  Toggles the hint mode.
 *    - Q:  Quits the game.
 */

void keyPressed()
{
  switch(keyCode)
  {
    // Handles the reset of the board.

    case KeyEvent.VK_R:
      universe.reset();
      redraw();
    break;

    // Handles the quit of the game.

    case KeyEvent.VK_Q:
      exit();
    break;

    // Pass the information to the board to be handled by it.

    case UP:
    case DOWN:
    case LEFT:
    case RIGHT:
    case KeyEvent.VK_SPACE:
      universe.handleCursor(keyCode);
    break;

    // Handles the hint mode.

    case KeyEvent.VK_H:
      universe.toggleHints(true);
    break;
  }
}

//////////////////////////////////////////////////

/**
 * This function is called when a mouse click happens.
 */

void mousePressed()
{
  // Check if the click was done with the left button.

  if (mouseButton == LEFT)
  {
    // Check if the click was done in the games board.

    Location loc = universe.isHitIn(mouseX, mouseY);

    if(loc != null)
    {
      // If it was, then hit the universe.

      boolean control = universe.hit(loc.row, loc.col);
    }
  }
}

/**
 * This function is called when the mouse pointer is moved over the window.
 */

void mouseMoved()
{
  // Check if the mouse pointer was moved over the games board.

  Location loc = universe.isHitIn(mouseX, mouseY);

  if(loc != null)
  {
    // If it was, then move the cursor with it.

    universe.cursor = new Location(loc.row, loc.col);
  }
}

//////////////////////////////////////////////////

/**
 * This function is called only once when the application is starting up.
 */

void setup()
{
  size(600, 600);

  /*
   frame.setTitle("[[Bubbles]] - " + version);
   // trick to make it possible to change the frame properties
   frame.removeNotify();
   // comment this out to turn OS chrome back on
   frame.setUndecorated(true);
   // comment this out to not have the window "float"
   frame.setAlwaysOnTop(true);
   frame.setResizable(true);
   frame.addNotify();
  */

  universe = new Universe(11, 11, 0, 50, width, height - 50);
}

//////////////////////////////////////////////////