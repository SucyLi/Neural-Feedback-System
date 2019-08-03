import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

public class Menu extends BasicGameState {

	/**
	 * Game Menu constructor
	 * 
	 * @param state the integer representing the state of the game
	 */
	public Menu(int state) {
		;
	}

	@Override
	public void init(GameContainer arg0, StateBasedGame arg1) throws SlickException {
		// TODO Auto-generated method stub
	}

	/**
	 * method to display menu on the GUI
	 */
	@Override
	public void render(GameContainer gc, StateBasedGame arg1, Graphics g) throws SlickException {
		g.drawString("Motor Game Instruction", (SetupGame.SCREEN_X / 2 - 70), (SetupGame.SCREEN_Y / 2 - 200));
		g.drawString("Please follow the movement instruction on the screen and take corresponding movement.", (SetupGame.SCREEN_X / 2 - 360), (SetupGame.SCREEN_Y / 2 - 150));
		g.drawString("If you perform the movement correctly, a balloon will go up. Try your best to keep ", (SetupGame.SCREEN_X / 2 - 360), (SetupGame.SCREEN_Y / 2 - 100));
		g.drawString("the balloon going up!", (SetupGame.SCREEN_X / 2 - 360), (SetupGame.SCREEN_Y / 2 - 50));
		g.drawString("Ready? Press ENTER to start.", (SetupGame.SCREEN_X / 2 - 360), (SetupGame.SCREEN_Y / 2));
	}

	/**
	 * Method to update the game menu. If "Enter" is pressed, then the Clinician GUI
	 * is launched with a pause allowing it to load and we go to the state number 1
	 * of the game which is the play() state
	 */
	@Override
	public void update(GameContainer gc, StateBasedGame sbg, int arg2) throws SlickException {
		// TODO Auto-generated method stub
		Input input = gc.getInput();
		if (input.isKeyDown(Input.KEY_ENTER)) {
			Thread threadClinician = new ThreadClinician();
			threadClinician.start();
			try {
				Thread.sleep(4000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			sbg.enterState(1);
		}
	}

	@Override
	public int getID() {
		// TODO Auto-generated method stub
		return 0;
	}

}
