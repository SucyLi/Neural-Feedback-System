import org.newdawn.slick.Input;

public class InputProcessor {
	final int INPUT_WAIT = 3000;
	
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
	
	public void updateInputKeyboard(Input input, long currTime) {
		if (input.isKeyDown(Input.KEY_W) && (!this.bInputSuccess)) {
			updateInputChecks(currTime);
		}
	}
	
	public void updateInputData(int input, long currTime) {
		if (input == 1){
			updateInputChecks(currTime);
		}
	}
}
