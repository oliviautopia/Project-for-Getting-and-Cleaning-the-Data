# Project-for-Getting-and-Cleaning-the-Data
# By Olivia He

## Course Project
There are 5 requirements in this project:
You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to work on this course project

## Package I have used:
library(dplyr)
library(reshape2)
library(plyr)
library(data.table)

1. Set the directory as the folder:
   setwd('/Users/apple/Desktop/Data Science/2. Cleaning the Data/UCI HAR Dataset')
   
2. Download files relevant to our project and save the data from each txt file as the corresponding matrix.
   txt file               -->   Matrix Name          Dimension
   activity_labels.txt    ——>  activity_labels        (6,1)
   features.txt           -->  features               (561,1)
   X_test.txt             -->  X_test                 (2947,561)
   X_train.txt            -->  X_train                (7352,561)
   y_test.txt             -->  y_test                 (2947,1)
   y_train.txt            -->  y_train                (7352,1)
   subject_test.txt       -->  subject_test           (2947,1)
   subject_train.txt      -->  subject_train          (7352,1)
   
3. Bind data:
  First,  combined the 1) subject_test, 2) y_test and 3) X_test together as the matrix named as test
          and the dimension for matrix test is ( 2947,563 )
          Then named the rownames(test)rownames(test) as format"test1,test2.......test2947"
          my code is as :   rownames(test)<-paste('test',1:dim(test)[1])
  Secondly, repeated the same step as above to 1)subject_train, 2) y_train and 3) X_train
          and the combined matrix train has dimension as (7352,563).
          Then named the rownames of train as 'train1,train2........train7352'
          my code is as:    rownames(train)<-paste('train',1:dim(train)[1])
  Finally, combined the 1) test and  2) train together , named the new matrix as dataset.
          named the first and second column of dataset as : names(dataset)[c(1,2)]=c('subject','ActivityID')
          
  Now, i have the dataframe named as dataset, it gave me information as following:
  
4. Choosing variables contains(mean or std).
# Extract only the measurements on the mean and standard deviation for each measurement.
  I use grep() to extract the key features, and my new dataset with those extracted feature has dimension as (10299,88)
  
5.  Add descriptive Label to my data
 First, before i have add descriptive label to my data, let me have a look at the names of my data:
        Here is my code: names(dataset)[1:4]
        And the result is :  # [1] "subject"   "ActivityID"    "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y".......
        Because there is abbrevation like ‘tbodyAcc’, which is hard to understand, then i replace all these abb. to original words.
        My replacement rules are as follwing:
                  # 1)prefix t is replaced by time
                  # 2)Acc is replaced by Accelerometer
                  # 3)Gyro is replaced by Gyroscope
                  # 4)Mag is replaced by Magnitude
                  # 5)BodyBody is replaced by Body
        Now, the names of my data is:[1] "subject"   "ActivityID"   "timeBodyAccelerometer-mean()-X"  "timeBodyAccelerometer-mean()-Y"
 Second, insert a new column named 'ActivityLabel' , and its value depends on the column named'ActicutyID'. 
        The ActivityLabel is the illustration for the ActivityID.
        For example: ID=1 means   WALKING
                     ID=2         WALKING_UPSTAIRS
                        3         WALKING_DOWNSTAIRS
                        4         SITTING
                        5         STANDING
                        6         LAYING
                        
6. independent average for each activity and each subject
 First, i use group_by() to group my dataset, then use aggragate(,,mean) to calculate the mean within each groups.
 
7. Finally, i output the my result as: write.table(tidy_data, file = "./tidy_data.txt",row.names = F)





