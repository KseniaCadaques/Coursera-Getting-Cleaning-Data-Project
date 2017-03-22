# Coursera-Getting-Cleaning-Data-Project

This repository contains the R scripts and documentation files for the Getting and Cleaning Data's Final Project.

The dataset is avalaible at: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Files

The code checks if the data is in the working directory, and if not, downloads it and unzips it.

`CodeBook.rmd` modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information as well as describes any transformations or work that was performed to clean up the data.

`run_analysis.R` contains all the code to perform the analysis (following 5 steps). After opening the script the user has to set a working directory to a source file location.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The output of the 5th step is called `tidy_dataset.txt`.