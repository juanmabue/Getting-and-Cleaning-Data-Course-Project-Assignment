getwd()
setwd("/Users/juan7sanchez/Desktop/BI")
library(dplyr)
library(stringr) 
library(lubridate)

#Ckecking file Structure 
features1 <- read.table("data/UCI HAR Dataset/features.txt")
head(features1)
activities <- read.table("data/UCI HAR Dataset/activity_labels.txt")
head(activity)
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
head(subject_test)
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
head(X_test)
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
head(y_test)
subject_trait <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
head(subject_trait)
x_train1 <- read.table("data/UCI HAR Dataset/train/X_train.txt")
head(x_train1)
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
head(y_train1)

#Add column Names 
features <- read.table("data/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge Files
X <- rbind(x_train, x_test) # Merge Xs files
Y <- rbind(y_train, y_test) # Merge Ys files
Subject <- rbind(subject_train, subject_test) #Merge Subjetcs files
All_Data <- cbind(Subject, Y, X) #All together
names(All_Data)# check

#mean and standard deviation
MyData <- All_Data %>% select(subject, code, contains("mean"), contains("std"))
names(MyData)

MyData$code <- activities[MyData$code, 2]

#Variable names.

names(MyData)[2] = "activity"
names(MyData)<-gsub("Acc", "Accelerometer", names(MyData))
names(MyData)<-gsub("Gyro", "Gyroscope", names(MyDataa))
names(MyData)<-gsub("BodyBody", "Body", names(MyData))
names(MyData)<-gsub("Mag", "Magnitude", names(MyData))
names(MyData)<-gsub("^t", "Time", names(MyData))
names(MyData)<-gsub("^f", "Frequency", names(MyData))
names(MyData)<-gsub("tBody", "TimeBody", names(MyData))
names(MyData)<-gsub("-mean()", "Mean", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("-std()", "STD", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("-freq()", "Frequency", names(MyData), ignore.case = TRUE)
names(MyData)<-gsub("angle", "Angle", names(MyData))
names(MyData)<-gsub("gravity", "Gravity", names(MyData))

#average of each variable
FinalData <- MyData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)


str(FinalData)

