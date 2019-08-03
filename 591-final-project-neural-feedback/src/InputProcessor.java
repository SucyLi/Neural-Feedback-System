
public class InputProcessor {
	final int INPUT_WAIT = 3000;
	final int LABEL_WAIT = INPUT_WAIT * 2;
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
	 * Update input checks if there is no data. Meaning, when there is no data and
	 * the user is playing the game using the "w" key
	 * 
	 * @param currTime
	 */
	public void updateInputKeyboard(long currTime) {
		if ((InputReader.isbPressedW()) && (!this.bInputSuccess)) {
			updateInputChecks(currTime);
		}
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

	/**
	 * Check to see if a label should be drawn by comparing the time of the last
	 * label to the current time. If is higher than 6000ms, then draw label.
	 * 
	 * @param currTime the current time in milliseconds recorded by the system
	 * @return true if a label should be drawn, false otherwise
	 */
	public boolean shouldDrawLabel(long currTime) {
		if (((currTime - this.lastLabelDrawTime) > LABEL_WAIT)) {
			return true;
		}

		return false;
	}
}
