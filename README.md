---
output: html_document
---
#Getting and Cleaning Data Course Project
##run_analysis.R
###Author: sergiped

##About the Script
This script downloads data from the UCI Machine Learning Repository, specifically the *Human Activity Recognition Using Smartphones Data Set*.  This data is downloaded into the *projectfiles* directory.

Once we have the raw data, the scripts contained in this file can also summarize the data by combining the test and training datasets, filtering so we are only using the mean and standard deviation measures, and summarizing this data based on the mean of observations for each subject and observations for each activity.

This summarized data is our tidy data set, which the script will save as tidydata.txt

##How to Use the Scripts
The scripts consist of two main functions:

* downloadUCIFiles()
* createTidyData()

###downloadUCIFiles()
####No arguments
Will download the UCI raw dataset into the *projectfiles* directory, and unzip the data.

###createTidyData()
####No arguments
This script will:

* Combine the test and training datasets
* Filter dataset so we are only using the mean and standard deviation measures
* Summarize the data based on the mean of observations for each subject and observations for each activity.
* Save tidy data set as **tidydata.txt**

##Example

>downloadUCIFiles()

>tidydata <- createTidyData()