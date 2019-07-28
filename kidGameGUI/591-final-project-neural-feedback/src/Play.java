import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

public class Play extends BasicGameState{
	boolean bUsingData;
	
	//player stats
	int numSuccess;
	int numFails;
	
	Balloon balloon;
	Sky sky1;
	Sky sky2;
	
	InputProcessor ip;
	
	public Play(int state) {
		
	}
	
	@Override
	public void init(GameContainer arg0, StateBasedGame arg1) throws SlickException {
		// TODO Auto-generated method stub
		ip = new InputProcessor();	
		balloon = new Balloon(200, 120);
		sky1 = new Sky(0, 0);
		sky2 = new Sky(SetupGame.SCREEN_X, 0);
		ip.bInputSuccess = false;
		bUsingData = false;
	}

	@Override
	public void render(GameContainer gc, StateBasedGame arg1, Graphics g) throws SlickException {
		// TODO Auto-generated method stub
		
		Image imgBalloon = new Image("sprites/balloon.png");
		Image imgSky = new Image("sprites/bg-sky.png");
		Image imgSky2 = new Image("sprites/bg-sky.png");
		imgSky.draw(sky1.x, sky1.y);
		imgSky2.draw(sky2.x, sky2.y);
		imgBalloon.draw(balloon.x, balloon.y, balloon.BALLOON_SCALE);
		
		if (ip.bInputSuccess) {
			g.drawString("GOOD JOB!", (SetupGame.SCREEN_X / 2 - 100), (SetupGame.SCREEN_Y / 2 - 20));
		}
	}

	@Override
	public void update(GameContainer gc, StateBasedGame arg1, int arg2) throws SlickException {
		// TODO Auto-generated method stub
		long currTime = System.currentTimeMillis();
		System.out.println(currTime);
		if (bUsingData) {
			ip.updateInputData(ip.getInputData(), currTime);
		}
		else {
			ip.updateInputKeyboard(gc.getInput(), currTime);
			if (ip.isInputProcessing(currTime)) {
				balloon.move();
			}
			else {
				balloon.fall();
			}
		}
		
		sky1.scroll();
		sky2.scroll();
	}

	@Override
	public int getID() {
		// TODO Auto-generated method stub
		return 1;
	}

}
