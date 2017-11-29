/**
 * This class represents a position (row, column) in the universe (matrix).
 */

public class Location
{
  /**
   * Index of the row.  Starts on zero.
   */

  int row;

  /**
   * Index of the column.  Starts on zero.
   */
  int col;

  /**
   * Creates a new location.
   */

  public Location(int row, int col)
  {
    this.row = row;
    this.col = col;
  }
} // End of Location class.

//////////////////////////////////////////////////