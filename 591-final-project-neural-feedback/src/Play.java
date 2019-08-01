import java.util.Random;

import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

public class Play extends BasicGameState{
	boolean bUsingData;
	boolean bDrawLabel;
	
	//player stats
	int numSuccess;
	int numFails;
	
	Balloon balloon;
	Sky sky1;
	Sky sky2;
	Label label;
	Random rand;
	
	DataProcessor dp;
	InputProcessor ip;
	
	public Play(int state) {
		
	}
	
	@Override
	public void init(GameContainer arg0, StateBasedGame arg1) throws SlickException {
		// TODO Auto-generated method stub
		rand = new Random();
		dp = new DataProcessor();
		ip = new InputProcessor();	
		balloon = new Balloon((SetupGame.SCREEN_X / 2 - 50), SetupGame.SCREEN_Y / 2);
		sky1 = new Sky(0, (-SetupGame.SKY_DIMENSION_Y + SetupGame.SCREEN_Y));
		sky2 = new Sky(0, ((-SetupGame.SKY_DIMENSION_Y * 2) + SetupGame.SCREEN_Y));
		label = new Label();
		ip.bInputSuccess = false;
		bUsingData = false;
		bDrawLabel = false;
	}

	@Override
	public void render(GameContainer gc, StateBasedGame arg1, Graphics g) throws SlickException {
		// TODO Auto-generated method stub
		
		Image imgBalloon = new Image("sprites/balloon.png");
		Image imgSky = new Image ("sprites/bg-sky-vert-1.png");
		Image imgSky2 = new Image("sprites/bg-sky-vert-2.png");
		Image labelFoot = new Image("sprites/label-foot.png");
		Image labelFinger = new Image("sprites/label-finger.png");
		Image labelLips = new Image("sprites/label-lips.png");
		
		imgSky.draw(sky1.x, sky1.y);
		imgSky2.draw(sky2.x, sky2.y);
		imgBalloon.draw(balloon.x, balloon.y, balloon.BALLOON_SCALE);
		
		if (label.bDraw) {
			System.out.println(label.ID);
			switch (label.ID) {
				case 0:
					labelFoot.draw(125, (SetupGame.SCREEN_Y - 225));
					break;
				case 1:
					labelFinger.draw(125, (SetupGame.SCREEN_Y - 225));
					break;
				case 2:
					labelLips.draw(125, (SetupGame.SCREEN_Y - 225));
					break;
			}
			
			label.bVisible = true;
		}
		else {
			label.bVisible = false;
		}
		
		if (ip.bInputSuccess) {
			g.drawString("GOOD JOB!", (SetupGame.SCREEN_X / 2 - 100), (SetupGame.SCREEN_Y / 2 - 20));
		}
		
		g.drawString("Elevation: " + balloon.elevation, SetupGame.SCREEN_X - 150, 0);
	}

	@Override
	public void update(GameContainer gc, StateBasedGame arg1, int arg2) throws SlickException {
		// TODO Auto-generated method stub
		long currTime = System.currentTimeMillis();
		
		int modSkySpeed = 1;
		
		//process input
		if (dp.isUsingData()) {
			ip.updateInputData(dp.getData(), currTime);
		}
		else {
			ip.updateInputKeyboard(gc.getInput(), currTime);
		}
		
		if (ip.isInputProcessing(currTime)){
			modSkySpeed = 6;
		}
		
		//update balloon elevation
		if (currTime - balloon.elevationTimer > (480 / modSkySpeed)) {
			balloon.elevationTimer = currTime;
			balloon.elevation += 1;
		}
		
		//should label be drawn
		label.bDraw = ip.shouldDrawLabel(currTime);
		
		//draw new label
		label.checkVisible(rand.nextInt(3), currTime);
		
		//move sky
		sky1.scroll(modSkySpeed);
		sky2.scroll(modSkySpeed);
	}

	@Override
	public int getID() {
		// TODO Auto-generated method stub
		return 1;
	}

}
