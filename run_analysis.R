# coursera week 4 hw assignment


# used for downloading the target data set and uncompressing
# skips these steps if its already on the local file system
dest_fn <- 'data.zip'
dest_dir <- 'UCI HAR Dataset'
src_fn = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  
# download the data if necessary
if (!file.exists(dest_fn)) {
  download.file(src_fn, dest_fn)
}
  
# unzip the data if necessary
if (!file.exists(dest_dir)) {
  cat('Uncompressing data')
  unzip(dest_fn)
}

# loads the source data files into a table and merges the data sets
# builds the merged data sets for the data, subjects, and labels
# also loads the feature names and activity names for the data set 
cat('Loading data\n')
train <- read.table('UCI HAR Dataset\\train\\X_train.txt', header = FALSE)
train_labels <- read.table('UCI HAR Dataset\\train\\y_train.txt', header = FALSE)
train_subject <- read.table('UCI HAR Dataset\\train\\subject_train.txt', header = FALSE)

test <- read.table('UCI HAR Dataset\\test\\X_test.txt', header = FALSE)
test_labels <- read.table('UCI HAR Dataset\\test\\y_test.txt', header = FALSE)
test_subject <- read.table('UCI HAR Dataset\\test\\subject_test.txt', header = FALSE)

features <- read.table('UCI HAR Dataset\\features.txt', header = FALSE)
activity_labels <- read.table('UCI HAR Dataset\\activity_labels.txt', header = FALSE)
    
activities <- rbind(train_labels, test_labels)
subjects <- rbind(train_subject, test_subject)
data <- rbind(train, test)

# set the data table column names
names(activities) <- c("activity")
names(subjects) <- c("subject")

# removes all columns that aren't a mean or standard deviation
print('Extracting mean and standard deviation data columns')
cols <- grep('(mean\\(|std)', features[, 2])
new_data <- data[, cols]
names(new_data) <- features[cols,2] # set the new column names
data <- new_data
# the data has only columns corresponding to the mean and std now

# merge data sets, creates a single data frame with friendly column names
merged <- cbind(subjects, activities, data)

# set the activity labels
merged[, 2] <- activity_labels[merged[, 2], 2]

# calculates the mean of each variable broken down by each unique subject activity pair
means <- aggregate(. ~ subject + activity, data = merged, FUN = mean)
  
fn <- 'results.txt'
cat('Writing mean summary results to', fn)
write.table(means, fn, row.name=FALSE)
