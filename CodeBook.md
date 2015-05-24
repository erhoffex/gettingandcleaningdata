#run_analysis.R Code Book
###Author: sergiped

##downloadUCIFiles()

* Creates *projectfiles* directory
* Checks to see if we have already downloaded data
  * If not, downloads UCI dataset using RCurl

##createTidyData()

* Create several path variables to describe where files being used are at

###loadLabels()

* Reads activity labels and feature labels
* Reads subject and activity codes
* Merge activity numeric code with text descriptor from file in UCI dataset
* Assign variables to global environment so we can access them with other functions

###loadMainData()

* Loads the main datasets using read.fwf.  We could utilize another package to make this go much faster, but wanted to stick with base package for now.
* Assign variables to global environment so we can access them with other functions

###assignColumnLabels()

* Assign features from features file in UCI dataset to column names
* Assign variables to global environment so we can access them with other functions

###filterColumnLabels()

* Filter features in column names so we only have means and standard deviation measures
* Assign variables to global environment so we can access them with other functions

###combineDatasets()

* Combine the test and training datasets into one combined dataset
* Assign variables to global environment so we can access them with other functions

###calculateColumnMeans()

* Utilizing *ddply* from the *plyr* package, calculate column means by activity and by subject
* Assign variables to global environment so we can access them with other functions

##Room for improvement

* Utilize faster function to read fixed width files
* Figure out better way to assign variables vs. pushing to global environment.  Perhaps push to parent function's environment.  Don't want to pass a huge list of arugments however.