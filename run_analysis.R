BASE_PATH = "UCI HAR Dataset"
TRAIN_FOLDER = file.path(BASE_PATH, "train")
TEST_FOLDER = file.path(BASE_PATH, "test")

get_feature_metadata <- function() {
    features <- read.table(file.path(BASE_PATH , "features.txt"), col.names = c("ID", "Feature"), colClasses = c("numeric", "character"), header=FALSE)
    # Additional column for filtering (use only those features with "mean()" or "std()" in name)
    features[, "Use"] <- string_contains_mean_or_std(features$Feature)
    features
}

get_activity_metadata <- function() {
    activities <- read.table(file.path(BASE_PATH , "activity_labels.txt"), col.names = c("ID", "Label"), colClasses = c("numeric", "character"), header=FALSE)
    activities
}

string_contains_mean_or_std <- function(string_vector) {
    return_value <- grepl("mean\\(\\)|std\\(\\)", string_vector)
}

combine <- function(item, col_names, filter=c(TRUE)) {
    train_set <- read.table(file.path(TRAIN_FOLDER, paste(item, "train.txt", sep="_")), header=FALSE)[filter] 
    test_set <- read.table(file.path(TEST_FOLDER, paste(item, "test.txt", sep="_")), header=FALSE)[filter]
    comb_set <- rbind(train_set, test_set)
    names(comb_set) <- col_names
    comb_set
}

create_dataset <- function() {
    print ("Reading Metadata...")
    metadata.features <- get_feature_metadata()
    metadata.activities <- get_activity_metadata()
    print ("Reading Subjects...")
    main_df <- combine("subject", c("subjects"))
    print ("Reading Activities...")
    activities <- combine("y", c("activities"))
    activities$activities <- factor(activities$activities, levels = metadata.activities$ID, labels = metadata.activities$Label)
    print ("Reading Features...")
    features <- combine("X", col_names=metadata.features$Feature[metadata.features$Use], filter=metadata.features$Use)
    print ("Writing Dataset...")
    main_df <- cbind(cbind(main_df, activities),features)
    main_df

}



