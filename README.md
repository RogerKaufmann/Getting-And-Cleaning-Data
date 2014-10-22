##### Getting and Cleaning Data
# Course Project

## The raw data
The raw data stem from the "Human Activity Recognition Using Smartphones Dataset" (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
This data set contains the data from experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. The data stems from the phones embedded accelerometer and gyroscope.

For more details see `Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012`

## The script
The script (run_analysis.R) creates a tidy dataset from the "Human Activity Recognition Using Sartphones Data Set"

It does the following steps:

1. Reads the Metadata for the activities and the features
2. Reads all the rows for subjects, activities and features in the defined sets ("test", "train" or both). See "Configuration" below.

..* For all variables: Appropriately labels the data set with descriptive variable names. 

..* For the activity rows: Uses descriptive activity names to name the activities in the data set.

..* For the feature rows: Extracts only the measurements on the mean and standard deviation for each measurement. See "Feature selection" below for my interpretation.

3. Merges the training and the test sets to create one data set.
4. From the data set in step 3, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Step 4 requires that the package "dplyr" is installed. 
Note that I chose a slightly different approach by merging each file from the test-set with its counterpart in the training-set and then merging the resulting columns. 
The result is in any case the same. The tidy dataset has 180 observations over 68 variables.

## Configuration
The following configuration settings can be set at the top of run_analysis.R

* `kDataPath` Name of the top data folder in the working directory
* `kFolders` Subfolders of "kDataPath" that are processed. Remove "train" if you only want the "test"-set and vice versa
* `kOutputFile` Name of the output file

## Feature selection
The course requirements state, that one should "extract only the measurements on the mean and standard deviation for each measurement". 
I took this literally by only extracting measurements for

* mean(): Mean value
* std(): Standard deviation

I implemented this via a filter function that returns a logical vector with TRUE if a feature has "mean()" or "std()" in its name, FALSE otherwise:
`grepl("mean\\(\\)|std\\(\\)", stringVector)`

The function `ReadMetadata` requires such a filter function as an argument for defining which columns should be extracted from the feature vector. 

## Useful resources
The following resources helped me during this course project
* David's Course Project FAQ https://class.coursera.org/getdata-008/forum/thread?thread_id=24
* Solution for Summarizing the columns http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr
