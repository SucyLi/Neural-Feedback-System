import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.state.StateBasedGame;

public class SetupGame extends StateBasedGame {
	public static int SCREEN_X = 960;
	public static int SCREEN_Y = 900;
	final static int SKY_DIMENSION_Y = 2085;
	
	public static final String title = "Neural Network Motor Game";
	public static final int menu = 0;
	public static final int play = 1;
	
//	public SetupGame(String title) {
//		super(title);
//	}
	
	public SetupGame(String gameName) {
		super(gameName);
		this.addState(new Menu(menu));
		this.addState(new Play(play));
	}
	
	@Override
	public void initStatesList(GameContainer gc) throws SlickException {
		// TODO Auto-generated method stub
		this.getState(menu).init(gc, this);
		this.getState(play).init(gc, this);
		this.enterState(menu);
	}
	
	public static void main(String[] args) throws SlickException {
		
		SetupGame set = new SetupGame("Setup Test");
		AppGameContainer app = new AppGameContainer(set);
		
		app.setDisplayMode(SCREEN_X, SCREEN_Y, false);
		//app.setAlwaysRender(true);
		
		app.start();
	}
}
