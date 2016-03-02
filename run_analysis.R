# Getting and Cleaning Data Course Project

## Part 1: Merges the training and the test sets to create one data set.

### load packages
library(reshape2)

### Get Data

#### if data directory doesn´t exist, create
if (!file.exists("data")) {
dir.create("data")
}

#### if data doesn´t exist, download and unzip
if (!file.exists("data/UCI HAR Dataset")) {
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "data/UCI_HAR_data.zip"
download.file(fileURL, destfile = zipfile)
unzip(zipfile, exdir = "data")
}

### read label files
feature_labels <- read.table("data/UCI HAR Dataset/features.txt", 
                             stringsAsFactors = FALSE)
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("activity.id", "activity.label"), 
                              stringsAsFactors = FALSE)

### read subject files
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")

### read activity (Y) files
Y_train <- read.table("data/UCI HAR Dataset/train/Y_train.txt", 
                      col.names = "activity.id")
Y_test <- read.table("data/UCI HAR Dataset/test/Y_test.txt", 
                     col.names = "activity.id")

### read values (X) files, adding column names from features file
X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", 
                      col.names = feature_labels$V2)
X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", 
                     col.names = feature_labels$V2)

### combine train and test files; add new column to identify group (test or train)
merged_train <- cbind(subject_train, Y_train, group="train", X_train, 
                      stringsAsFactors = FALSE)
merged_test <- cbind(subject_test, Y_test, group="test", X_test, 
                     stringsAsFactors = FALSE)
all <- rbind(merged_train,merged_test)
all$group <- as.factor(all$group)


## Part 2: Extracts only the measurements on the mean and standard deviation for each measurement.
means_sd <- all[,grep(("activity|subject|group|mean(\\.{2,})|std(\\.{2,})"), 
                      names(all))]

## Part 3: Uses descriptive activity names to name the activities in the data set

### update activity.id column to contain activity labels
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[1])] <- 
        activity_labels$activity.label[1]
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[2])] <- 
        activity_labels$activity.label[2]
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[3])] <- 
        activity_labels$activity.label[3]
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[4])] <- 
        activity_labels$activity.label[4]
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[5])] <- 
        activity_labels$activity.label[5]
means_sd$activity.id[which (
        means_sd$activity.id == activity_labels$activity.id[6])] <- 
        activity_labels$activity.label[6]
means_sd$activity.id <- as.factor(means_sd$activity.id)
names(means_sd$activity.id) <- "activity"


## Part 4: Appropriately labels the data set with descriptive variable names.

### labels added as names in part 1

### tidy names - capitalization and periods as separators for ease of reading
names(means_sd) <- gsub("tBody", "Time.Body.", names(means_sd))
names(means_sd) <- gsub("fBodyBody", "Freq.Body.", names(means_sd))
names(means_sd) <- gsub("fBody", "Freq.Body.", names(means_sd))
names(means_sd) <- gsub("tGravity", "Time.Gravity.", names(means_sd))
names(means_sd) <- gsub("\\.\\.$", "", names(means_sd))
names(means_sd) <- gsub("\\.\\.\\.", ".", names(means_sd))
names(means_sd) <- gsub("AccJerkMag", "Acc.Jerk.Mag", names(means_sd))
names(means_sd) <- gsub("AccJerk", "Acc.Jerk", names(means_sd))
names(means_sd) <- gsub("AccMag", "Acc.Mag", names(means_sd))
names(means_sd) <- gsub("GyroJerkMag", "Gyro.Jerk.Mag", names(means_sd))
names(means_sd) <- gsub("GyroJerk", "Gyro.Jerk", names(means_sd))
names(means_sd) <- gsub("GyroMag", "Gyro.Mag", names(means_sd))


## Part 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### group dataframe by subject, activity and test/train group (adding this last group has no impact on averages as each subject is only in one group) and calculate average for each group 
aggr.means_sd <- aggregate(means_sd[,4:ncol(means_sd)], 
                           by = list(subject = means_sd$subject, 
                                     activity = means_sd$activity, 
                                     group = means_sd$group), 
                           mean)

### restructure dataframe from wide to long
tidy_simple <- melt(aggr.means_sd, 
               id.vars = c("subject", "activity", "group"), 
               value.name = "average")

### save simple tidy dataframe as text file
write.table(tidy_simple, file = "tidy_simple.txt", row.names = FALSE)

