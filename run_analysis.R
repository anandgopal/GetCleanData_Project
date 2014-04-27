## Week 3 | Project | Gettting and Cleaning Data
## April 27, 2014

#setwd("~/Documents/Coursera/GetCleanData/Project/UCI HAR Dataset")
library(plyr)
library(Hmisc)
library(reshape)
library(reshape2)

## Read Activity Labels and Features List into datasets

Activity_Labels = read.table("./activity_labels.txt",sep=" ",col.names = c("Activity_Cd","Activity_Name"))
Features = read.table("./features.txt",sep=" ",col.names = c("No.","FeatureName"))
Features = Features$FeatureName

Keep_Features = ((grepl("mean",Features)) | (grepl("std",Features))) & (!grepl("meanF",Features))
Keep_Features = c(T,T,Keep_Features,T)


## Read Test Data into a dataframe, while merging with Activity Labels and Features
## Thus adding descriptive activity names for each observation in the dataset

  Subjects = as.numeric(readLines("./test/subject_test.txt"))
  Test_Labels = as.numeric(readLines("./test/y_test.txt"))
  
  Test_set = read.table("./test/X_test.txt",col.names = Features)

  Test_DataFrame = data.frame(Subject_id = Subjects, Activity_Cd = Test_Labels, Test_set)
  Test_DataFrame = join(Test_DataFrame,Activity_Labels)

## Read Training Data into a dataframe, while merging with Activity Labels and Features
## Thus adding descriptive activity names for each observation in the dataset

  Subjects = as.numeric(readLines("./train/subject_train.txt"))
  Train_Labels = as.numeric(readLines("./train/y_train.txt"))

  Train_set = read.table("./train/X_train.txt",col.names = Features)

  Train_DataFrame = data.frame(Subject_id = Subjects, Activity_Cd = Train_Labels, Train_set)
  Train_DataFrame = join(Train_DataFrame,Activity_Labels)

## Merge the 2 data frames so we have a merged dataset from both training and test

  Combo_Data = rbind(Test_DataFrame,Train_DataFrame)

## Extract only measurements on the mean and std deviation for each measurement

  Combo_Data = Combo_Data[,Keep_Features]

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.

  drop = "Activity_Cd"
  Combo_Data = Combo_Data[,!(names(Combo_Data) %in% drop)] 
  
  Variables_Measure = names(Combo_Data)[2:67]
  ComboMelt = melt(Combo_Data,id = c("Activity_Name","Subject_id"),measure.vars = Variables_Measure)
  TidyData = dcast(ComboMelt, Subject_id + Activity_Name  ~ variable, mean)

  write.table(TidyData, file="./tidydata.txt", sep="\t", row.names=FALSE)
