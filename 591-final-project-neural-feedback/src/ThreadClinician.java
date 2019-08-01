import java.util.ArrayList;

public class ThreadClinician extends Thread{

   public void run(){
	   	FmriClassification c = new FmriClassification();
		c.svmClassify();
		c.printToText();
		ArrayList<String> actualMoves = c.getActualMoves();
		ArrayList<String> predictedMoves = c.getPredictions();
		GUIClinician clinician = new GUIClinician();
		clinician.draw(actualMoves, predictedMoves);
   }
}