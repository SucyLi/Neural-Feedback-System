package weka.api;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import weka.core.Instances;

class FmriClassificationModelTest {
	
	/**
	 * Tests whether our uploaded training data has the right number
	 * of instances and attributes
	 */
	@Test
	void trainingDataset() {
		FmriClassificationModel f = new FmriClassificationModel();
		Instances trainingDataset = f.getTrainingData();
		assertEquals(trainingDataset.numAttributes(), 14819); //14818 attributes plus one class attribute
		assertEquals(trainingDataset.numInstances(), 108); //the number of rows minus the first row
	}
	
	/**
	 * Tests whether our uploaded test data has the right number
	 * of instances and attributes
	 */
	@Test
	void testDataset() {
		FmriClassificationModel f = new FmriClassificationModel();
		Instances trainingDataset = f.getTestData();
		assertEquals(trainingDataset.numAttributes(), 14819); //14818 attributes plus one class attribute
		assertEquals(trainingDataset.numInstances(), 72); //the number of rows minus the first row
	}

}
