# Author: Roger Kaufmann
# Course: Getting and Cleaning Data
# Number: getdata-008

#################
# Configuration #
#################
kBasePath = "data"
TRAIN_FOLDER = file.path(BASE_PATH, "train")
TEST_FOLDER = file.path(BASE_PATH, "test")

kFolders <- c("train", "test")
kVariables <- c("subject", "y", "X")

# Functions for creating the Metadata dataframes
ReadMetadata <- function() {
    print ("Reading Metadata...")    
    features <- GetFeatureMetadata(FilterForMeanAndStd)
    activities <- GetActivityMetadata()
    metadata <- list("features"=features, "activities"=activities)
}

GetFeatureMetadata <- function(FILTER_FUN) {
    features <- read.table(file.path(BASE_PATH , "features.txt"), col.names = c("ID", "Feature"), colClasses = c("numeric", "character"), header=FALSE)
    # Additional column for filtering (use only those features with "mean()" or "std()" in name)
    features[, "Use"] <- FILTER_FUN(features$Feature)
    features
}

GetActivityMetadata <- function() {
    activities <- read.table(file.path(BASE_PATH , "activity_labels.txt"), col.names = c("ID", "Label"), colClasses = c("numeric", "character"), header=FALSE)
    activities
}

# Filter for mean() and std() strings
FilterForMeanAndStd <- function(stringVector) {
    grepl("mean\\(\\)|std\\(\\)", stringVector)
}

# Little helper for binding dataframes together. Should be replaced.
AppendData <- function(base, sibling, bindfunc=rbind) {
    if (is.null(base)) {
        base <- sibling
    }
    else {
        base <- bindfunc(base, sibling)
    }
    base
}

# Generates a filepath to an item (either "subject", "y" or "X") in a given folder
GenFilepath <- function(item, folder=NULL, base="data") {
    if (is.null(folder)) {
        message("No 'folder' value defined. Using 'test' by default")
        input <- "test"
    } 
    
    if (!folder %in% kFolders) stop("Invalid 'folder' value")
    if (!item %in% kVariables) stop("Invalid 'item' value")
    filepath <- file.path(file.path(base, folder), paste(item, paste(folder, "txt", sep="."), sep="_"))
    
    if (!file.exists(filepath)) stop(paste("Critical Error. File does not exist:", filepath))
    filepath
    
}

# Append all the rows from a given variable over all folders defined in kFolders
CombineByVariable <- function(variable, colNames, filter=c(TRUE)) {
    
    data.all <- NULL
    for (folder in kFolders) {
        data.part <- read.table(GenFilepath(variable, folder), header=FALSE)[filter]
        data.all <- AppendData(data.all, data.part, rbind)        
        data.part <- NULL
    }

    names(data.all) <- colNames
    data.all
}

# Create the Dataset by variable, that means
# 1) Read Metadata
# 2) Read all the rows for subject in both test and training sets
# 3) Read all the rows for the activities in both test and training sets
# 4) Read all the rows for the features in both test and training set
# 5) Combine Dataset
# Additionally sets the factor variables in activities and the column names
CreateDatasetByVariable <- function(metadata) {
    
    md.features <- metadata$features
    md.activities <- metadata$activities
    print ("Reading Subjects...")
    rawdata.subject <- CombineByVariable("subject", c("subject"))
    print ("Reading Activities...")
    rawdata.activities <- CombineByVariable("y", c("activity"))
    # Create Rawdata for the Activities using factor variables
    rawdata.activities$activity <- factor(rawdata.activities$activity, levels=md.activities$ID, labels=md.activities$Label)
    print ("Reading Features...")
    rawdata.features <- CombineByVariable("X", colNames=md.features$Feature[md.features$Use], filter=md.features$Use)
    print ("Combining Dataset...")
    rawdata.all <- cbind(cbind(rawdata.subject, rawdata.activities), rawdata.features)

}

# Run the Analysis and save the tidy dataset
run_analysis <- function() {
    library(dplyr)
    metadata <- ReadMetadata()
    dataset.original <- CreateDatasetByVariable(metadata)
    dataset.grouped <- group_by(dataset.original, subject, activity)
    # Impuls from http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr
    dataset.averaged <- summarise_each(dataset.grouped, funs(mean))
    
}
