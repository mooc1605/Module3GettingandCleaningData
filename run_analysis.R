setwd('C:\\Users\\Ho\\Documents\\Coursera\\DataSc\\Module3\\assignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset')

# Install data.table and reshape2 packages if not available
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

# Load data.table and reshape2 libraries
require("data.table")
require("reshape2")

# Read activity Labels from provided file
activity.labels <- read.table("activity_labels.txt")[,2]

# Read data column names to a variable for further use
features.labels <- read.table("features.txt")

# Want to extract features with mean and standard deviation only
extract.features <- grep("std|mean", features.labels[,2])

#Creating tidy data for test set

#Read and assign names for X data set from test file provided
test.x <- read.table("test/X_test.txt")
names(test.x) <- features.labels[,2]
# Exclude unwanted features and retain features with mean and standard deviation
test.x <- test.x[,extract.features]

#Read and assign names for response variable (that is Y )data set from provided test file
test.y <- read.table("test/y_test.txt")
names(test.y) <- "activityID"
test.y$activityName <- activity.labels[test.y$activityID]

# Read subject data set from the provided file and label column name appropriately
test.subject <- read.table("test/subject_test.txt")
names(test.subject) <- "subject"


#Creating tidy data for train set - Almost repeating above.
#I could have gone with functions to avoid code repetation- future code enhancement

#Read and assign names for X data set from provided train file
train.x <- read.table("train/X_train.txt")
names(train.x) <- features.labels[,2]
train.x <- train.x[,extract.features]

#Read and assign names for response variable (that is Y )data set from provided train file
train.y <- read.table("train/y_train.txt")
names(train.y) <- "activityID"
train.y$activityName <- activity.labels[train.y$activityID]

# Read subject data set from the provided file and label column name appropriately
train.subject <- read.table("train/subject_train.txt")
names(train.subject) <- "subject"

#Binding Train Data#Binding Test Data in the order - Subject, X data and Y data
test.data <- cbind(test.subject, test.x, test.y)

train.data <- cbind(train.subject, train.x, train.y)

#Merging both test and train data 
tidy.data <- rbind(test.data,train.data)

# Here are the steps to create second data set 

# Melt data and label them
labels.id   = c("subject", "activityID", "activityName")
labels.data = setdiff(colnames(tidy.data), labels.id)
melt.data      = melt(tidy.data, id = labels.id, measure.vars = labels.data)

# Apply mean function to melted dataset using dcast function
tidydata.mean   = dcast(melt.data, subject + activityName ~ variable, mean)

# Write to a file
write.table(tidydata.mean, file = "tidy_data_mean.txt")