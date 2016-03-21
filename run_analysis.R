# coursera week 4 hw assignment

# execution should be as simple as 
#source('run_analysis.R')
#results <- run()
#results

# runs the main program
run <- function() {
  get_data()
  data <- load_data()
  data <- extract_data(data)
  data <- set_activity_labels(data)
  data <- merge_data_sets(data)
  data <- summarize_data(data)
  data
}

# loads the source data files into a table and merges the data sets
# returns the merged data sets for the data, subjects, and labels in a list
# the list also contains the feature names and activity names for the data set 
# in the features/activities elements of the list
load_data <- function() {
  cat('Loading data\n')
  training_fn <- 'UCI HAR Dataset\\train\\X_train.txt'
  train_labels_fn <- 'UCI HAR Dataset\\train\\y_train.txt'
  train_subject_fn <- 'UCI HAR Dataset\\train\\subject_train.txt'
  test_fn <- 'UCI HAR Dataset\\test\\X_test.txt'
  test_labels_fn <- 'UCI HAR Dataset\\test\\y_test.txt'
  test_subject_fn <- 'UCI HAR Dataset\\test\\subject_test.txt'
  features_fn <- 'UCI HAR Dataset\\features.txt'
  activity_fn <- 'UCI HAR Dataset\\activity_labels.txt'
    
  cat('Reading training data\n')
  train <- read.table(training_fn)
  cat('File has', nrow(train), 'rows and', ncol(train), 'columns\n\n')
  
  cat('Reading training labels data\n')
  train_labels <- read.table(train_labels_fn)
  cat('File has', nrow(train_labels), 'rows and', ncol(train_labels), 'columns\n\n')
  
  cat('Reading training subject data\n')
  train_subject <- read.table(train_subject_fn)
  cat('File has', nrow(train_subject), 'rows and', ncol(train_subject), 'columns\n\n')
  
  cat('Reading test data\n')
  test <- read.table(test_fn)
  cat('File has', nrow(test), 'rows and', ncol(test), 'columns\n\n')
  
  cat('Reading test labels data\n')
  test_labels <- read.table(test_labels_fn)
  cat('File has', nrow(test_labels), 'rows and', ncol(test_labels), 'columns\n\n')
  
  cat('Reading test subject data\n')
  test_subject <- read.table(test_subject_fn)
  cat('File has', nrow(test_subject), 'rows and', ncol(test_subject), 'columns\n\n')
  
  cat('Reading features\n')
  features <- read.table(features_fn)
  cat('File has', nrow(features), 'rows and', ncol(features), 'columns\n\n')
  
  cat('Reading activities\n')
  activities <- read.table(activity_fn)
  cat('File has', nrow(activities), 'rows and', ncol(activities), 'columns\n\n')
  
  cat('Merging data sets\n')
  data <- rbind(train, test)
  cat('Merged data has', nrow(data), 'rows and', ncol(data), 'columns\n\n')
  
  cat('Merging labels\n')
  labels <- rbind(train_labels, test_labels)
  cat('Merged labels has', row(labels), 'rows and', ncol(labels), 'columns\n\n')
  
  cat('Merging subjects\n')
  subjects <- rbind(train_subject, test_subject)
  cat('Merged subjects has', row(subjects), 'rows and', ncol(subjects), 'columns\n\n')
  
  list <- list('data' = data, 'labels'= labels, 'subjects' = subjects, 'features' = features, 'activities' = activities)
  list
}

# removes all columns that aren't a mean or standard deviation
# returns a list of the data, subjects, labels, and features
# the data has only columns corresponding to the mean and std now
extract_data <- function(data) {
  print('Extracting mean and standard deviation data')
  cols <- grep('(mean\\(|std)', data$features[,2])
  new_data <- data$data[, cols]
  names(new_data) <- data$features[cols,2] # set the new column names
  
  list <- list('data' = new_data, 
               'labels' = data$labels,
               'subjects' = data$subjects,
               'features' = data$features,
               'activites' = data$activities)
  list
}

# sets the activity labels by its string name
set_activity_labels <- function(data) {
  data$labels[,1] <- data$activites[data$labels[, 1], 2]
  names(data$labels) <- 'activity'
  
  data
}

# merge data sets, removes the list and creates a single data set with friendly column names
merge_data_sets <- function(data) {
  names(data$subjects) <- 'subject'
  merged <- cbind(data$subject, data$label, data$data)
  merged
}

# calculates the mean of each variable broken down by each unique subject activity pair
# writes out to a file called results.txt
summarize_data <- function(data) {
  #results <- vector()
  library(plyr)
  
  for (col in colnames(data)) {
    if (col == 'activity') {
      next
    }
    else if (col == 'subject') {
      next
    }
    else {
      cat('Processing', col, '\n')
      results <- aggregate(data[col], list(subject= data$subject, activity = data$activity), mean)
      
      len <- length(results[,1])
      cur_subject <- results[1]
      cur_activity <- results[2]
      cur_mean <- results[3][col]

      means <- vector()
      subjects <- vector()
      activities <- vector()
      
      for (i in 1:len) {
        sub_subject <- cur_subject[i, 1]
        sub_act <- cur_activity[i, 1]
        sub_mean <- cur_mean[i, 1]
        
        subjects <- c(subjects, sub_subject)
        activities <- c(activities, sub_act)
        means <- c(means, sub_mean)
      }
      
      if (is.data.frame(df)) {
        df[col] <- means
      }
      else {
        df <- data.frame(subjects, activities, means)
        df <- rename(df, c("means" = col))
      }
    }
  }
  
  fn <- 'results.txt'
  cat('Writing mean summary results to', fn)
  write.table(df, fn, row.name=FALSE)
}


# used for downloading the target data set and uncompressing
# skips these steps if its already on the local file system
get_data <- function() {
  dest_fn <- 'data.zip'
  dest_dir <- 'UCI HAR Dataset'
  src_fn = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  
  # download the data if necessary
  if (!file.exists(dest_fn)) {
    cat('Data set does not exist locally, downloading\n')
    download.file(src_fn, dest_fn)
  }
  else {
    cat('File already exists\n')
  }
  
  # unzip the data if necessary
  if (!file.exists(dest_dir)) {
    cat('Uncompressing data')
    unzip(dest_fn)
  }
  else {
    cat('Data already uncompressed\n')
  }
}
