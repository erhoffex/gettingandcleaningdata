## Getting and Cleaning Data Class Project
## Author: sergiped
## Git Repository:  https://github.com/sergiped/gettingandcleaningdata

## Initialize variables that describe the file structure and where data will be stored
projectdir <- "projectfiles"
testdatapath <- file.path(projectdir, "UCI HAR Dataset", "test", "X_test.txt")
testsubjectpath <- file.path(projectdir, "UCI HAR Dataset", "test", "subject_test.txt")
testactivitypath <- file.path(projectdir, "UCI HAR Dataset", "test", "y_test.txt")
traindatapath <- file.path(projectdir, "UCI HAR Dataset", "train", "X_train.txt")
trainsubjectpath <- file.path(projectdir, "UCI HAR Dataset", "train", "subject_train.txt")
trainactivitypath <- file.path(projectdir, "UCI HAR Dataset", "train", "y_train.txt")
featurepath <- file.path(projectdir, "UCI HAR Dataset", "features.txt")
activitylabelspath <- file.path(projectdir, "UCI HAR Dataset", "activity_labels.txt")

## Define function to that will download and unzip files that we will use
downloadUCIFiles <- function() {
  library("RCurl")
  
  zipfile <- "UCI%20HAR%20Dataset.zip"
  
  ## If directory already exists, this function should just throw a warning
  dir.create(projectdir)
  
  ## Check to see if we have already downloaded our data file before downloading.
  ## If we have already downloaded it, don't download it again.  Unzip files.
  if(!file.exists(file.path(projectdir,zipfile))) {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    filehandle <- CFILE(file.path(projectdir, zipfile), mode="wb")
    curlPerform(url=url, writedata = filehandle@ref, ssl.verifypeer=FALSE)
    close(filehandle)
    
    unzip(file.path(projectdir,zipfile), exdir = projectdir)
  }
}

downloadUCIFiles()

## Load file with activity lables
activitylabels <- read.delim(activitylabelspath, sep=" ", header=FALSE)
## Load file with column headings
features <- read.delim(featurepath, sep=" ", header=FALSE)

## Load file with row labels identifying study participant subject #s
testsubjects <- read.delim(testsubjectpath, header=FALSE)
trainsubjects <- read.delim(trainsubjectpath, header=FALSE)

## Load file with row labels identifying activities
testactivities <- merge(read.delim(testactivitypath, header=FALSE), activitylabels)
trainactivities <- merge(read.delim(trainactivitypath, header=FALSE), activitylabels)

## Load file with study data on various measures
testrawobs <- read.fwf(testdatapath, widths=rep(16, 561), buffersize = 500, strip.white=TRUE)
trainrawobs <- read.fwf(traindatapath, widths=rep(16, 561), buffersize = 500, strip.white=TRUE)

## Assign column labels
colnames(testrawobs) <- features[,2]
colnames(trainrawobs) <- features[,2]

## Filter column labels so we only include mean and std dev measures
testrawobs <- testrawobs[,grepl("mean()", colnames(testrawobs), fixed=TRUE) | grepl("std()", colnames(testrawobs), fixed=TRUE)]
trainrawobs <- trainrawobs[,grepl("mean()", colnames(trainrawobs), fixed=TRUE) | grepl("std()", colnames(trainrawobs), fixed=TRUE)]

## Bind columns to identify subject and activity labels
testrawobs <- cbind(subject = testsubjects[,1], activity = testactivities[,2], testrawobs)
trainrawobs <- cbind(subject = trainsubjects[,1], activity = trainactivities[,2], trainrawobs)

## Create combined dataset with both test and training observations
combobs <- rbind(testrawobs, trainrawobs)

## Calculate column means by subject
subjectmeans <- ddply(combobs[,-2], .(subject), function(x) colMeans(x[,-1]))
colnames(subjectmeans)[1] <- "observation"

## Calculate column means by activity
activitymeans <- ddply(combobs[,-1], .(activity), function(x) colMeans(x[,-1]))
colnames(activitymeans)[1] <- "observation"

## Combine to form our tidy dataset
tidydata <- rbind(subjectmeans, activitymeans)

## Write tidy data to table
write.table(tidydata, "tidydata.txt", row.names=FALSE)