#MMCrehencia Week4 Assignment
#This is the Code Book as one of the required files to have in the personal GitHub account
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The requirement for this assignment is to create one R script called run_analysis.R that does the following:
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Part 1
1. Merge the training and test sets to create one dataset
After setting the source directory for the files, read into tables the data located in
features.txt activity_labels.txt subject_train.txt x_train.txt y_train.txt subject_test.txt x_test.txt y_test.txt Assign column names and merge to create one data set.

#Part 2
2. Extract the measurements on the mean and standard deviation for each measurement. 
Create a logcal vector that contains TRUE values for the ID, mean and stdev columns and FALSE values for the others. Subset this data to keep only the necessary columns.

#Part 3
3. Use descriptive activity names to name the activities in the data set.
Merge data subset with the activity type to include the descriptive activity names.

#Part 4
4. Label the dataset with descriptive activity names.
Use gsub function for pattern replacement to clean up the data labels.

#Part 5
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
