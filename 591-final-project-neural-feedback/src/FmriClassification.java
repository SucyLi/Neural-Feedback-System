import java.io.FileWriter;
import java.io.IOException;
import java.util.*;
import weka.classifiers.Classifier;
import weka.core.Instance;
import weka.core.Instances;

public class FmriClassification {
	private ArrayList<String> predictions = new ArrayList<String>();
	private ArrayList<String> actualMoves = new ArrayList<String>();

	/**
	 * Method to get the predictions based on the SVM model. Tested Naive Bayes
	 * model, Decision Tree model, Naive Bayes Model boosted 10 times by Adaboost,
	 * and Decision Tree model boosted 10 times by Adaboost and Support Vector
	 * Model. The support vector model is the best performing one with around 93%
	 * accuracy while boosted models only reached up to 86%. 10-fold cross
	 * validation testing was also used. Here we use our test data set as our
	 * simulated data set.
	 * 
	 * @return an array list of string with each element being a predicted move
	 */
	public ArrayList<String> svmClassify() {
		FmriClassificationModel classification = new FmriClassificationModel();
		Instances trainingDataset = classification.getTrainingData();
		Instances testDataset = classification.getTestData();
		// build SVM model
		Classifier svmModel = classification.buildSVMClassifier(trainingDataset);
		for (int i = 0; i < testDataset.numInstances(); i++) {
			Instance newInstance = testDataset.instance(i);
			try {
				double actualIndex = testDataset.instance(i).classValue();
				String actualMove = testDataset.classAttribute().value((int) actualIndex);
				double predIndex = svmModel.classifyInstance(newInstance);
				String predictedMove = testDataset.classAttribute().value((int) predIndex);
				
				if (predictedMove.equals("FingerMovement")) {
					predictions.add("Finger");
				} else if (predictedMove.equals("FootMovement")) {
					predictions.add("Foot");
				} else if (predictedMove.equals("LipsMovement")) {
					predictions.add("Lips");
				} else if (predictedMove.equals("Resting")) {
					predictions.add("Resting");
				} 
				
				if (actualMove.equals("FingerMovement")) {
					actualMoves.add("Finger");
				} else if (actualMove.equals("FootMovement")) {
					actualMoves.add("Foot");
				} else if (actualMove.equals("LipsMovement")) {
					actualMoves.add("Lips");
				} else if (actualMove.equals("Resting")) {
					actualMoves.add("Resting");
				} 
				
//				predictions.add(predictedMove);
//				actualMoves.add(actualMove);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return predictions;
	}

	/**
	 * Prints the instruction (actual move) and the prediction in sequence in a text
	 * file for the TA to check all moves done.
	 */
	public void printToText() {
		String fileName = "labels.txt";
		String instructionsAndPredictions = "";
		for (int i = 0; i < predictions.size(); i++) {
			instructionsAndPredictions = instructionsAndPredictions + actualMoves.get(i) + "," + predictions.get(i)
					+ "\n";
		}
		FileWriter fw;
		try {
			fw = new FileWriter(fileName);
			fw.write(instructionsAndPredictions);
			fw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public ArrayList<String> getPredictions() {
		return predictions;
	}

	public ArrayList<String> getActualMoves() {
		return actualMoves;
	}

	public static void main(String[] args) {
		FmriClassification c = new FmriClassification();
		c.svmClassify();
		c.printToText();
	}

}
