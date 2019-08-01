import java.util.ArrayList;
import java.util.Scanner;

public class ThreadClinician extends Thread {

	@Override
	public void run() {
		
		FmriClassification c = new FmriClassification();
		c.svmClassify();
		c.printToText();
		ArrayList<String> actualMoves = c.getActualMoves();
		ArrayList<String> predictedMoves = c.getPredictions();

		GUIClinician clinician = new GUIClinician("fMRI_test.nii");
		clinician.waitSignal();
		
		Scanner in = new Scanner(System.in);
		System.out.println("\n ***Please press Enter to show fMRI data*** ");
		String key = in.nextLine();
		boolean isEnter = false;
		
		while (!isEnter) {
			if (key.isEmpty()) {
				in.close();
				isEnter = true;
			} else {
				System.out.println("Invalid input. Please press Enter.");
				key = in.nextLine();
			}
		}
		
		clinician.draw(actualMoves, predictedMoves);
		
	}
}
