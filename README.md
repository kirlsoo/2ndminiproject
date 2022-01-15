First we will take advantage of the existence of the libraries for easier data manipulation. the library used will be data.table.

To use:

library(data.table)

data.table is best for a large dataset like this

Note: is is also assumed that the zip file is unzipped in the same directory before running the script.

1. Merge training and the test sets to create one data set

We read the metadata provided to get the names of the features and labels of the activities
feature_names <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt" , header = FALSE)


In reading training data, data.table is used for each text file included in the train folder and are stored in variables per category as in the code below:

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_features <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

the same is done with the test dataset.
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_features <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

For the actual merging, we merge train and test sets by category first using rbind
subject_dt <- rbind(train_subject, test_subject)
features_dt <- rbind(train_features, test_features)
activity_dt <- rbind(train_activity, test_activity)

Columns are then named for with the data from the metadata for the features and also for activity and subject for easier manipulation.

colnames(features_dt) <- t(feature_names[2])
colnames(activity_dt) <- "Activity"
colnames(subject_dt) <- "Subject"

All the data are finally merged completely using cbind() 
combined_data <- cbind(features_dt,activity_dt,subject_dt)


2. Extracts only the measurements on the mean and standard deviation for each measurement


use the grep function to search the combined data set from earlier for all columns with mean and std (standard deviation). ignore.case is set to TRUE so that the search will not be case sensitive. All that are found are stored in meanSTD_col

meanSTD_col <- grep(".*Mean.*|.*Std.*", names(combined_data), ignore.case = TRUE)

We also get the column index numbers for activity and subject
act_index <- which(colnames(combined_data)=="Activity")
sub_index <-which(colnames(combined_data)=="Subject")

We add the activity and subject columns, index 562 and 563, to create the required columns. 
requiredColumns <- c(meanSTD_col,act_index, sub_index)


checking the dimensions of the combined data with
dim(combined_data)

with the selected columns in requiredColumns (with mean and std) get the extracted data 
extractedData <- combined_data[,requiredColumns]

the dimensions of extrated data are checked with 
dim(extractedData)



3. Use descriptive activity names to name the activities in the data set

First is to change the numeric type activity column in extracted data to character type to allow activity names. this is done with as.character function.

extractedData$Activity <- as.character(extractedData$Activity)

Then with the names from the metadata activity_labels, we update the activity names by using a for loop to go through each one
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activity_labels[i,2])
}

The activity variable needs to be updated to factor type after

extractedData$Activity <- as.factor(extractedData$Activity)

4. Appropriately labels the data set with descriptive variable names

to check the current variable names we use 

names(extractedData)

We use the gsub fuction to substitute all shortcut variable names to their descriptive equivalent
names(extractedData) <- gsub("Acc","Accelerometer", names(extractedData))
names(extractedData) <- gsub("Gyro","Gyrometer", names(extractedData))
names(extractedData) <- gsub("BodyBody","Body", names(extractedData))
names(extractedData) <- gsub("Mag","Magnitude", names(extractedData))

for f and t (frequency and time) the symbol "^" is used to emphasize to select only the lone letter and not those part of a word.
names(extractedData) <- gsub("^f","Frequency", names(extractedData))
names(extractedData) <- gsub("^t","Time", names(extractedData))

use names(extractedData) to check the updated variable names.


5. From tha data in step 4, create a second, independent tidy set data with the avarage of each variable for each activity and each subject. 

Subject has to be set as a factor
extractedData$Subject <- as.factor(extractedData$Subject)
Save changes to extractedData
extractedData <- data.table(extractedData)

using aggragate function we get the average(mean in argument) of each activity and subject subset from extractedData dataset and store to a new dataset named tidy data.

tidy_data <- aggregate(. ~Subject + Activity, extractedData, mean)

It is then ordered first by subject then by activity using the order function. 
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity),]

