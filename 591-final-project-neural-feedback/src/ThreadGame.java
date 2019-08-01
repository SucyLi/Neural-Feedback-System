import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.SlickException;

public class ThreadGame implements Runnable{
	boolean bActivateAction;

	int SCREEN_X = 960;
	int SCREEN_Y = 900;
	
	public void setbActivateAction(boolean bActivateAction) {
		this.bActivateAction = bActivateAction;
	}

	public void run() {
		SetupGame set = new SetupGame("Setup Test");
		AppGameContainer app;
		try {
			app = new AppGameContainer(set);
			app.setDisplayMode(SCREEN_X, SCREEN_Y, false);
			app.setAlwaysRender(true);
			app.start();
		} catch (SlickException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
