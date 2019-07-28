import org.newdawn.slick.Input;

public class InputProcessor {
	final int INPUT_WAIT = 3000;
	final int LABEL_WAIT = INPUT_WAIT * 2;
	int lastLabelDrawTime = 0;
	
	//input
	boolean bInputSuccess = false;
	long lastInputTime = 0;
	
	public InputProcessor() {
		this.bInputSuccess = false;
		this.lastInputTime = 0;
	}
	
	public int getInputData() {
		//TODO should return 0 or 1, failure or success, or be a boolean
		return 0;
	}
	
	public boolean isInputProcessing(long currentTime) {
		if (bInputSuccess) {
			if (currentTime - this.lastInputTime < INPUT_WAIT) {
				return true;
			}
			else {
				this.bInputSuccess = false;
			}
		}
		return false;
	}
	
	public void updateInputChecks(long currTime) {
		this.bInputSuccess = true;
		this.lastInputTime = currTime;
//		numSuccess+= 1;
	}
	
	//checks for keyboard input
	public void updateInputKeyboard(Input input, long currTime) {
		if (input.isKeyDown(Input.KEY_W) && (!this.bInputSuccess)) {
			updateInputChecks(currTime);
		}
	}
	
	//checks for data input
	public void updateInputData(boolean b, long currTime) {
		if (b){
			updateInputChecks(currTime);
		}
	}
	
	public boolean shouldDrawLabel(long currTime) {
		if (((currTime - this.lastLabelDrawTime) > LABEL_WAIT) && (!this.bInputSuccess)){
			return true;
		}
		
		return false;
	}
}
