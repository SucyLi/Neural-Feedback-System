import org.newdawn.slick.Input;

public class InputReader {
	static private boolean bPressedEnter;
	static private boolean bPressedW;
	
	public static boolean isbPressedEnter() {
		return bPressedEnter;
	}

	public static boolean isbPressedW() {
		return bPressedW;
	}
	
	public void updateGameInput(Input input){
		//checks for keyboard input
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
