# CodeBook.md

## Purpose

This file hopes to give more information about the variables, data and transformations that took place in the run_analysis.R script for this course project.

## Source Data

The data for this project is from the [UC Irvine Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets), using the Human Activity Recognition Using Smartphones Data Set.  The file that was used can be found at the following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Further background on the study can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

### Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information 

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


## Data Transformations

### Part 1 - Merge the training and the test sets to create one data set.

- Loads the following extracted files into data tables:
     - activity_labels.txt
     - features.txt
     - train/X_train.txt
     - train/y_train.txt
     - train/subject_train.txt
     - test/X_test.txt
     - test/y_test.txt
     - test/subject_test.txt
- The X_train and X_test files were assigned column names based on the second column of the features.txt file
- The y_train and t_test files were assigned column name of activityId
- The subject_train and subject_test files were assigned a column name of subjectID
- The resulting datasets were first column bound together based if it was a train or test dataset
- The combined train and test datasets are then row bound together into a combined dataset

### Part 2 - Extract only the mean and standard deviation for each measurement

- Create a vector of the combined dataset column names
- Create another vector to select only the columns of the measures we want using the grepl function (only the columns with names of the IDs and -mean (but not MeanFreq) and -std but not -std())
- Subset the combined dataset to only include the columns that were marked as true in the selection vector.

### Part 3 - Use descriptive activity names to name the activities in the data set

- Using the merge function, join the combined dataset to the activity_labels dataset to get the descriptive names of the activities.
- Update the column names vector for the newly added columns that were joined in

### Part 4 - Appropriately label the data set with descriptive variable names.

- Using the global substitute function (gsub), replace the names of the columns with more human readable names
- Adjust the names to make them more consistent and readable
- Assign the adjusted column names to the combined dataset replacing the existing column names

### Part 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject.

- Use the combined dataset but remove any rows that have no activity type associated with it to prevent them from being included (since we need to group it by activity).
- With the smaller dataset, then aggregate by the activity type and subject, the mean of each of the activity measures
- Join the descriptive activty labels to the new dataset using the merge function.
- Use the write.table function to write out the new dataset to a text file.


