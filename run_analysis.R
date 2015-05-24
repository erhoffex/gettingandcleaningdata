projectdir <- "projectfiles"
testdatapath <- file.path(projectdir, "UCI HAR Dataset", "test", "X_test.txt")
testsubjectpath <- file.path(projectdir, "UCI HAR Dataset", "test", "subject_test.txt")
testactivitypath <- file.path(projectdir, "UCI HAR Dataset", "test", "y_test.txt")
traindatapath <- file.path(projectdir, "UCI HAR Dataset", "train", "X_train.txt")
trainsubjectpath <- file.path(projectdir, "UCI HAR Dataset", "train", "subject_train.txt")
trainactivitypath <- file.path(projectdir, "UCI HAR Dataset", "train", "y_train.txt")
featurepath <- file.path(projectdir, "UCI HAR Dataset", "features.txt")
activitylabelspath <- file.path(projectdir, "UCI HAR Dataset", "activity_labels.txt")

downloadUCIFiles <- function() {
  library("RCurl")
  
  zipfile <- "UCI%20HAR%20Dataset.zip"
  dir.create(projectdir)
  
  if(!file.exists(file.path(projectdir,zipfile))) {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    filehandle <- CFILE(file.path(projectdir, zipfile), mode="wb")
    curlPerform(url=url, writedata = filehandle@ref, ssl.verifypeer=FALSE)
    close(filehandle)
    
    unzip(file.path(projectdir,zipfile), exdir = projectdir)
  }
}

downloadUCIFiles()

activitylabels <- read.delim(activitylabelspath, sep=" ", header=FALSE)
features <- read.delim(featurepath, sep=" ", header=FALSE)

testsubjects <- read.delim(testsubjectpath, header=FALSE)
trainsubjects <- read.delim(trainsubjectpath, header=FALSE)

testactivities <- merge(read.delim(testactivitypath, header=FALSE), activitylabels)
trainactivities <- merge(read.delim(trainactivitypath, header=FALSE), activitylabels)

testrawobs <- read.fwf(testdatapath, widths=rep(16, 561), buffersize = 500, strip.white=TRUE)
trainrawobs <- read.fwf(traindatapath, widths=rep(16, 561), buffersize = 500, strip.white=TRUE)

colnames(testrawobs) <- features[,2]
colnames(trainrawobs) <- features[,2]

testrawobs <- testrawobs[,grepl("mean()", colnames(testrawobs), fixed=TRUE) | grepl("std()", colnames(testrawobs), fixed=TRUE)]
trainrawobs <- trainrawobs[,grepl("mean()", colnames(trainrawobs), fixed=TRUE) | grepl("std()", colnames(trainrawobs), fixed=TRUE)]

testrawobs <- cbind(subject = testsubjects[,1], activity = testactivities[,2], testrawobs)
trainrawobs <- cbind(subject = trainsubjects[,1], activity = trainactivities[,2], trainrawobs)

combobs <- rbind(testrawobs, trainrawobs)

subjectmeans <- ddply(combobs[,-2], .(subject), function(x) colMeans(x[,-1]))
colnames(subjectmeans)[1] <- "observation"
activitymeans <- ddply(combobs[,-1], .(activity), function(x) colMeans(x[,-1]))
colnames(activitymeans)[1] <- "observation"
tidydata <- rbind(subjectmeans, activitymeans)