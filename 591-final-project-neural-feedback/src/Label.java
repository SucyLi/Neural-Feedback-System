
public class Label {
	boolean bVisible;
	boolean bDraw;
	long lastLabelDrawTime;
	String ID;

	/**
	 * Check to see if a new label needs to be drawn
	 * If so determine which label to draw and set time drawn
	 * 
	 * @param labelID the label to draw (foot, rest, lips, finger)
	 * @param currTime the current time in milliseconds recorded by the system
	 */
	public void checkVisible(String labelID, long currTime) {
		if (this.bDraw) {
			this.lastLabelDrawTime = currTime;
			this.ID = labelID;
		}
	}
}
