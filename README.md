R script called run_analysis.R does the following:
*Merges the training and the test sets to create one data set.
*Extracts only the measurements on the mean and standard deviation for each measurement.
*As a result this script creates a tidy data set with the average of each variable for each activity and each subject.

The output tidy dataset named "output_data.txt" is a .csv file. The first raw of this file contains names of variables. Variable names described in the CodeBook(file "CodeBook.md").

How to run the script?
* Download input data from here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Unpuck .zip file into R working directory
* Run the script
* File "output_data.txt" is the output tidy dataset
