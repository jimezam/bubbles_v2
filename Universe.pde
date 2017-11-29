/**
 * This class represents the game board with all the handling of the internal logic.
 */

public class Universe
{
  /**
   * Corners of the game board in the window.
   */

  int x, y, height, width;

  /**
   * Number of rows of bubbles.
   */

  int rows;

  /**
   * Number of columns of bubbles.
   */

  int cols;

  /**
   * Bubbles storage.
   */

  Bubble[][] bubbles;

  /**
   * Amount of shots fired by the user.
   */

  int shots;

  /**
   * Amount of bubbles exploded by the user.
   */

  int exploded;

  /**
   * The location of the cursor (selection) controled
   * by keyboard arrows and on mouse over.
   */

  Location cursor;

  /**
   * Flag that shows the hint mode.
   */

  boolean hintMode;

  /**
   * Flag that shows if the game has ended.
   */

  boolean gameOver;

  /**
   * Constructs a new Universe.
   *
   * @Param  rows    Number of rows of bubbles.
   * @Param  cols    Number of cols of bubbles.
   * @Param  x       X coord. of the upper-left corner of the board in the window.
   * @Param  y       Y coord. of the upper-left corder of the board in the window.
   * @Param  width   Width of the board in the window.
   * @Param  height  Height of the board in the window.
   */

  public Universe(int rows, int cols, int x, int y, int width, int height)
  {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;

    this.rows = rows;
    this.cols = cols;

    this.reset();
  }

  /**
   * Sets the game to initial conditions.
   */

  public void reset()
  {
    this.shots = 0;
    this.exploded = 0;
    this.hintMode = false;
    this.gameOver = false;

    this.bubbles = new Bubble[rows][cols];

    this.fillWithRandomCoins();

    this.cursor = new Location(0, 0);
  }

  /**
   * Check if the game is in hint mode or not.
   *
   * @Return  true if it is in hint mode, false otherwise.
   */

  public boolean isHintMode()
  {
    return this.hintMode;
  }

  /**
   * Check if the game has ended.
   *
   * @Return  true if the game is finished, false otherwise.
   */

  public boolean isGameOver()
  {
    return this.gameOver;
  }

  /**
   * Fill the board with random coins.
   */

  private void fillWithRandomCoins()
  {
    for(int r=0; r<rows; r++)
      for(int c=0; c<cols; c++)
      {
        // There are 9 different types of coins defined in the game.

        int type = int(random(1, 9 +1));

        bubbles[r][c] = new Bubble(type, this.width / this.cols, this.height / this.rows);
      }
  }

  /**
   * Draw the game board in the window.
   */

  public void draw()
  {
    for(int r=0; r<rows; r++)
      for(int c=0; c<cols; c++)
      {
        // Determine if the current place is selected by the cursor and draw it.

        boolean isCursor = (this.cursor.row == r && this.cursor.col == c);

        if(isCursor)
        {
          fill(color(255, 245, 111));
          stroke(color(255, 245, 111));
          rect(this.cursor.col * this.width / this.cols + this.x, this.cursor.row * this.height / this.rows + this.y, this.width / this.cols, this.height / this.rows);
        }

        // If there is a bubble in the current place.

        if(bubbles[r][c] != null)
        {
          // Draw the bubble.

          bubbles[r][c].draw(c * this.width / this.cols + this.x, r * this.height / this.rows + this.y);
        }
      }
  }

  /**
   * Check if a hit made on the window is in the game board or not.
   *
   * @Param  x  X coord. of the hit.
   * @Param  y  Y coord. of the hit.
   * @Return  The Location object with the row/column information of the hit if it was in, null otherwise.
   */

  public Location isHitIn(int x, int y)
  {
    // Check if the hit was in the board.

    if (x >= this.x &&
      y >= this.y &&
      x <= this.x + this.width &&
      y <= this.y + this.height)
    {
      int col = (x - this.x) / (this.width / this.cols);
      int row = (y - this.y) / (this.height / this.rows);

      return new Location(row, col);
    }

    // Otherwise.

    return null;
  }

  /**
   * Remove the selection of all the bubbles of the board.
   */

  private void cleanAllBubbleSelections()
  {
    for(int r=0; r<rows; r++)
      for(int c=0; c<cols; c++)
        if(bubbles[r][c] != null)
          bubbles[r][c].setSelection(false);
  }

  /**
   * Explode the currently selected bubbles of the board.
   *
   * @Return  The count of bubbles exploded.
   */

  private int explodeSelectedBubbles()
  {
    int count = 0;

    for(int r=0; r<rows; r++)
      for(int c=0; c<cols; c++)
        if(bubbles[r][c] != null)
          if(bubbles[r][c].isSelected())
          {
            count ++;

            bubbles[r][c] = null;    // Explode!
          }

    return count;
  }

  /**
   * Make the bubbles fall when they have empty spaces below after an explosion.
   */

  private void makeExplodedBubblesFall()
  {
    for(int c=0; c<cols; c++)
    {
      int emptySpace = -1;

      for(int r=rows-1; r>=0; r--)
      {
        // Find an empty space.

        if(bubbles[r][c] == null)
          emptySpace = r;

        // Find a non empty space.

        if(emptySpace != -1 &&
          bubbles[r][c] != null)
        {
          // Move the bubble to compact the column.

          bubbles[emptySpace][c] = bubbles[r][c];
          bubbles[r][c] = null;
          r = min(emptySpace + 2, rows);
          emptySpace = -1;
        }
      }
    }
  }

  /**
   * Check if a column of the board is empty of bubbles.
   *
   * @Param  column  The index of the column to check.
   * @Return  true if the column is empty, false otherwise.
   */

  private boolean isColumnEmpty(int column)
  {
    for(int r=rows-1; r>=0; r--)
    {
      if(bubbles[r][column] != null)
        return false;
    }

    return true;
  }

  /**
   * Move the bubbles from one column to another.
   *
   * @Param  from  The index of the source column.
   * @Param  to    The index of the target column.
   */

  private void moveBubblesColumn(int from, int to)
  {
    for(int r=0; r<rows; r++)
    {
      bubbles[r][to] = bubbles[r][from];
      bubbles[r][from] = null;
    }
  }

  /**
   * Move horizontally the columns of bubbles to compact the board
   * when there are empty columns after an explosion.
   */

  private void collapseEmptyColumns()
  {
    int emptyCol = -1;

    for(int c=0; c<this.cols; c++)
    {
      // Find an empty column.

      if(this.isColumnEmpty(c))
      {
        if(emptyCol == -1)    // undefined
          emptyCol = c;
      }
      else
      {
        // Find a non empty column.

        if(emptyCol != -1)    // defined
        {
          // Move the bubbles from the non empty column to fill the gap.

          this.moveBubblesColumn(c, emptyCol);
          c = emptyCol;
          emptyCol = -1;
        }
      }
    }
  }

  /**
   * Select the adjacent bubbles of the same type around a specific bubble.
   *
   * This method is call recusively to backtrack the surrounding bubbles of
   * the same type in the four valid directions.
   *
   * @Param  row  The index of the row of the initial bubble.
   * @Param  col  The index of the column of the initial bubble.
   * @Param  type  The type of the initial bubble.
   * @Return  The number of selected bubbles.  Zero if the location was invalid
   *          and 1 if the bubble has not surrounding bubbles of the same type.
   */

  private int makeBubbleSelection(int row, int col, int type)
  {
    // Check the position of the target bubble.

    if(!isValidLocation(row, col))
      return 0;

    // Check that there IS a bubble in this place.

    if(bubbles[row][col] == null)
      return 0;

    // Check that it is not already selected to avoid infinite loops.

    if(bubbles[row][col].isSelected())
      return 0;

    // Check that it has the correct type.

    if(bubbles[row][col].getType() != type)
      return 0;

    // Prepare the direction arrays.

    int[] kr = {
      0, 1,  0, -1
    };
    int[] kc = {
      1, 0, -1,  0
    };

    // All seems to be fine, select the current bubble.

    bubbles[row][col].setSelection(true);

    int count = 1;

    // Call recusively to check its neighbours in the valid directions.

    for(int i=0; i<4; i++)
    {
      int nr = row + kr[i];
      int nc = col + kc[i];

      count = count + this.makeBubbleSelection(nr, nc, type);
    }

    return count;
  }

  /**
   * Check is a location is valid in the game board.
   *
   * @Param  row    Index of the row of the location to test.
   * @Param  col    Index of the column of the location to test.
   * @Return  true if the location is valid in the board, false otherwise.
   */

  private boolean isValidLocation(int row, int col)
  {
    if(row < 0 || row >= this.rows ||
      col < 0 || col >= this.cols)
      return false;

    return true;
  }

  /**
   * Make a hit in the board by the user.
   *
   * This method is call indistinctly of the source: keyboard or mouse.
   * Also this method adds to the shot/exploded counters according with
   * the results of the hit.
   *
   * @Param  row    Index of the row of the hit.
   * @Param  col    Index of the column of the hit.
   * @Return  true if the hit was successful, false otherwise.
   */

  public boolean hit(int row, int col)
  {
    // Check if the location of the hit is valid.

    if(!isValidLocation(row, col))
      return false;

    // Check if there IS a bubble in that location.

    if(bubbles[row][col] == null)
      return false;

    // Check the board is NOT in hint mode.

    if(this.isHintMode())
      return false;

    // If the bubble was already selected: its explode time!

    if(bubbles[row][col].isSelected())
    {
      // This is really a shot.

      this.shots ++;

      // Explode the selected bubbles.

      this.exploded += this.explodeSelectedBubbles();

      // Compact the board vertically.

      this.makeExplodedBubblesFall();

      // Compact the board horizontally.

      this.collapseEmptyColumns();

      // Check if there are more moves or if the game has ended.

      if(this.toggleHints(false) == 0)
        this.gameOver = true;
    }
    else    // The bubble is not selected, so its just selection time!
    {
      // Clear any previous selection of the bubbles.

      this.cleanAllBubbleSelections();

      // Make the selection based on the current bubble.

      int count = this.makeBubbleSelection(row, col, bubbles[row][col].getType());

      // If there was only one selection means that there are not surrounding
      // friends of the bubble, undo the selection to avoid only-one-selected-bubble.

      if(count == 1)
        bubbles[row][col].setSelection(false);
    }

    return true;
  }

  /**
   * Handle the keyboard events related to the game board.
   *
   *     - SPACE: hit the currently selected bubble.
   *     - Arrow keys: move the cursor.
   *
   * @Param  key  The key code pressed in the keyboard.
   */

  public void handleCursor(int key)
  {
    switch(keyCode)
    {
    case KeyEvent.VK_SPACE:
      this.hit(cursor.row, cursor.col);
      break;

    case UP:
      this.moveCursor(-1, 0);
      break;

    case DOWN:
      this.moveCursor(1, 0);
      break;

    case LEFT:
      this.moveCursor(0, -1);
      break;

    case RIGHT:
      this.moveCursor(0, 1);
      break;
    }
  }

  /**
   * Move the cursor the amount of rows/columns specified.
   *
   * @Param  rows  Number of rows to move the cursor.
   * @Param  cols  Number of columns to move the cursor.
   * @Return true if the cursor was successfully moved, false otherwise.
   */

  private boolean moveCursor(int rows, int cols)
  {
    // Check if the new location of the cursor is valid.

    if(this.isValidLocation(cursor.row + rows, cursor.col + cols))
    {
      // Move the cursor.

      this.cursor = new Location(cursor.row + rows, cursor.col + cols);

      return true;
    }

    return false;
  }

  /**
   * Toggle the hint mode.
   *
   * In hint mode the board shows the available moves but it does not
   * receive shots.
   *
   * @Param  show  true  If the moves will be shown to the user, false to handle it internally.
   * @Return  The number of bubbles that can be exploded.
   */

  public int toggleHints(boolean show)
  {
    // Change the hint modes flag.

    this.hintMode = !this.hintMode;

    // If setting the hint mode off.

    if(!this.hintMode)
    {
      // Clear any bubble selection done previously.

      this.cleanAllBubbleSelections();

      return 0;
    }

    int total = 0;

    // Check each position of the board.

    for(int c=0; c<cols; c++)
    {
      for(int r=0; r<rows; r++)
      {
        int count = 0;

        // Check the selection of the bubbles (ignore empty spaces).

        if(bubbles[r][c] != null)
          count = this.makeBubbleSelection(r, c, bubbles[r][c].getType());

        // Avoid bubbles with no surrounding similars.

        if(count == 1)
        {
          bubbles[r][c].setSelection(false);
        }
        else
          total += count;
      }
    }

    // If its for internal handling, remove the hint mode inmediate.

    if(!show)
      this.toggleHints(false);

    return total;
  }
} // End of Universe class.

//////////////////////////////////////////////////