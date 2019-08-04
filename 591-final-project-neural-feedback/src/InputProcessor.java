
public class InputProcessor {
	static final int INPUT_WAIT = 1000;
	int lastLabelDrawTime = 0;
	boolean bInputSuccess = false;
	long lastInputTime = 0;

	/**
	 * Input processor constructor initializing the inputSuccess check and the time
	 * of the input
	 */
	public InputProcessor() {
		this.bInputSuccess = false;
		this.lastInputTime = 0;
	}

	/**
	 * Checks if the input is processing by comparing the time between current input
	 * and last time there was an input
	 * 
	 * @param currentTime the current time in milliseconds recorded by the system
	 * @return true if the input is processing, false otherwise
	 */
	public boolean isInputProcessing(long currentTime) {
		if (bInputSuccess) {
			if (currentTime - this.lastInputTime < INPUT_WAIT) {
				return true;
			} else {
				this.bInputSuccess = false;
			}
		}
		return false;
	}

	/**
	 * Set input success to true and update current time
	 * 
	 * @param currTime the current time in milliseconds recorded by the system
	 */
	public void updateInputChecks(long currTime) {
		this.bInputSuccess = true;
		this.lastInputTime = currTime;
	}

	/**
	 * Update input checks if the user is using data, (which is what we are doing in
	 * our case)
	 * 
	 * @param b        a parameter to check if the input is correctly entered
	 *                 (getData() method from DataProcessor)
	 * @param currTime the current time in milliseconds recorded by the system
	 */
	public void updateInputData(boolean b, long currTime) {
		if (b) {
			updateInputChecks(currTime);
		}
	}
}
