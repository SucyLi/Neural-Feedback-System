import org.newdawn.slick.Input;

/**
 * This class is to use for when no data is entered. Meaning that the player is
 * only playing using the key "w". In our case, we are using data so this class
 * will not be used.
 *
 */
public class InputReader {
	static private boolean bPressedEnter;
	static private boolean bPressedW;

	public static boolean isbPressedEnter() {
		return bPressedEnter;
	}

	public static boolean isbPressedW() {
		return bPressedW;
	}

	/**
	 * Checks whether key pressed is W or Enter
	 * 
	 * @param input the key pressed on the keyboard
	 */
	public void updateGameInput(Input input) {
		// checks for keyboard input
		if (input.isKeyDown(Input.KEY_ENTER)) {
			bPressedEnter = true;
		}

		if (input.isKeyDown(Input.KEY_W)) {
			bPressedW = true;
		}
		bPressedEnter = false;
		bPressedW = false;
	}

}
