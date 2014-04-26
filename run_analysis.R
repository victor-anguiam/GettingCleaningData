# This script creates a tidy dataset ('X_tidy.txt') from: 
# 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
# with average values of selected magnitudes (all measurements refered to mean and std 
# in the original dataset) stratifyied by subject and activity.
#
# Two global variables control the behaviour of the script:
#    (a) 'verbosity': logical variable,
#        it sets script to prompt its activity (TRUE) or not at all (FALSE); 
#    (b) 'holdtmpfiles': logical varible to preserve (TRUE) intermediate files and 
#        directories or not (FALSE). When 'holdtmpfiles' is FALSE the script saves 
#        'X_tidy.txt' file to the working directory and erases all other intermediate 
#        files and directories.

# GLOBAL VARIABLES
verbosity <- TRUE       #Sets script to prompt its activity (TRUE) or not at all (FALSE)
holdtmpfiles <- FALSE   #Sets script to hold all intermediate files and directories (TRUE) or not (FALSE)

# AUXILIARY FUNCTIONS

#Merge each couple of test and train files into an unique file.
#It produces a new directory named 'merged' into working directory with 
#all datasets from 'test' and 'train' merged by rows (test rows first).
#I chose to merge all files because instructions does not constrain to one
merge_test_and_train_files <- function(root_dir) {
    #If 'merged' directory does not exists... create it an 'Inertial Signals'
    if(!file.exists(paste(root_dir, "merged", sep="/"))) {
        dir.create(paste(root_dir, "merged", "Inertial\ Signals", sep="/"), 
                   recursive=TRUE)
    }
    #For each file in 'test'...
    wd <- paste(root_dir, "UCI\ HAR\ Dataset", sep="/")
    for(testfile in list.files(paste(wd, "test", sep="/"), recursive=TRUE)) {
        trainfile <- sub("test", "train", testfile)
        mergedfile <- sub("_test", "", testfile)
        if(verbosity) {
            print(paste("Merging", basename(testfile), "and", basename(trainfile), 
                        "--->", basename(mergedfile)))
        }
        testdata <- read.table(paste(wd, "test", testfile, sep="/"), header=FALSE, sep="")
        traindata <- read.table(paste(wd, "train", trainfile, sep="/"), header=FALSE, sep="")
        #... merge it by row with its couple in 'train'
        mergeddata <- rbind(testdata, traindata)
        write.table(mergeddata, file=paste(".", "merged", mergedfile, sep="/"), 
                    col.names=FALSE, row.names=FALSE)
    }
}

#Extract data from mean and std features from merged 'X.txt' file.
#It produces a new directory named 'extracted' into working directory where
#filtered dataset 'X.txt' is saved.
#Obtain indexes of features (columns) that match with 'mean' or 'std' 
#and select them from 'merged' dataset.
#I chose to filter by 'mean|std' because there are some features
#from frequencies that also match it and instructions are not specific
#on wether filter by 'mean|std' or 'mean()$|std()$'
extract_mean_and_std <- function(root_dir) {
    #If 'extracted' directory does not exists... create it
    if(!file.exists(paste(root_dir, "extracted", sep="/"))) {
        dir.create(paste(root_dir, "extracted", sep="/"), recursive=TRUE)
    }
    #Indexes for mean and std features
    features <- read.table(paste(root_dir, "UCI\ HAR\ Dataset/features.txt", sep="/"))
    mean_std_indexes <- grep("mean|std", features[, 2])
    
    #Data from measurements
    datafile <- paste(root_dir, "merged", "X.txt", sep="/")
    data <- read.table(datafile)
    
    #Filter for required indexes
    if(verbosity) {
        print("Filtering mean and std measurements ...")
    }
    data <- data[, mean_std_indexes]
    datafile <- paste(root_dir, "extracted", "X.txt", sep="/")
    write.table(data, file=datafile, col.names=FALSE, row.names=FALSE)
}

#Changes numerical labels for activities by character labels.
#Produces a new directory named 'named' into working directory where
#merged activities dataset is saved.
#Obtain map of labels (numeric vs character) from 'activity_labels.txt' and
#merge with 'y.txt' dataset which contains activities effective done by 
#subjects and save it to 'named' directory.
use_names_instead_of_labels <- function(root_dir) {
    #If 'named' directory does not exists... create it
    if(!file.exists(paste(root_dir, "named", sep="/"))) {
        dir.create(paste(root_dir, "named", sep="/"), recursive=TRUE)
    }
    #Map of activity labels and its names (numeric vs character)
    names <- read.table(paste(root_dir, "UCI\ HAR\ Dataset", "activity_labels.txt", sep="/"))
    
    #Activities effective done by labels (numeric)
    activities <- read.table(paste(root_dir, "merged", "y.txt", sep="/"))
    
    #Merge the two datasets into a dataset with only names
    activities <- merge(activities, names, by.activities=1, by.names=2, sort=FALSE)
    datafile <- paste(root_dir, "named", "y.txt", sep="/")
    write.table(activities[, 2], file=datafile, col.names=FALSE, row.names=FALSE, quote=FALSE)
}

#Labels measurements dataset with descriptive activity names (character labels).
#Produces a new directory named 'labeled' into working directory where 
#dataset 'X.txt' is saved.
#Adds variable activities (from activities dataset) to measurements dataset.
label_dataset <- function(root_dir) {
    #It 'labeled' does not exists... create it
    if(!file.exists(paste(root_dir, "labeled", sep="/"))) {
        dir.create(paste(root_dir, "labeled", sep="/"), recursive=TRUE)
    }
    #Read activities dataset in which labels are names of activities
    labelsfile <- paste(root_dir, "named", "y.txt", sep="/")
    labels <- read.table(labelsfile)
    
    #Read dataset of mean and std measurements
    datafile <- paste(root_dir, "extracted", "X.txt", sep="/")
    data <- read.table(datafile)
    
    #Merge (adds activities) both datasets by columns, with labels to the left
    data <- cbind(labels, data)
    datafile <- paste(root_dir, "labeled", "X.txt", sep="/")
    write.table(data, file=datafile, col.names=FALSE, row.names=FALSE, quote=FALSE)
}

#Calculate means stratifyied by subject and activity
#Produces a new dataset 'X_tidy.txt' into working directory.
#Merges 'subject.txt' dataset and 'X.txt' (from 'labeled' directory) by 
#column (subjects and activities columns to the left); computes means for
#each subject and activity (using data.table facilities); finally labels
#each column with descriptive names.
tidy_dataset <- function(root_dir, filtered_indexes) {
    #Read subject id dataset
    subjectidsfile <- paste(root_dir, "merged", "subject.txt", sep="/")
    subjectids <- read.table(subjectidsfile)
    
    #Read "labeled" dataset
    datafile <- paste(root_dir, "labeled", "X.txt", sep="/")
    data <- read.table(datafile)
    
    #Merge both datasets by columns, with subject ids to the left
    data <- cbind(x=subjectids, data)
    names(data)[1:2] <- c("subject", "activity")
    
    #Computes averages for each subject and activity (as data.table)
    library(data.table)
    data <- data.table(data)
    res <- data.frame(data[, lapply(.SD, mean), by="subject,activity"])
    
    #Label names variables with filtered features
    features <- read.table(paste(root_dir, "UCI\ HAR\ Dataset/features.txt", sep="/"))
    mean_std_indexes <- grep("mean|std", features[, 2])
    labels <- features[, 2][mean_std_indexes]
    names(res)[3:81] <- as.character(labels)
    datafile <- paste(root_dir, "X_tidy.txt", sep="/")
    write.table(res, file=datafile, col.names=TRUE, row.names=FALSE, quote=FALSE)
}

# MAIN

# Create a new working directory (temporary if 'holdtmpfiles == TRUE')
oldwd <- getwd()
newwd <- paste(oldwd, "tmp", sep="/")
if(!file.exists(newwd)) {
    dir.create(newwd)
}
setwd(newwd)

# Download ZIP file & unzip it
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
urlpath <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(filename)) {
    if(verbosity) {
        print(paste("Downloading \'", urlpath, "\' ...", sep=""))
        status <- download.file(urlpath, filename, method="curl", mode="w")
        print(paste("STATUS: ", status))
    }
    else {
        download.file(urlpath, filename, method="curl", mode="w", quiet=TRUE)
    }
    
}
if(verbosity) {
    print(paste("Unzipping \'", filename, "\' ...", sep=""))
    print(paste("EXTRACTING DATE: ", date(), sep=""))
    unzip(filename, list=TRUE)    
}
unzip(filename)

# STEP 1: Merging test and train datasets
merge_test_and_train_files(newwd)

# STEP 2: Extracting mean and std from measurements
extract_mean_and_std(newwd)

# STEP 3: Substituting activity names on labels
use_names_instead_of_labels(newwd)

# STEP 4: Labeling data set with activity names
label_dataset(newwd)

# STEP 5: Creating a tidy dataset
tidy_dataset(newwd)

# Return to old working directory and delete temp files if needed
setwd(oldwd)
if(!holdtmpfiles) {
    #Save tidy dataset to previous working directory...
    filename <- "X_tidy.txt"
    fromfile <- paste(newwd, filename, sep="/")
    tofile <- paste(oldwd, filename, sep="/")
    file.copy(fromfile, tofile)
    #... and delete temporary directory
    unlink(newwd, recursive=TRUE)
}
