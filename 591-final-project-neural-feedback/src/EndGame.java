import java.awt.Font;

import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

public class EndGame extends BasicGameState {
	private long roundedAccuracy;
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
		//calculate accuracy
		double accuracy = (Play.numSuccess * 1.0f) / ((Play.numSuccess + Play.numFail) * 1.0f);
		accuracy = accuracy * 100;
		roundedAccuracy = Math.round(accuracy);
	}

	@Override
	public void render(GameContainer arg0, StateBasedGame arg1, Graphics g) throws SlickException {
		// TODO Auto-generated method stub
		Image bg =  new Image("sprites/screen-end.png");
		bg.draw(0, 0);
		Font font = new Font("Helvetica", Font.BOLD, 100);
		TrueTypeFont ttf = new TrueTypeFont(font, true);
		g.setFont(ttf);
		g.drawString(roundedAccuracy + "%",
				(SetupGame.SCREEN_X / 2 - 120), (SetupGame.SCREEN_Y / 2 + 100));
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
