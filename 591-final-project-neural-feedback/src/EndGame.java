import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

public class EndGame extends BasicGameState {
	
	/**
	 * EndGame Menu constructor
	 * 
	 * @param state the integer representing the state of the game
	 */
	public EndGame(int state) {
		;
	}
	
	@Override
	public void init(GameContainer arg0, StateBasedGame arg1) throws SlickException {
		// TODO Auto-generated method stub

	}

	@Override
	public void render(GameContainer arg0, StateBasedGame arg1, Graphics arg2) throws SlickException {
		// TODO Auto-generated method stub
		arg2.drawString(
				"Game over. Thank you for your participation.\n Please contact with doctor to get feedback",
				(SetupGame.SCREEN_X / 2 - 100), (SetupGame.SCREEN_Y / 2 - 20));
	}

	@Override
	public void update(GameContainer arg0, StateBasedGame arg1, int arg2) throws SlickException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int getID() {
		// TODO Auto-generated method stub
		return 2;
	}

}
