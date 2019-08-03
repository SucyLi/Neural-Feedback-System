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
	int actualMovesIndex;
	long lastMoveTime;

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

	ArrayList<String> actualMoves;
	
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
		lastMoveTime = 0;
		
		actualMoves = new ArrayList<>();
		
		//init variables
		ip.bInputSuccess = false;
		bUsingData = false;
		bDrawLabel = false;
		actualMoves = cl.getActualMoves();
		actualMovesIndex = 0;
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
		Image labelRest = new Image("sprites/label-rest.png");
		
		//balloon and sky positions
		imgSky.draw(sky1.x, sky1.y);
		imgSky2.draw(sky2.x, sky2.y);
		imgBalloon.draw(balloon.x, balloon.y, balloon.BALLOON_SCALE);
		
		//create labels
		if (label.bDraw) {
//			System.out.println(label.ID);
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
			case "Resting":
				labelRest.draw(125, (SetupGame.SCREEN_Y - 225));
				break;
			}

			label.bVisible = true;
		} else {
			label.bVisible = false;
		}
		
		//write text
		g.setFont(ttf);
		
		if (dp.isRightMove()) {
			g.drawString("GOOD JOB!", (SetupGame.SCREEN_X / 2 - 100), (SetupGame.SCREEN_Y / 2 - 20));
		}

		g.drawString("Elevation: " + balloon.elevation, SetupGame.SCREEN_X - 250, 0);

	}

	@Override
	public void update(GameContainer gc, StateBasedGame arg1, int arg2) throws SlickException {
		ir.updateGameInput(gc.getInput());
		long currTime = System.currentTimeMillis();
			
		// process input
		if (dp.isUsingData()) {
			while ((currTime - lastMoveTime) > 2432) {
				System.out.println("GET");
				actualMovesIndex = dp.getArrayIndex();
				lastMoveTime = currTime;
				System.out.println("actualMovesIndex = " + actualMovesIndex);
				System.out.println("ID = " + actualMoves.get(actualMovesIndex));
				// should label be drawn
				label.bDraw = ip.shouldDrawLabel(currTime);
				label.checkVisible(actualMoves.get(actualMovesIndex), currTime);
				ip.updateInputData(dp.getData(), currTime);
			}
		} else {
			ip.updateInputKeyboard(currTime);
		}

		//update sky speed
		int modSkySpeed = 1;
		if (ip.isInputProcessing(currTime)) {
			modSkySpeed = 6;
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
