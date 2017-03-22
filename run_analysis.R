path0 <- getwd()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"

## Checking if the working directory with the script 
## does not contain already the data files in a folder 
## "./UCI HAR Dataset" or zip file.
## If not, we download the zip file and unzip 
## it in the working directory.

if(!file.exists("./UCI HAR Dataset")){
        if(!file.exists(zipfile)){
                download.file(fileUrl,method="curl")
                unzip(zipfile)
        }
        else {
                unzip(zipfile)
        }
}

path_to_data <- file.path(path0 , "UCI HAR Dataset")
files<-list.files(path_to_data, recursive=TRUE)

## Reading a list of all features "features.txt" which corresponds 
## to variable names of observations from "X_train.txt" and "X_test.txt"

variable_names <- read.table(file.path(path_to_data, "features.txt"),
                             header=FALSE, stringsAsFactors = FALSE)

## Reading data sets of all observations for train and test sets. 

train_dataset <- read.table(file.path(path_to_data, "train" , "X_train.txt" ),
                            header = FALSE)
test_dataset <- read.table(file.path(path_to_data, "test" , "X_test.txt" ),
                           header = FALSE)

## Combining train set and test set in a unified set. 
## Removing intermediate data from the memory. 

combined_dataset <- rbind(train_dataset, test_dataset)
rm("train_dataset","test_dataset")

## Naming columns in the united set by the corresponding variable names.

names(combined_dataset) <- variable_names$V2

##Extracting only the measurements on the mean and standard deviation 
##for each measurement.

combined_dataset <- combined_dataset[grep("mean\\(\\)|std\\(\\)", 
                                          variable_names$V2, value=TRUE)]

## Adding information about subjects to the combined dataset 
## with the observations.
## Removing intermediate data from the memory.

subjects_train <- read.table(file.path(path_to_data, 
                                        "train", "subject_train.txt"),
                                        header = FALSE)
subjects_test  <- read.table(file.path(path_to_data, 
                                        "test" , "subject_test.txt"),
                                        header = FALSE)
subjects <- rbind(subjects_train,subjects_test)
names(subjects) <- "Subject"
combined_dataset <- cbind(combined_dataset, subjects)

rm("subjects", "subjects_train", "subjects_test", "variable_names")

## Reading information about activities and names of activities. 
## Adding information about activities and their names  
## to the combined dataset with the observations and subjects.
## Removing intermediate data from the memory.

activity_train <- read.table(file.path(path_to_data, 
                                       "train", "y_train.txt"),
                             header = FALSE)
activity_test <-  read.table(file.path(path_to_data, 
                                       "test" , "subject_test.txt"),
                             header = FALSE)

activity <- rbind(activity_train,activity_test)

activity_labels <- read.table(file.path(path_to_data, 
                                "activity_labels.txt"),
                                header = FALSE,
                                stringsAsFactors = FALSE)

names(activity) <- "Activity"

activity$Activity <- factor(activity$Activity, 
       levels = activity_labels[,1], 
       labels = activity_labels[,2])

combined_dataset <- cbind(combined_dataset, activity)

rm("activity", "activity_train", "activity_test", "activity_labels")

## Appropriately labeling the data set with descriptive variable names.

names(combined_dataset)<-gsub("^t", "time", names(combined_dataset))
names(combined_dataset)<-gsub("^f", "frequency", names(combined_dataset))
names(combined_dataset)<-gsub("Acc", "Accelerometer", names(combined_dataset))
names(combined_dataset)<-gsub("Gyro", "Gyroscope", names(combined_dataset))
names(combined_dataset)<-gsub("Mag", "Magnitude", names(combined_dataset))
names(combined_dataset)<-gsub("BodyBody", "Body", names(combined_dataset))

## From the data set in step 4, creating a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

library(plyr)

tidy_dataset <- aggregate(. ~ Subject + Activity, combined_dataset, mean)
tidy_dataset <- tidy_dataset[order(tidy_dataset$Subject,tidy_dataset$Activity),]

write.table(tidy_dataset, file = "tidy_dataset.txt",row.name=FALSE)
