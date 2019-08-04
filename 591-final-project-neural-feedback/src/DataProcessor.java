import java.io.File;
import java.util.ArrayList;

public class DataProcessor {
	private int arrayIndex = 36;
	private boolean rightMove;

	/**
	 * Check if the game is using data by checking if the file is there. This can
	 * eventually become a scanner taking in the file that the user wants to use but
	 * we did not want to leave any room for confusion so we decided for the user
	 * since we are exclusively using simulated data in our game
	 * 
	 * @return true if the file is found, false otherwise
	 */
	public boolean isUsingData() {
		File f = new File("fmriDataTest.csv");
		if (f.exists()) {
			return true;
		}
		return false;
	}

	// should return true if input was successful
	// this runs every frame so should only return data every once in a while
	/**
	 * Check if the input was successfully, meaning that we compare the predicted
	 * move (from SVM model) to the instruction (which is in our case actual move
	 * since we are using simulated data).
	 * 
	 * @return
	 */
	public boolean getData() {
		FMRIClassification cl = new FMRIClassification();
		ArrayList<String> actualMoves = cl.getActualMoves();
		ArrayList<String> predictedMoves = cl.getPredictions();
		try {
			if (actualMoves.get(arrayIndex).equals(predictedMoves.get(arrayIndex))) {
				arrayIndex++;
				rightMove = true;
				return true;
			}
		} catch (IndexOutOfBoundsException e) {

		}
		arrayIndex++;
		rightMove = false;
		return false;
	}

	/**
	 * Get method to return if the kid followed instruction or not
	 * 
	 * @return true if kid followed instruction, false otherwise
	 */
	public boolean isRightMove() {
		return rightMove;
	}

	/**
	 * Get method to return the index of the array list containing instructions
	 * (actual moves) after the frame update
	 * 
	 * @return an integer representing the index where the game is in the arraylist
	 */
	public int getArrayIndex() {
		return arrayIndex;
	}
}
