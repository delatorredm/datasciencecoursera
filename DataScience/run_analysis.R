# Set Working Directory to Files
setwd("/Users/delatorredm/Desktop/COURSERA/Exploratory Data Analysis/data/UCI HAR Dataset")

# Open labels
activity <- read.table("activity_labels.txt")
activity[,2] <- as.character(activity[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Select only mean and standard deviation features
featuresSelected <- grep(".*Mean.*|.*mean.*|.*Std.*|.*std.*", features[,2])

# Read training dataset
trainSubject <- read.table("train/subject_train.txt")
trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainX <- trainX[featuresSelected]
train <- cbind(trainSubject, trainY, trainX)

# Read testing dataset
testSubject <- read.table("test/subject_test.txt")
testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testX <- testX[featuresSelected]
test <- cbind(testSubject, testY, testX)

# Merge training and testing dataset
all <- rbind(train, test)

# Assign labels to features
featuresLabels <- features[featuresSelected,2]  
colnames(all) <- c("Subject", "Activity", featuresLabels)

# Assign decriptive activity names
all$Activity <- factor(all$Activity, levels = activity[,1], labels = activity[,2])
all$Subject <- as.factor(all$Subject)

# Tidy dataset with averages of each variable for each activity for each subject
library(reshape2)
means <- melt(all, varnames = c("Subject","Activity"))
means <- dcast(means, Subject + Activity ~ variable, mean)

# Output Dataset
write.table(means, file = "tidy.txt", sep = ",")