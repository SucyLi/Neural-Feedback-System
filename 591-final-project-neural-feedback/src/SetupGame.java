import org.newdawn.slick.GameContainer;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.state.StateBasedGame;

public class SetupGame extends StateBasedGame {
	public static int SCREEN_X = 960;
	public static int SCREEN_Y = 900;
	final static int SKY_DIMENSION_Y = 2085;

	public static final String title = "Neural Network Motor Game";
	public static final int menu = 0;
	public static final int play = 1;

	/**
	 * Setup game constructor
	 * 
	 * @param gameName the name we want our interface window to be named
	 */
	public SetupGame(String gameName) {
		super(gameName);
		this.addState(new Menu(menu));
		this.addState(new Play(play));
	}

	/**
	 * Initializes the game with the different states possible
	 */
	@Override
	public void initStatesList(GameContainer gc) throws SlickException {
		// TODO Auto-generated method stub
		this.getState(menu).init(gc, this);
		this.getState(play).init(gc, this);
		this.enterState(menu);
	}
}
