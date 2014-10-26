run_analysis <- function() {
        
        # Import library
        library("data.table")
        library("dplyr")
        
        # Set working directory
        setwd("C:/Itera/Coursera/03 Getting and cleaning data/Project/GettingAndCleaningData")        
        
        # Check if file already exist in working directory. If not, download file from internet
        if (!file.exists("./Dataset.zip")) {
                
                # Download file from internet
                fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
                dest <- "./Dataset.zip"
                download.file(fileURL, dest)
                
                # Unzip file to working directory
                unzip("./Dataset.zip")                
        }
        
        # Read feature names and activity labels
        features <- read.table("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
        activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
        
        
        # Read training files                
        y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
        x_train <- read.table("./UCI HAR Dataset/train/x_train.txt", sep="", header=FALSE)
        subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
        
        # Set the column names for training data to the feature names        
        names(x_train) <- features[[2]]
        
        # Add column subject
        x_train <- mutate(x_train, subject = subject_train$V1)
        names(x_train)[names(x_train) == "V1"] <- "subject"
        
        # Add activity column and name column activity
        x_train <- cbind(y_train, x_train)
        names(x_train)[names(x_train) == "V1"] <- "activity"
        x_train[,"activity"] <- factor(x_train[,"activity"], levels=activity_labels$V1, labels=activity_labels$V2)
        
                
        # Read test files
        y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
        x_test <- read.table("./UCI HAR Dataset/test/x_test.txt", sep="", header=FALSE)
        subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
        
        # Set the column names for test data to the feature names        
        names(x_test) <- features[[2]]
        
        # Add column subject
        x_test <- mutate(x_test, subject = subject_test$V1)
        names(x_test)[names(x_test) == "V1"] <- "subject"
        
        # Add activity column and name column activity
        x_test <- cbind(y_test, x_test)
        names(x_test)[names(x_test) == "V1"] <- "activity"
        x_test[,"activity"] <- factor(x_test[,"activity"], levels=activity_labels$V1, labels=activity_labels$V2)
        
        
        # Create master data
        masterData <- rbind(x_train, x_test)          
        
        # Select only mean or standard deviation columns
        colNames <- colnames(masterData)
        colNames <- (colNames[(grepl("mean()",colNames) 
                               | grepl("std()",colNames)
                               
                               | grepl("subject",colNames)
                               
                               | grepl("activity",colNames)) == TRUE])
        
        # Extract the data from only these columns
        filteredData <- masterData[colNames]
        
        # Average by activity and by subject
        result <- filteredData %>% group_by(activity, subject) %>% summarise_each(funs(mean))
                
}