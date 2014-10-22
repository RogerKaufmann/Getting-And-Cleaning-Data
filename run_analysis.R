# Author: Roger Kaufmann
# Course: Getting and Cleaning Data
# Number: getdata-008

#################
# Configuration #
#################
# name of the top data folder in the working directory
kDataPath = "data"
# Remove "train" if you only want "test" set and vice versa
kFolders <- c("train", "test")
# Name of the output file
kOutputFile <- "tidy_data.txt"


# kVariables is for input checks only, does not affect selected columns
kVariables <- c("subject", "y", "X")

ReadMetadata <- function(filter.features) {
    # Reads the two metadata files for features and activities
    #
    # Returns:
    #    A list with named dataframes "features" and "activities"
    print ("Reading Metadata...")    
    features <- GetFeatureMetadata(filter.features)
    activities <- GetActivityMetadata()
    metadata <- list("features"=features, "activities"=activities)
}

GetFeatureMetadata <- function(FILTER_FUN) {
    # Returns a dataframe with the feature metadata
    #
    # Args:
    #   FILTER_FUN: A function returning a logical vector usable for filtering
    #
    # Returns:
    #   Dataframe with feature metadata filtered by the FILTER_FUN function
    #   consisting of three columns "ID", "Feature" and "Use"
    features <- read.table(file.path(kDataPath , "features.txt"), col.names = c("ID", "Feature"), colClasses = c("numeric", "character"), header=FALSE)
    features[, "Use"] <- FILTER_FUN(features$Feature)
    features
}

GetActivityMetadata <- function() {
    # Returns a dataframe with the activity metadata
    #
    # Returns:
    #   Dataframe with activity metadata  
    activities <- read.table(file.path(kDataPath , "activity_labels.txt"), col.names = c("ID", "Label"), colClasses = c("numeric", "character"), header=FALSE)
    activities
}

FilterForMeanAndStd <- function(stringVector) {
    # Filter for mean() and std() strings
    #
    # Returns:
    #   A logical vector
    grepl("mean\\(\\)|std\\(\\)", stringVector)
}

GenFilepath <- function(item, folder=NULL) {
    # Generates a filepath to an item (either "subject", "y" or "X") in a given folder
    #
    # Returns:
    #   A character filepath
    if (is.null(folder)) {
        message("No 'folder' value defined. Using 'test' by default")
        input <- "test"
    } 
    
    if (!folder %in% kFolders) stop("Invalid 'folder' value")
    if (!item %in% kVariables) stop("Invalid 'item' value")
    filepath <- file.path(file.path(kDataPath, folder), paste(item, paste(folder, "txt", sep="."), sep="_"))
    if (!file.exists(filepath)) stop(paste("Critical Error. File does not exist:", filepath))
    filepath
    
}

CleanColNames <- function(colNames) {
    # Cleans up a vector of column names
    # 1) sets lower characters
    newNames <- tolower(colNames)
    # 2) Removes brackets
    newNames <- gsub("-", "_", newNames)
    newNames <- gsub("\\(|\\)", "", newNames)
    # 3) if "t" is first element, replaces it with "time"
    newNames <- gsub("^t", "time_", newNames)
    # 4) if "f" is first element, replaces it with "freq"
    newNames <- gsub("^f", "freq_", newNames)
    newNames
}

CombineByVariable <- function(variable, colNames, filter=c(TRUE)) {
    # Append all the rows from a given variable over all folders defined in kFolders
    data.all <- NULL
    for (folder in kFolders) {
        data.part <- read.table(GenFilepath(variable, folder), header=FALSE)[filter]
        data.all <- AppendData(data.part, base=data.all, bindfunc=rbind)        
        data.part <- NULL
    }
    # Set variable names after cleaning them up
    names(data.all) <- CleanColNames(colNames)
    data.all
}

AppendData <- function(sibling, base=NULL, bindfunc=rbind) {
    # Little helper for binding dataframes together.
    if (is.null(base)) {
        base <- sibling
    } else {
        base <- bindfunc(base, sibling)
    }
    base
}

CreateDatasetByVariables <- function(metadata) {
    # Create the Dataset by variable
    # Sets the factor variables in activities and the column names in each step
    # 1) Read Metadata
    # 2) Read all the rows for subject in both test and training sets
    # 3) Read all the rows for the activities in both test and training sets
    # 4) Read all the rows for the features in both test and training set
    #    and applies a filter for only selecting a subset of columns
    # 5) Combine test and training Dataset
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

run_analysis <- function() {
    # Run the Analysis and save the tidy dataset
    library(dplyr)
    metadata <- ReadMetadata(FilterForMeanAndStd)  # Apply filter for features
    # Combine Test and Training Set and set the variables
    dataset.original <- CreateDatasetByVariables(metadata)
    dataset.grouped <- group_by(dataset.original, subject, activity)
    # Use dplyr for summarising each column
    # Impuls for this solution stems from 
    # http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr
    dataset.averaged <- summarise_each(dataset.grouped, funs(mean))
    print (paste("Writing Dataset to", kOutputFile))
    write.table(dataset.averaged, kOutputFile, row.names=FALSE)
    print ("Done.")
    dataset.averaged
}
