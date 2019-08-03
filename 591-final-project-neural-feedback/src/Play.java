import java.util.ArrayList;
import java.util.Random;

import org.newdawn.slick.*;
import org.newdawn.slick.state.*;

import org.newdawn.slick.TrueTypeFont;
import java.awt.Font;


public class Play extends BasicGameState {
	boolean bUsingData;
	boolean bDrawLabel;

	// player stats
	int numSuccess;
	int numFails;

	Balloon balloon;
	Sky sky1;
	Sky sky2;
	Label label;
	Random rand;

	DataProcessor dp;
	InputProcessor ip;
	InputReader ir;
	
	TrueTypeFont ttf;

	FmriClassification cl;

	public Play(int state) {

	}

	@Override
	public void init(GameContainer arg0, StateBasedGame arg1) throws SlickException {
		//processor classes
		rand = new Random();
		dp = new DataProcessor();
		ip = new InputProcessor();
		ir = new InputReader();
		cl = new FmriClassification();
		
		//sprite classes
		balloon = new Balloon((SetupGame.SCREEN_X / 2 - 50), SetupGame.SCREEN_Y / 2);
		sky1 = new Sky(0, (-SetupGame.SKY_DIMENSION_Y + SetupGame.SCREEN_Y));
		sky2 = new Sky(0, ((-SetupGame.SKY_DIMENSION_Y * 2) + SetupGame.SCREEN_Y));
		label = new Label();
		
		//init variables
		ip.bInputSuccess = false;
		bUsingData = false;
		bDrawLabel = false;
		Font font = new Font("Helvetica", Font.BOLD, 30);
		ttf = new TrueTypeFont(font, true); 
	}

	@Override
	public void render(GameContainer gc, StateBasedGame arg1, Graphics g) throws SlickException {
		// TODO Auto-generated method stub

		Image imgBalloon = new Image("sprites/balloon.png");
		Image imgSky = new Image("sprites/bg-sky-vert-1.png");
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
			case "Foot":
				labelFoot.draw(125, (SetupGame.SCREEN_Y - 225));
				break;
			case "Finger":
				labelFinger.draw(125, (SetupGame.SCREEN_Y - 225));
				break;
			case "Lips":
				labelLips.draw(125, (SetupGame.SCREEN_Y - 225));
				break;
			}

			label.bVisible = true;
		} else {
			label.bVisible = false;
		}
		
		g.setFont(ttf);
		
		if (dp.isRightMove()) {
			g.drawString("GOOD JOB!", (SetupGame.SCREEN_X / 2 - 100), (SetupGame.SCREEN_Y / 2 - 20));
		}

		g.drawString("Elevation: " + balloon.elevation, SetupGame.SCREEN_X - 250, 0);

	}

	@Override
	public void update(GameContainer gc, StateBasedGame arg1, int arg2) throws SlickException {
		ArrayList<String> actualMoves = cl.getActualMoves();
		int index = dp.getArrayIndex();

		long currTime = System.currentTimeMillis();

		int modSkySpeed = 1;
		
		ir.updateGameInput(gc.getInput());

		// process input
		if (dp.isUsingData()) {
			label.bDraw = ip.shouldDrawLabel(currTime);
			label.checkVisible(actualMoves.get(index), currTime);
			// should label be drawn
			if (label.bDraw) {
				// draw new label
				ip.updateInputData(dp.getData(), currTime);
			}
		} else {
			ip.updateInputKeyboard(currTime);
		}

		if (ip.isInputProcessing(currTime)) {
			modSkySpeed = 6;
		}
		
		
		try {
			Thread.sleep(800);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}

		// update balloon elevation
		if (currTime - balloon.elevationTimer > (480 / modSkySpeed)) {
			balloon.elevationTimer = currTime;
			balloon.elevation += 1;
		}


		// move sky
		sky1.scroll(modSkySpeed);
		sky2.scroll(modSkySpeed);

	}

	@Override
	public int getID() {
		// TODO Auto-generated method stub
		return 1;
	}

}
