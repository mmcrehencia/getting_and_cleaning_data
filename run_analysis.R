#MMCrehencia R Script for Week 4 Assignment
# 1. cleanup 
rm(list = ls())

# 2. fetch and unzip the data set
baseDir <- "."

# 2.1 create data sub-directory if needed
dataDir <- paste(baseDir, "data", sep="/")
if(!file.exists(dataDir)) {
  dir.create(dataDir)
}

# 2.2 download original data if needed (skip if exists already as it takes time)
zipFilePath <- paste(dataDir, "Dataset.zip", sep="/")
if (!file.exists(zipFilePath)) {
  zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file (zipFileUrl, zipFilePath, method="curl")
  dateDownloaded <- date()
  cat ("Dataset downloaded on:", dateDownloaded,"\n")
}

# 2.3 unzip and creates dataSetDir if needed
dataSetDir <- paste(baseDir, "UCI HAR Dataset", sep="/")
if (!file.exists(dataSetDir)) {
  unzip (zipFilePath, exdir=baseDir)
}
list.files(baseDir)

# 3. read the datasets

# 3.1 subjects IDs
trainSubjectsPath <- paste(dataSetDir, "train", "subject_train.txt", sep="/")
testSubjectsPath <- paste(dataSetDir, "test", "subject_test.txt", sep="/")
trainSubjects <- read.table(trainSubjectsPath, header = FALSE) 
testSubjects  <- read.table(testSubjectsPath, header = FALSE)
str(trainSubjects)
str(testSubjects)
table(trainSubjects)
table(testSubjects)

# 3.2 activities codes
trainLabelsPath <- paste(dataSetDir, "train", "y_train.txt", sep="/")
testLabelsPath <- paste(dataSetDir, "test", "y_test.txt", sep="/")
trainLabels <- read.table(trainLabelsPath, header = FALSE) 
testLabels  <- read.table(testLabelsPath, header = FALSE)
str(trainLabels)
str(testLabels)
table(trainLabels)
table(testLabels)
# 3.3 measurements
trainSetPath <- paste(dataSetDir, "train", "X_train.txt", sep="/")
testSetPath <-  paste(dataSetDir, "test", "X_test.txt", sep="/")
trainSet <- read.table(trainSetPath, header = FALSE) 
testSet  <- read.table(testSetPath, header = FALSE)
dim(trainSet)
dim(testSet)

# 4. merge datasets vertically, adding rows but keep the same columns

# 4.1 subjects
mergedSubjects <- rbind(trainSubjects,testSubjects)
dim(mergedSubjects)
str(mergedSubjects)

# 4.2 activity codes
mergedLabels <- rbind(trainLabels,testLabels)
dim(mergedLabels)
str(mergedLabels)

# 4.3 measurements
mergedSet <- rbind(trainSet,testSet)
dim(mergedSet)
#str(mergedSet)
# 5. read feature and activity labels

# 5.1 read as-is
featuresPath <-  paste(dataSetDir, "features.txt", sep="/")
activitiesPath <-  paste(dataSetDir, "activity_labels.txt", sep="/")
features <- read.table(featuresPath, header = FALSE) 
activities  <- read.table(activitiesPath, header = FALSE)

# 5.2 add column names and check
colnames(features) <- c("Feature_code","Feature_str")
colnames(activities) <- c("Activity_code","Activity_str")
str(features)
str(activities)
activities

# 6. renames columns of the merged measurement dataset with the feature labels
colnames(mergedSet) <- features$Feature_str
#names(mergedSet)

# 7. filter the merged dataset to keep names with mean() or std() in them

# 7.1 select the columns to be kept
mean_std <- names(mergedSet)[grep("mean\\(\\)|std\\(\\)", names(mergedSet))]
mean_std

# 7.2 subset by keeping the columns
mergedSet <- mergedSet[,mean_std]
dim(mergedSet)

# 7.3. remove the parentheses from the names
colnames(mergedSet) <- sub("\\(\\)", "", names(mergedSet))
colnames(mergedSet)
# 7.4. add Subject and Activity columns in front
mergedSet = cbind(Subject = mergedSubjects[,1], Activity = mergedLabels[,1], mergedSet)
str(mergedSet$Subject)
str(mergedSet$Activity)
dim(mergedSet)
table(mergedSet$Subject)
table(mergedSet$Activity)
colnames(mergedSet)

# 8. add activity labels to the merged dataset
# Activity becomes a factor
# as Activity is a factor, we loose the initial coding in writing the final dataset
# we could create an additional variable instead
str(mergedSet$Activity)
mergedSet$Activity <- apply (mergedSet["Activity"],1,function(x) activities[x,2])
table(mergedSet$Activity)
str(mergedSet$Activity)
dim(mergedSet)
# 9. aggregate and calculate the mean by subject and activity
tidy <- aggregate(. ~ Subject + Activity, data=mergedSet, mean)
dim(tidy)
names(tidy)

# 10. save the tidy dataset in data
tidyPath <- paste(dataDir, "tidy.txt", sep="/")
write.table(tidy, tidyPath, sep="\t", col.names=T, row.names = FALSE, quote=T)
# verify data
v <- read.table(tidyPath, sep="\t")
dim(v)
