package weka.api;

import weka.classifiers.Classifier;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.trees.J48;
import weka.core.Instances;

public class FmriClassify {
	
	public static void main(String[] args) {
		FmriClassificationModel classification = new FmriClassificationModel();
		Instances trainingDataset = classification.getTrainingData();
		Instances testDataset = classification.getTestData();
		// SVM Model: this is the best performing model with 93% accuracy
		//10-fold Cross validation metrics was also quite high for the SVM model 
		Classifier svmModel = classification.buildSVMClassifier(trainingDataset);
		classification.modelEvaluation(svmModel, trainingDataset, testDataset);

		// Naive Bayes Model
		Classifier nbModel = classification.buildNBClassifier(trainingDataset);
		classification.modelEvaluation(nbModel, trainingDataset, testDataset);
		
		// Boost Naive Bayes by combining 10 Naive Bayes models
		NaiveBayes nb = new NaiveBayes();
		Classifier m2 = classification.combineModels(nb, trainingDataset);
		classification.modelEvaluation(m2, trainingDataset, testDataset);

		// Decision Tree Model
		Classifier treeModel = classification.buildTreeClassifier(trainingDataset);
		classification.modelEvaluation(treeModel, trainingDataset, testDataset);

		// Boost the decision tree by combining 10 tree models
		J48 tree = new J48();
		Classifier m1 = classification.combineModels(tree, trainingDataset);
		classification.modelEvaluation(m1, trainingDataset, testDataset);
	}
}
