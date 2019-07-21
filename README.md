# CIT591-summer-2019-final-project-neuralfeedback

## Classes and methods
### Classifier
#### FmriClassificationModel.java
getTrainingData(): read preprocessed fMRI training data csv file

getTestData(): read preprocessed fMRI test data csv file

filterData(): get rid of attributes not useful for classification. Evaluate worth of a subset of attributes by considering individual predictive ability and level of redundancy between them. Search backwards and delete attributes until evaluation decreases. Will not be used in this case as the number of attributes (over 14k) is too great and the running time is too long but might be used for future datasets

buildNBClassifier(): build Naive Bayes classifier

buildTreeClassifier(): build Decision Tree classifier

buildSVMClassifier(): build Support Vector Machine classifier

combineModels(): combine models using AdaBoostM1. Boost a weak classifier by running the model multiple times and learns sequentially in an adaptive way by tweaking the subsequent weak models

modelEvaluation(): evaluate model performance. Return statistics showing the performance of the model used\

#### FmriClassify.java
main(): 
load training and test datasets 
implement classifier with highest accuracy on test set
get classification result on test set
generate binary classification results based on ground truth labels 

### NeuralFeedbackInterface
readResult(): read binary classification results
displayResult: show results as a car racing game interface

## Instructions to run the code 
### Download, install and import Weka machine learning library
Link to download: https://www.cs.waikato.ac.nz/ml/weka/downloading.html \
Import Weka to the project folder: WEKA API Tutorial "Introduction and Setting up Eclipse" https://www.youtube.com/playlist?list=PLea0WJq13cnBVfsPVNyRAus2NK-KhCuzJ

