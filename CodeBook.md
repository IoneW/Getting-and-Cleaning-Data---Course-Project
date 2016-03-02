### Original Data
-----------------

This project uses the following files from the UCI HAR Dataset: 

* activity_labels.txt - activity labels
* features_info.txt - variable names
* subject_test.txt - subject IDs from test group
* subject_train.txt - subject IDs from train group
* Y_test.txt - activity IDs from test group
* Y_train.txt - activity IDs from train group
* X_test.txt - measurements from test group
* X_train.txt - measurements from train group

This original data provided 10299 values across 561 measured variables and 3 fixed variables (subject, activity, group).


### Transformations or work performed to clean up the data
----------------------------------------------------------

Subject, activity and measurements were combined in a single dataframe, adding a new 'group' column to identify whether measurements were from the training or test group. Activity IDs were replaced with lables from the 'activity_labels' file, and variables columns were named using the 'features_info' file.

This dataframe was subset to only include variables that measured the mean or standard deviation.

Variable names were modified for ease of understanding. 

The data was then grouped by subject, activity and test/train group, and the average calculated for each variable.

The data was restructured from wide to long with new columns for 'variable' and 'average' to form a simple tidy dataset "tidy_simple.txt".


### Variables

#### Variable features

Variable names were composed of several features, detailed below:

| Feature          | Description                                   |
| ---------------- | --------------------------------------------- |
| Domain           | time or frequency                             |
| Component        | body or gravity                               |
| Instrument       | accelerometer o gyroscope                     |
| Jerk             | derived from acceleration or velocity         |
| Magnitude        | magnitude of each 3 dimensional signal        |
| Statistic        | mean or standard deviation                    |
| Axis             | XYZ direction components of the signal vector |



#### Activity labels

| ID | Label              |
|----|--------------------|
| 1  | WALKING            |
| 2  | WALKING_UPSTAIRS   |
| 3  | WALKING_DOWNSTAIRS |
| 4  | SITTING            |
| 5  | STANDING           |
| 6  | LAYING             |


### Data structure

The tidy dataset has 11880 rows and 5 columns. 

    > str(tidy_simple)
    'data.frame':	11880 obs. of  5 variables:
     $ subject : int  2 4 9 10 12 13 18 20 24 2 ...
     $ activity: Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 2 ...
     $ group   : Factor w/ 2 levels "test","train": 1 1 1 1 1 1 1 1 1 1 ...
     $ variable: Factor w/ 66 levels "Time.Body.Acc.mean.X",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ average : num  0.281 0.264 0.259 0.28 0.26 ...

    > head(tidy_simple)
       subject activity group             variable   average
     1       2   LAYING  test Time.Body.Acc.mean.X 0.2813734
     2       4   LAYING  test Time.Body.Acc.mean.X 0.2635592
     3       9   LAYING  test Time.Body.Acc.mean.X 0.2591955
     4      10   LAYING  test Time.Body.Acc.mean.X 0.2802306
     5      12   LAYING  test Time.Body.Acc.mean.X 0.2601134
     6      13   LAYING  test Time.Body.Acc.mean.X 0.2767164

     > tail(tidy_simple)
           subject         activity group                  variable    average
     11875      25 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.8410610
     11876      26 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.6698463
     11877      27 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.7517143
     11878      28 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.7048528
     11879      29 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.7564642
     11880      30 WALKING_UPSTAIRS train Freq.Body.GyroJerkMag.std -0.7913494
