# CIT591-summer-2019-final-project-neuralfeedback

## Project name
### Real-time Neural Feedback Simulation System for Children with Autism

## Description
Autistic children perceive external environment atypically according to current research. This real-time neural feedback simulation system is to help children with Autism to learn how to perform motor tasks correctly. It will take neural data (fMRI) as the input, use machine learning classifier to classify the signal, show the classification result in 2 perspectives - clinician's view and kid's view. Clinician's GUI shows brain axial scans with expected and detected labels. Kid's GUI uses a balloon flight game to tell kids feedback if they are performing the task correctly. 

## Team
Benjamin Lopez Barba, Ervin Gan, Xinhui Li

## Work Breakdown
Benjamin: build Game GUI, add corresponding JUnit tests, record video \
Ervin: build machine learning classifiers, help with Game GUI, add corresponding JUnit tests, organize all libraries and scripts \
Xinhui: test machine learning classifiers, build Clinician GUI, preprocess fMRI data, add corresponding JUnit tests

## Environment Set-up
1 Open terminal, go to directory you want to save the project folder, type 
```shell
git clone https://github.com/cit-591/final-project-summer-2019-neuralfeedback.git
```
2 create a new Java project in Eclipse, uncheck "Use default location", choose your local project folder **591-final-project-neural-feedback**, and also choose **JavaSE-11** as execution environment under "JRE"

![GitHub Logo](/JavaEnv.jpeg)


3 In Eclipse, open 591-final-project-neural-feedback/src/(default package)/GameLauncher.java, run it as Java Application


## Execution Instructions

### Introduction page

Press Enter to go to instruction page. In real life, kids will lay down in a fMRI scanner or wear an EEG headset so their neural signal will be recorded while they are performing motor tasks.

![GitHub Logo](/intro.jpeg)


### Instruction page

Press Enter to see simulated GUI. In real life, kids will read the instruction page and press Enter when they are ready to take the tasks. 

![GitHub Logo](/instruction.jpeg)


### Kid GUI
An instruction is shown to tell kids to perform a certain motor task, like "Move Finger". At the meantime, a pre-trained machine learning classifier will read their neural signal and detect whether the kid is performing the task correctly. 

![GitHub Logo](/move-instruction.jpeg)

If the kid performs the task correctly, the balloon will go up faster!

![GitHub Logo](/kidGUI-right.jpeg)

If the kid doesn't perform the task correctly, the balloon will stop going up.

![GitHub Logo](/kidGUI-wrong.jpeg)


### Clinician GUI
A clinician GUI will synchronize with kid GUI so the clinician can learn how the kid is performing and also check the brain scan to make diagnosis decision.

![GitHub Logo](/clinicianGUI-right.jpeg)
![GitHub Logo](/clinicianGUI-wrong.jpeg)


## Design
### Machine Learning 
Classification:

Our training data consists of 108 tasks (rows) and 14818 1D ROIs (columns) and our testing data consists of 72 tasks (rows) and 14818 1D ROIs (columns).

The fMRIClassificationModel class will load the data by specifying that the last column of each data set has the class attribute (the expected result in our supervised learning model). It will then build 5 models based on the training data set: the Naive Bayes model, the Decision Tree model, the Support Vector Machine, the Naive Bayes Model boosted 10 times using AdaBoostM1 and the Decision Tree model boosted 10 times using AdaboostM1. It then evaluates each model using the test data set and compare them by accuracy rate (which is the percentage of predicted values equal to the expeted values). 
We also used 10-fold cross validation tests (we use 10 different combinations of training data set and test data set) on the whole data set (training data set + test data set) to check for problems related to overfitting. 
When comparing results, the Support Vector Machine model comes on top with an accuracy rate of around 93% and performs in line with other models in the cross-validation test with an accuracy rate in the range 60-70%.

After finding that the Support Vector Machine Model is the best classifier for our data set, we use this model to make task predictions on our test data which we use as real data set (since we are in a simulation). These predicted tasks are then stored in an arraylist and the expected tasks are stored in a separate arraylist. These two arraylists are then used for the clinician GUI and the gaming GUI.

Important: since we do not have a real kid with brain sensors on performing task for us, we used the expected moves as the instructions to the kid and we used the predicted moves as the moves performed by the kid. This is because, the instruction and the predicted moves have to correspond to our data set since we do not have real live data. Of course in a real-life environment, the instruction can be anything (move foot, move lips, move finger, rest) and after the kid has performed a move, the machine learning model will classify the move based on the data retrieved from the brain sensors on the kid.

Definitions: 
-Naive Bayes: based on Baye's theorem which assumes independence between predictors
-Decision Tree: breaks down data set into smaller and smaller subsets while associating a decision tree incrementally
-Support Vector Machine: It finds the best "line" that separates different classes
-AdaBoostM1: Boosts a weak classifier by running the model multiple times and learns sequentially in an adaptive way by tweaking the subsequent weak models

### Clinician GUI
fMRI data is stored as NIfTI format and a public library niftijio (https://github.com/cabeen/niftijio) is used to read the data. FourDimensionalArray, LEDataInputStream, LEDataInputStream, NiftiHeader and NiftiVolume classes are from that library. 

GUIClinician class is designed to show fMRI brain scans to clinicians. First fMRI 4 dimensional data is read using niftijio library, and then intensities in original data are converted to gray scale pixel values. PennDraw is used to plot the brain image as an animation and also expected and detected labels are shown so Clinicians can match brain scans with kids’ performance.   

### Game GUI



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

modelEvaluation(): evaluate model performance. Return statistics showing the performance of the model used

#### FmriClassify.java
main(): \
load training and test datasets \
implement classifier with highest accuracy on test set \
get classification result on test set \
generate binary classification results based on ground truth labels 

### Game GUI
#### WindowManager
Creates game window<br/>
Cleans up game window
```java
Window gameWindow
```
#### DisplayUpdater
This class will update the game images and GUI.<br/>
For instance, this class will also update positions for the player character/vehicle <br/>
It will thus receive info from GameInputReader and PlayerStats.
#### VehicleStats
The vehicle the player is driving (either a car or hot air balloon)
```java
int positionX
int positionY
int damage
```
#### PlayerStats
This class will keep track of the player's data.<br/>
```java
int Score
double averageAccuracy
String mostSuccessfulAction //the action with the highest average accuracy
Vehicle vehicle
```
#### GameInputData
This class will provide a structure for the data of each input instance.  Will include:<br/>
```java
String actionID
boolean bActionSuccessful//true or false
double AccuracyPercent
```
#### GameInputReader 
This class will be the main communication between machine learning classes and the GUI classes.<br/>
It will read input and fill out InputData and PlayerStats

