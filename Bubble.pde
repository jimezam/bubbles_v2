/**
 * This class models a bubble in the Universe.
 */

class Bubble
{
  /**
   * Code with the type of the bubble.
   */

  int type;

  /**
   * Width in pixels of the bubble.
   */

  int width;

  /**
   * Height in pixels of the bubble.
   */

  int height;

  /**
   * Flag that checks if the bubble IS selected.
   */

  boolean selected;

  /**
   * Graphical resource of the bubble.
   */

  PImage icon;

  /**
   * Create a new bubble.
   *
   * @Param  type  The type of the bubble.
   * @Param  width  The width in pixels of the bubble.
   * @Param  height  The height in pixels of the bubble.
   */

  public Bubble(int type, int width, int height)
  {
    // Check if the type is valid, we have 9 different types of bubbles.

    if(type < 1 || type > 9)
      throw new RuntimeException("Illegal bubble's type: " + type);

    this.type = type;
    this.width = width;
    this.height = height;

    this.selected = false;

    icon = loadImage("coins/fig" + this.type + ".png");

    icon.resize(this.width, this.height);
  }

  /**
   * Check if the bubble is currently selected.
   *
   * @Return  true if the bubble is selected, false otherwise.
   */

  public boolean isSelected()
  {
    return this.selected;
  }

  /**
   * Set the selection over the bubble.
   *
   * @Param  state  The new selection state.
   */

  public void setSelection(boolean state)
  {
    this.selected = state;
  }

  /**
   * Get the type of the bubble.
   *
   * @Return  The type of the bubble.
   */

  public int getType()
  {
    return this.type;
  }

  /**
   * Draw the bubble in the specified place.
   *
   * @Param  x    X coord. of the upper-left corner of the bubble.
   * @Param  y    Y coord. of the upper-left corner of the bubble.
   */

  public void draw(int x, int y)
  {
    // Check if its selected to draw the selection shadow.

    if(this.isSelected())
    {
      fill(color(255, 0, 0));
      stroke(color(255, 0, 0));
      rect(x, y, this.width, this.height);
    }

    // Draw the bubbles graphical resource.

    image(this.icon, x, y);
  }
}