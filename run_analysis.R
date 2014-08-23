library(httr)
library(reshape2)
##download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="~/Coursera/Data_Cleaning/project_data.zip", method="curl")
setwd("~/Coursera/Data_Cleaning")

#Reading in the data sets.
directory_train <- "../UCI HAR Dataset/train/"
train_y <- read.table("y_train.txt")
train_x <- read.table("X_train.txt")
train_subject_id<- read.table("subject_train.txt")

directory_test <- "../UCI HAR Dataset/test/"
test_y <- read.table("y_test.txt")
test_x <- read.table("X_test.txt")
test_subject_id<- read.table("subject_test.txt")

directory_main <- "../UCI HAR Dataset/"
features <- read.table("~/Coursera/Data_Cleaning/UCI HAR Dataset/features.txt")
activity <- read.table("~/Coursera/Data_Cleaning/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)

##Exploratory data analysis:

#train_y is a 7352 x 1 data frame.
str(train_y)
dim(train_y)
unique(train_y)

#test_y is a 2947 x 1 data frame.
str(test_y)
dim(test_y)
unique(test_y)

#activity is a 6 x 2 data frame with activity labels.
str(activity)
row.names(activity)

#Make a label to describe activity variables.
activity_names <- activity$V2
activity_names

#train_x is a 7352 x 561 data frame.
str(train_x)
dim(train_x)

#test_x is a 2947 x 561 data frame.
str(test_x)
dim(test_x)

#features is a 561 x 2 data frame. 
dim(features)
str(features)
head(features)

#Make a label to describe feature variables.
feature_names <- as.vector(features$V2)
str(feature_names)

# train_subject_id is a 7352 x 1 data frame with subject ids.
str(train_subject_id)
dim(train_subject_id)
unique(train_subject_id$V1)

# test_subject_id is a 2947 x 1 data frame with subject ids.
str(test_subject_id)
unique(test_subject_id)


#Combine test data into one large dataframe.
test <- cbind(test_subject_id, test_y, test_x)
#Combine training data into one large dataframe.
train <- cbind(train_subject_id, train_y, train_x)

#Merge test and training data frames.
mergedDat <- rbind(test, train)

#Rename column 2 variables with activity labels. 
mergedDat[,2] <- factor(mergedDat[,2], levels=c(1:6), labels=activity_names)
#Rename columns according to the variables they contain.
colnames(mergedDat) <- c("subject_id", "activity", feature_names)

#Check that renaming has occured.
str(mergedDat)

#Check that all cases of mergedDat are complete.
a <- complete.cases(mergedDat)

sum(a)

#Get subsets of data that include only the mean and std.
subDat1<- mergedDat[,grep("[Mm]ean", colnames(mergedDat))] 
subDat2 <- mergedDat[,grep("[Ss]td", colnames(mergedDat))]
#Include subset with subject_ID and activity.
subDat3 <- mergedDat[,1:2]
#Merge subsets together to get all subsets with mean and std.
subDat <- cbind(subDat3,subDat1, subDat2)
str(subDat)

#Omit angle and Frequency features.
subDat <- subDat[,-grep("angle", colnames(subDat))]
subDat <- subDat[,-grep("Freq", colnames(subDat))]

#Check that variables were omitted.
colnames(subDat)

colnames(subDat) <- gsub("BodyBody", "Body", colnames(subDat))
colnames(subDat) <- gsub("([A-Z])", "_\\1", colnames(subDat))
colnames(subDat) <- gsub("^t", "\\time", colnames(subDat))
colnames(subDat) <- gsub("^f", "\\frequency", colnames(subDat))
colnames(subDat) <- gsub("std", "_standard_deviation", colnames(subDat))
colnames(subDat) <- gsub("Acc", "Acceleration", colnames(subDat))
colnames(subDat) <- gsub("\\()", "", colnames(subDat))
colnames(subDat) <- gsub("-", "", colnames(subDat))
colnames(subDat) <- gsub("X$", "x_axis", colnames(subDat))
colnames(subDat) <- gsub("Y$", "y_axis", colnames(subDat))
colnames(subDat) <- gsub("Z$", "z_axis", colnames(subDat))
colnames(subDat) <- gsub("Gyro", "Gyroscope", colnames(subDat))
colnames(subDat) <- gsub("Mag", "Magnitude", colnames(subDat))
colnames(subDat) <- gsub("Jerk", "Jerk", colnames(subDat))
colnames(subDat) <- gsub("mean", "_mean", colnames(subDat))
colnames(subDat) <- gsub("(_standard_deviation)", "_signal\\1", colnames(subDat))
colnames(subDat) <- gsub("(_mean)", "_signal\\1", colnames(subDat)) 
colnames(subDat) <- tolower(colnames(subDat))

#Verify descriptive name changes.
colnames(subDat)

#Reshape the data by melting and calculate the average of each variable by subject and activity.
data_melt <- melt(subDat, id=1:2, measure.vars=3:68)
averagedDat <- dcast(data_melt, subject_id + activity ~ variable, mean)

#Save tidy data to file.
write.table(averagedDat, "tidyDat.txt", row.names=FALSE)

