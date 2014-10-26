# CodeBook

### Raw Data

The raw data for this project is accelerometer data collected from the Samsung Galaxy S smartphone, and was provided at the links below:

Data file: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
CodeBook: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
This data included both the raw sampled data (folder ../Inertial Signals) and features apparently based on the raw data. For the purpose of this project, I am only looking at the features, not the raw data.

There are 3 types of files:

* x_train/x_test: rows of feature measurements
* y_train/y_test: the activity labels corresponding to each row of X. Encoded as numbers.
* subject_train/subject_test: the subjects on which each row of X was measured. Encoded as numbers.

In addition, to determine which features are required, we look at the list of features:

* features.txt: a list of 561 features
* features_info.txt: a description of features

The encoding from activity labels ids to descriptive names.

* activity_labels.txt: list of 6 different activity labels used in the test/training sets

Data load

The Y, S and X data is loaded from each of the training and test datasets, directly as their final type.
Only the columns of interest from X are loaded, that is the mean() and sd() columns. We determine the columns by examining the feature names (from features.txt) for patterns “-mean()” or “-std()”.
All of these files are fixed format text files.

### Transformation

The activity descriptions are joined to the activity label data (y).
The corresponding training and test datasets are concatenated, and then columns for subject and activitylabel (description) are appended to the data.
The resulting dataset is called MasterData.

The data is further subsetted to only include the activity, subject, and any feature containing mean() or standard() as part of their name. Again these are determined by looking for “-mean()” and “-std()” in the feature name.
The data is then filtered on these columns to produce filteredData.

Thereafter the filtered data gets more descriptive column names by

* removing characters "-", "()",
* set all names to lower case
* replace acc -> accelerometer
* replace gyro -> gyroscope
* replace mean -> meanvalue
* replace std -> standarddeviation
* replace freq -> frequency
* replace t -> time
* replace f -> frequency

The filtered data is grouped by activity and subject and then the mean is calculated for each variable to generate a result data frame.

The result data frame is written to a file: result.txt.

To read back the data into R Studio please use the following command.
data <- read.table("./result.txt", header = TRUE)
