CodeBook.md
============================================
'X_tidy.txt' dataset file contains averages of selected variables, stratified by subject and activity.

The original dataset may be obtainded from [this file] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and informaton about 'Human Activity Recognition Using Smartphones Data Set' may be obtained from the [web page] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Transformations
--------------------------------------------
The original dataset provided measurements of Smartphones Sensors for activities done by a sample of subjects. Each subject was randomly assigned to one of two groups: 'test' or 'train'. Each case (row) correspond to the observation of one of the 30 subjects doing an activity out of 6 and there is about 10299 observations on both datasets together.

The transformations we have done from original datasets were:

* Step 1: We merged both groups to have all measurements into an unique dataset (for each of the original datasets);
* Step 2: We selected only those measurements which have to do with mean and standard deviation ('mean' and 'std');
* Setp 3: Activities done by subjects where into a separated file ('y.txt') and labeled by numbers. We substituted those numerical labels by more descriptive character names (obtained from 'activity_labels.txt');
* Step 4: We merged the activities dataset (from Step 1) with measurements dataset resulting from Step 2, by column. So at this point our dataset has a column who labels the activities (names of them) and 79 columns with the selected 'mean' and 'std' variables;
* Step 5: We merged subject identification dataset (from Step 1) with measurement dataset resulting from Step 3, by column. At this point the data set has a first column with subject identifiers, a second one with names of activities and the resting columns having the selected variables from Stemp 2. We have calculated mean of each variable (columns 3 to 81) stratified by subject and activity: grouped by different subject and different activity and average it. We have done it using data.table facilities to accelerate calculations. After it we added a header with descriptive names for variables and write the resulting dataset down.

Variables description
--------------------------------------------
A complete description of variables (features) may be read from 'feature_info.txt' in the original dataset [ZIP file] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The variables selected for this database come from the accelerometer and gyroscope 3-axial raw signals ('tAcc-' and 'tGyro-') on the temporal domain (there why the 't' prefix), captured at a constant rate of 50 Hz. The acceleration signal was then separated into body and gravity acceleration signals ('tBodyAcc-' and 'tGravityAcc-'); after it the body linear acceleration and angular velocity were derived in time domain to obtain Jerk signals ('tBodyAccJerk-' and 'tBodyGyroJerk-'), given both of it are three-dimensional vectors, magnitudes of them where calculated using the usual Euclidean norm ('tBodyAccMag-', 'tGravityAccMag-', 'tBodyAccJerkMag-', 'tBodyGyroMag-', 'tBodyGyroJerkMag-'). Finally a Fast Fourier Transfomr (FFT) was applied to some of these signals producing 'fBodyAcc-', 'fBodyGyro-', 'fBodyAccJerkMag', 'fBodyGyroMag' ('f' prefix comes from frequencies domain). Funcitons 'mean' and 'std' where applied to these variables for each of the three dimensions and for the calculated magnitudes.

Below we show the list of all variables selected for our calculations (Steps 1-5) and saved into 'X_tidy.txt'.

* subject
* activity
* tBodyAcc-mean()-X
* tBodyAcc-mean()-Y
* tBodyAcc-mean()-Z
* tBodyAcc-std()-X
* tBodyAcc-std()-Y
* tBodyAcc-std()-Z
* tGravityAcc-mean()-X
* tGravityAcc-mean()-Y
* tGravityAcc-mean()-Z
* tGravityAcc-std()-X
* tGravityAcc-std()-Y
* tGravityAcc-std()-Z
* tBodyAccJerk-mean()-X
* tBodyAccJerk-mean()-Y
* tBodyAccJerk-mean()-Z
* tBodyAccJerk-std()-X
* tBodyAccJerk-std()-Y
* tBodyAccJerk-std()-Z
* tBodyGyro-mean()-X
* tBodyGyro-mean()-Y
* tBodyGyro-mean()-Z
* tBodyGyro-std()-X
* tBodyGyro-std()-Y
* tBodyGyro-std()-Z
* tBodyGyroJerk-mean()-X
* tBodyGyroJerk-mean()-Y
* tBodyGyroJerk-mean()-Z
* tBodyGyroJerk-std()-X
* tBodyGyroJerk-std()-Y
* tBodyGyroJerk-std()-Z
* tBodyAccMag-mean()
* tBodyAccMag-std()
* tGravityAccMag-mean()
* tGravityAccMag-std()
* tBodyAccJerkMag-mean()
* tBodyAccJerkMag-std()
* tBodyGyroMag-mean()
* tBodyGyroMag-std()
* tBodyGyroJerkMag-mean()
* tBodyGyroJerkMag-std()
* fBodyAcc-mean()-X
* fBodyAcc-mean()-Y
* fBodyAcc-mean()-Z
* fBodyAcc-std()-X
* fBodyAcc-std()-Y
* fBodyAcc-std()-Z
* fBodyAcc-meanFreq()-X
* fBodyAcc-meanFreq()-Y
* fBodyAcc-meanFreq()-Z
* fBodyAccJerk-mean()-X
* fBodyAccJerk-mean()-Y
* fBodyAccJerk-mean()-Z
* fBodyAccJerk-std()-X
* fBodyAccJerk-std()-Y
* fBodyAccJerk-std()-Z
* fBodyAccJerk-meanFreq()-X
* fBodyAccJerk-meanFreq()-Y
* fBodyAccJerk-meanFreq()-Z
* fBodyGyro-mean()-X
* fBodyGyro-mean()-Y
* fBodyGyro-mean()-Z
* fBodyGyro-std()-X
* fBodyGyro-std()-Y
* fBodyGyro-std()-Z
* fBodyGyro-meanFreq()-X
* fBodyGyro-meanFreq()-Y
* fBodyGyro-meanFreq()-Z
* fBodyAccMag-mean()
* fBodyAccMag-std()
* fBodyAccMag-meanFreq()
* fBodyBodyAccJerkMag-mean()
* fBodyBodyAccJerkMag-std()
* fBodyBodyAccJerkMag-meanFreq()
* fBodyBodyGyroMag-mean()
* fBodyBodyGyroMag-std()
* fBodyBodyGyroMag-meanFreq()
* fBodyBodyGyroJerkMag-mean()
* fBodyBodyGyroJerkMag-std()
* fBodyBodyGyroJerkMag-meanFreq()
