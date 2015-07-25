# Getting and Cleaning Data Course Project

README.md file for the Course Project for the Getting and Cleaning Data Course.

# Project Background

This project was to demonstrate how to obtain and clean up a dataset in order to do analysis.  The data used for this project can be found at the UC Irvine Machine Learning Repository:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The dataset is part of the [Human Activity Recognition Using Smartphones project](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

# File contained in this repository

## run_analysis.R 

Contains all the code needed to perform the data download, extraction and cleanup.  The script will process the files in the users current working directory and will automatically download the files and unzip the files if not already in the current working directory.  At the end of the script it will produce a tidyData.txt file which is a pre-described output.

## tidyData.txt

File that is produced as part of the run_analysis.R script which is an independent dataset with the average of each variable for each activity and each subject.

## CodeBook.md

Describes the variables, data and contains the process by which the source files were processed in order to get the resulting output.