import java.util.ArrayList;

import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.SlickException;


public class GameLauncher {
	
	public static void main(String[] args) throws SlickException {
		int SCREEN_X = 960;
		int SCREEN_Y = 900;
		
		FmriClassification c = new FmriClassification();
		c.svmClassify();
		c.printToText();
		ArrayList<String> actualMoves = c.getActualMoves();
		ArrayList<String> predictedMoves = c.getPredictions();
		
		GUIClinician clinician = new GUIClinician();
		clinician.draw(actualMoves, predictedMoves);
		
		SetupGame set = new SetupGame("Setup Test");
		AppGameContainer app = new AppGameContainer(set);
		app.setDisplayMode(SCREEN_X, SCREEN_Y, false);
		//app.setAlwaysRender(true);
		app.start();
	}	
	
}
