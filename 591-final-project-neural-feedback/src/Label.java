
public class Label {
	boolean bVisible;
	boolean bDraw;
	long lastLabelDrawTime;
	String ID;
	
	//Check if need to draw a new label
	//if so determine which label to draw and set time drawn
	public void checkVisible(String labelID, long currTime) {
		if (this.bDraw && !this.bVisible) {
			this.lastLabelDrawTime = currTime;
			this.ID = labelID;
		}
	}
}
