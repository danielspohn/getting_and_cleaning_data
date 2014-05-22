
##set your working directory to contain the unzipped files and directories
##Data should just be in the working directory


#load metadata
message("loading metadata...")
features <- read.table("UCI HAR Dataset/features.txt"
                       , header=FALSE,stringsAsFactors=FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt"
                              , header=FALSE,stringsAsFactors=FALSE)

#load train and test sets
message("loading traing and test datasets")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt"
                    ,header=FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt"
                      ,header=FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt"
                    ,header=FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt"
                     ,header=FALSE)


#label x datasets
colnames(x_train) <- features$V2
colnames(x_test) <-features$V2

#load subjects
message("loading subject data")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
colnames(subject_train) <- c('subject')
colnames(subject_test) <- c('subject')

#add subject column
message("add subject column")
x_train <- cbind(subject_train,x_train)
x_test <- cbind(subject_test,x_test)


#Uses descriptive activity names to name the activities in the data set
#add activity column
message("add activity column")
train_dataset <- cbind(
    activity = factor(y_train$V1,labels=activity_labels$V2)
    ,x_train)

test_dataset <- cbind(
  activity = factor(y_test$V1,labels=activity_labels$V2)
  ,x_test)

#Merges the training and the test sets to create one data set.
#combine test and train
combined_dataset <- rbind(test_dataset,train_dataset)

#Extracts only the measurements on the mean and standard deviation for each measurement.
selected_columns <- features$V2[ grep("mean\\(\\)|std\\(\\)", features$V2 ) ]
final_data <- combined_dataset[c('activity','subject',selected_columns)]

#get final column names
cleaning_up_colnames <- colnames(final_data)

#remove parentheses from column names
cleaning_up_colnames <- gsub("\\(\\)", '', cleaning_up_colnames, perl=TRUE)

#remove hyphens from column names
cleaning_up_colnames <- gsub("-", '', cleaning_up_colnames, perl=TRUE)

#assign cleaned up names to the final dataset
colnames(final_data) <- cleaning_up_colnames

#write out final dataset
write.table(final_data, file="final_data.txt", row.names=FALSE)


#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## reshape the array
library(reshape2)
reshaped <- melt(final_data, id = c("subject","activity"))

#compute averages
computed_averages <- dcast(reshaped, subject + activity ~ variable, mean)

#write out tidy computed averages dataset
write.table(computed_averages, file="tidy_data_set.txt", row.names=FALSE)







