library(dplyr)
library(plyr)

# Settings
setwd("~/UCI HAR Dataset")
features_file_name <- "~/UCI HAR Dataset/features.txt"
measurements_test_file_name <- "~/UCI HAR Dataset/test/X_test.txt"
measurements_train_file_name <- "~/UCI HAR Dataset/train/X_train.txt"
activity_labels_file_name <- "~/UCI HAR Dataset/activity_labels.txt"
activities_test_file_name <- "~/UCI HAR Dataset/test/y_test.txt"
activities_train_file_name <- "~/UCI HAR Dataset/train/y_train.txt"
subjects_test_file_name <- "~/UCI HAR Dataset/test/subject_test.txt"
subjects_train_file_name <- "~/UCI HAR Dataset/train/subject_train.txt"


#read features
features <- read.table(features_file_name, header = FALSE, sep = " ")
features <- rename(features, c("V1"="feature_id", "V2"="feature"))
head(features)
num_of_features <- nrow(features)

# Read measurements
gc()
widths <- rep.int(16, num_of_features)
measurements_test <- read.fwf(measurements_test_file_name, widths, header = FALSE, skip = 0, col.names = as.character(features$feature),buffersize = 100)
measurements_train <- read.fwf(measurements_train_file_name, widths, header = FALSE, skip = 0, col.names = as.character(features$feature),buffersize = 100)

# Read activities
activity_labels <- read.table(activity_labels_file_name, header = FALSE, sep = " ")
activities_test <- as.data.frame(read.table(activities_test_file_name, header = FALSE, sep = " "))
activities_train <- as.data.frame(read.table(activities_train_file_name, header = FALSE, sep = " "))

# Read subjects
subjects_test <- as.data.frame(read.table(subjects_test_file_name, header = FALSE, sep = " "))
subjects_train <- as.data.frame(read.table(subjects_train_file_name, header = FALSE, sep = " "))

# Join and union
subjects <- rbind(subjects_test, subjects_train)
activities <- rbind(activities_test, activities_train)
measurements <- rbind(measurements_test, measurements_train)
n_obs <- nrow(subjects)
n_obs
ids <- data.frame(1:n_obs)

# Rename columns
subjects <- rename(subjects, c("V1" = "subj"))
activities <- rename(activities, c("V1" = "act_id"))
activity_labels <- rename(activity_labels,c("V1" = "act_id", "V2" = "activity"))
activities <- merge(activities, activity_labels, by = "act_id", all.x = TRUE, all.y = FALSE)
head(activities)
ids <- rename(ids, c("X1.n_obs" = "id"))
all_data <- cbind(ids, subjects, activities$activity, measurements)
all_data <- rename(all_data, c("activities$activity" = "activity"))


#Select mean and std (result - restricted_data)

mean_std_count <- 0
mean_std_cols <- 0
for (i in 1:num_of_features){
  if ((grepl(glob2rx("*mean()*"), as.character(features$feature[i]))) == 1){
    mean_std_count <- mean_std_count + 1
    mean_std_cols[mean_std_count] <- features$feature_id[i]
  }
  if ((grepl(glob2rx("*std()*"), as.character(features$feature[i]))) == 1){
    mean_std_count <- mean_std_count + 1
    mean_std_cols[mean_std_count] <- features$feature_id[i]
  }
}

restricted_data <- select(all_data, c(c(2,3),(mean_std_cols + 3)))

subj_act_group <- group_by(restricted_data, subj, activity)
output_data <- summarise_each(subj_act_group, funs(mean))

# Write my tidy dataset (subj_data) into the text file named "output_data.txt"
write.table(subj_data, "output_data.txt", row.name=FALSE, quote = FALSE)