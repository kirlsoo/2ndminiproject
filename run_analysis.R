#by: Kristen Ann Joy Luciano
#Data Science 2nd mini project


#merge training and the test sets to create one data set

#Preliminary
#Reading suporting metadata
feature_names <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt" , header = FALSE)

#Reading Data Sets with data.table
#train dataset
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_features <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
#test data set
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_features <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

#Merging the datasets by category
subject_dt <- rbind(train_subject, test_subject)
features_dt <- rbind(train_features, test_features)
activity_dt <- rbind(train_activity, test_activity)

#naming columns from metadata
colnames(features_dt) <- t(feature_names[2])
colnames(activity_dt) <- "Activity"
colnames(subject_dt) <- "Subject"

#Merging all the data
combined_data <- cbind(features_dt,activity_dt,subject_dt)


#Extracts only the measurements on the mean and standard deviation for each measurement
meanSTD_col <- grep(".*Mean.*|.*Std.*", names(combined_data), ignore.case = TRUE)
act_index <- which(colnames(combined_data)=="Activity")
sub_index <-which(colnames(combined_data)=="Subject")

requiredColumns <- c(meanSTD_col,act_index, sub_index)
dim(combined_data)

extractedData <- combined_data[,requiredColumns]
dim(extractedData)


#Uses descriptive activity  names to name the activities in the data set
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activity_labels[i,2])
}


extractedData$Activity <- as.factor(extractedData$Activity)

#Appropriately labels the dataset with descriptive variable names
names(extractedData) #to check current names

names(extractedData) <- gsub("Acc","Accelerometer", names(extractedData))
names(extractedData) <- gsub("Gyro","Gyrometer", names(extractedData))
names(extractedData) <- gsub("BodyBody","Body", names(extractedData))
names(extractedData) <- gsub("Mag","Magnitude", names(extractedData))
names(extractedData) <- gsub("^f","Frequency", names(extractedData))
names(extractedData) <- gsub("^t","Time", names(extractedData))

names(extractedData)



#From the data in step 4, cerate a second, independent tidy data set with the average of each variable for each activity and each subject
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

tidy_data <- aggregate(. ~Subject + Activity, extractedData, mean)
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity),]





