# The PROJECT.R does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.You should create one R script called run_analysis.R that does the following.

##########
# Step 1
##########
# we should recall all the package we need for tidying our dataset.
library(dplyr)
library(reshape2)
library(plyr)
library(data.table)
# set up the directory
setwd('/Users/apple/Desktop/Data Science/2. Cleaning the Data/UCI HAR Dataset')
# Load activity labels
activity_labels <- read.table("./activity_labels.txt")[,2]
activity_labels<-as.matrix(activity_labels)
#       dimension for activity
#       dim(activity_labels) is c(6,1)
# Load: features
features <- read.table("./features.txt")[,2]
features<-as.matrix(features)
#       dimension for features
#       dim(features) is c(561,1)
# Load and process X_test,y_test data.Ans X_train,y_train data.
X_test <- as.matrix(read.table("./test/X_test.txt"))    #dim(X_test)  :  2947,561
X_train <- as.matrix(read.table("./train/X_train.txt")) #dim(X_train) :  7352,561
y_test <- as.matrix(read.table("./test/y_test.txt"))    #dim(y_test)  :  2947,1
y_train <- as.matrix(read.table("./train/y_train.txt")) #dim(y_train) :  7352,1
subject_test <- as.matrix(read.table("./test/subject_test.txt"))  #dim(subject_test) : 2947,1
subject_train <- as.matrix(read.table("./train/subject_train.txt"))#dim(subject_train):7352,1
# The features is the column name for X_test and X_train
colnames(X_test)= t(features)
colnames(X_train) = t(features)
# head(X_test,2);head(X_train)
# Bind data
test<- cbind(subject_test, y_test, X_test)# dim(test)    2947,563
rownames(test)<-paste('test',1:dim(test)[1])
train=cbind(subject_train,y_train,X_train)# dim(train)   7352,563
rownames(train)<-paste('train',1:dim(train)[1])
dataset=rbind(test,train)                 # dim(dataset) 10299,563
dataset=as.data.frame(dataset)
# names is suitable for data frame, colnames is suitable for matrix
names(dataset)[c(1,2)]=c('subject','ActivityID')
################
# Step 2
################
# Extract only the measurements on the mean and standard deviation for each measurement.
keyfeature1<-names(dataset)[c(1:2)]
keyfeature2<- names(dataset[grep("mean|std", names(dataset), ignore.case=TRUE)])
keyfeature=c(keyfeature1,keyfeature2)
dataset= as.data.frame(dataset[keyfeature]) # dim(dataset) : 10299,88

###############################
# Step 3 Add descriptive Label
###############################
# insert the activity labels as the 3rd column in dataset
names(dataset)[1:5]
# [1] "subject"           "ActivityID"        "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y"
# [5] "tBodyAcc-mean()-Z"
ActivityLabel=data.frame(rep(0,dim(dataset)[1]))
ActivityLabel=activity_labels[dataset$ActivityID]
dataset=cbind( dataset[,c(1:2),drop=F], ActivityLabel, dataset[,c(3:dim(dataset)[2]) ]  )
dim(dataset)    # 10299,89
names(dataset)[1:5]
#[1] "subject"           "ActivityID"        "ActivityLabel"     "tBodyAcc-mean()-X"
#[5] "tBodyAcc-mean()-Y"
# a=dataset[,2:3];a;
##################################
# Step 4
##################################
names(dataset)
# prefix t is replaced by time
# Acc is replaced by Accelerometer
# Gyro is replaced by Gyroscope
# Mag is replaced by Magnitude
# BodyBody is replaced by Body
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
################################################################
# Step 5 independent average for each activity and each subject
################################################################
# 1. average for each subject
d1=group_by(dataset,subject);head(d1)
aggregate(d1[, 4:dim(d1)[2]], list(d1$subject), mean)
# 2. average for each activity level
d2=group_by(dataset,ActivityLabel);head(d2)
aggregate(d2[, 4:dim(d2)[2]], list(d2$ActivityLabel), mean)
# 3. average for each subject and activity
d3=group_by(dataset,ActivityLabel,subject);head(d3)
tidy_data=aggregate(d3[, 4:dim(d3)[2]], list(d3$ActivityLabel,d3$subject), mean)
names(tidy_data)[1:2]=c('subject','Acticity')
write.table(tidy_data, file = "./tidy_data.txt",row.names = F)







