import java.io.File;
import java.util.ArrayList;

public class DataProcessor {
	private int arrayIndex = 0;
	
	//check if the game is using data
	//this should check if data is properly loaded and if so, return true
	//can also add an option in the main menu asking the player whether to use data or input when data is loaded
	public boolean isUsingData() {
		File f = new File ("fmriDataTest.csv");
		if (f.exists()) {
			return true;
		}
		return false;
	}
	
	//should return true if input was successful
	//this runs every frame so should only return data every once in a while
	public boolean getData() {
		FmriClassification cl = new FmriClassification();
		ArrayList<String> actualMoves = cl.getActualMoves();
		ArrayList<String> predictedMoves = cl.getPredictions();
		arrayIndex++;
		if (actualMoves.get(arrayIndex).equals(predictedMoves.get(arrayIndex))){
			System.out.println(arrayIndex);
			return true;
		}
		return false;
	}

	public int getArrayIndex() {
		return arrayIndex;
	}
}
