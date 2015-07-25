################################################################################
##
## run_analysis.R
## 
## R script wil retrieve and analyze the Human Activity Recognition Using 
## Smartphones dataset from UC Irvine's Machine Learning Repository
##
## Per the assignment this script will perform the following actions:
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.
##
################################################################################

## Create a filename variable for checking if file already exists
## and easier handling
##
## Then get the file from the UCI website; if files weren't already unzipped
## then unzip the files from the downloaded archive.

filename <- "ucidata.zip"
if (!file.exists(filename)) {
     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(fileURL, filename)
}
if (!file.exists("UCI HAR Dataset")) {
     unzip(filename)
}



###############################################################################
## 1. Merge the training and the test sets to create one data set.

# load the activity type labels & features
activityType <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE)

# assign column names to the activity labels
colnames(activityType) <- c('activityId','activityType')

# Load the train datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# assign column names to the train datasets
colnames(x_train) <- features[, 2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

# Merge the train datasets together
train_dataset <- cbind(y_train, subject_train, x_train)

# Load the test datasets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)

# assign column names to the test datasets
colnames(x_test) <- features[, 2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

# Merge the test datasets together
test_dataset <- cbind(y_test, subject_test, x_test)

# combine the train and test datasets together
combined_dataset <- rbind(train_dataset, test_dataset)




################################################################################
## 2. Extract only the mean and standard deviation for each measurement

# Get the column names of the combined dataset
columnNames <- colnames(combined_dataset)

# create a vector for the columns you want to keep
selectedmeasures = 
     (
          grepl("activity..",columnNames) | 
          grepl("subject..",columnNames) | 
          grepl("mean..",columnNames) & 
          !grepl("-meanFreq..",columnNames) & 
          !grepl("mean..-",columnNames) |
          grepl("-std..",columnNames) & 
          !grepl("-std()..-",columnNames)
     )

# subset the combined dataset to only have the desired measures
combined_dataset <- combined_dataset[selectedmeasures==TRUE]


################################################################################
## 3. Use descriptive activity names to name the activities in the data set

# join the combined dataset with the descriptive activity labels
combined_dataset <- merge(combined_dataset, activityType, by="activityId",all.x=TRUE)

# update the column name vector for the newly joined columns
columnNames <- colnames(combined_dataset)



################################################################################
## 4. Appropriately label the data set with descriptive variable names. 
## ** Thanks to Angel Bellmont in the discussion forums for the idea

for (i in 1:length(columnNames)) 
{
     columnNames[i] = gsub("\\()","",columnNames[i])
     columnNames[i] = gsub("-std$","StdDev",columnNames[i])
     columnNames[i] = gsub("-mean","Mean",columnNames[i])
     columnNames[i] = gsub("^(t)","time",columnNames[i])
     columnNames[i] = gsub("^(f)","freq",columnNames[i])
     columnNames[i] = gsub("([Gg]ravity)","Gravity",columnNames[i])
     columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columnNames[i])
     columnNames[i] = gsub("[Gg]yro","Gyro",columnNames[i])
     columnNames[i] = gsub("AccMag","AccMagnitude",columnNames[i])
     columnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columnNames[i])
     columnNames[i] = gsub("JerkMag","JerkMagnitude",columnNames[i])
     columnNames[i] = gsub("GyroMag","GyroMagnitude",columnNames[i])
}

# change the column names of the combined dataset with the new column names
colnames(combined_dataset) <- columnNames



################################################################################
## 5. Create a second, independent tidy data set with the average of 
##    each variable for each activity and each subject.

# remove any rows that don't have an activity type 
new_dataset <- combined_dataset[,names(combined_dataset) != "activityType"]

# calculate the mean for each variable for each activity and subject
tidy_dataset <- 
     aggregate(new_dataset[,names(new_dataset) != c('activityId','subjectId')],
               by=list(activityId=new_dataset$activityId,
                       subjectId = new_dataset$subjectId),mean)

# join the activity descriptive names to the tidy dataset
tidy_dataset <- merge(tidy_dataset,activityType,by='activityId',all.x=TRUE)

# export the tidy_dataset to a file
write.table(tidy_dataset, './tidyData.txt',row.names=TRUE,sep='\t')