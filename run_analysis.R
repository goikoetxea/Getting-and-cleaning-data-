library(reshape2)

# 1. Merges the training and the test sets to create one data set.

features <- read.table("./features.txt")
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
Y_train <- read.table("./train/Y_train.txt")
Y_test <- read.table("./test/Y_test.txt")

# add column name to subject file
names(subject_train) <- "subject"
names(subject_test) <- "subject"

# add column name to Y files
names(Y_train) <- "activity"
names(Y_test) <- "activity"

# add column name to X files
names(X_train) <- features$V2
names(X_test) <- features$V2

# merge train and test files into one file
train <- cbind(subject_train, Y_train, X_train)
test <- cbind(subject_test, Y_test, X_test)
train_and_test <- rbind(train, test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", names(train_and_test))
extract_features[1:2] <- TRUE

#remove unrequired columns
train_and_test <- train_and_test[,extract_features]


# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.

# convert activity into factor
train_and_test$activity <- factor(train_and_test$activity, labels = c("Walking", "Walking_upstairs", "Walking_downstairs", "Sitting", "Standing", "Laying"))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melted <- melt(train_and_test, id =c("subject", "activity"))
tidy <- dcast(melted, subject+activity ~ variable, mean )
write.table(tidy, "tidy_data.txt", row.names = FALSE)