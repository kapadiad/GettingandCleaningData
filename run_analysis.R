# Getting and cleaning data Course Project
library(dplyr)

hek##Read in test and train datasets
testdata = read.table("test/X_test.txt")
traindata = read.table("train/X_train.txt")

##Add column names to test and train data
clnamesdata = read.table("features.txt")
clnames = clnamesdata[[2]]
names(testdata) = clnames
names(traindata) = clnames

##Add labels to test and train data
testlabels = read.table("test/y_test.txt")
names(testlabels) = c("Activity")
trainlabels = read.table("train/y_train.txt")
names(trainlabels) = c("Activity")
testdata = cbind(testlabels,testdata)
traindata = cbind(trainlabels, traindata)

##Add subjects to test and train data
testsubj = read.table("test/subject_test.txt")
names(testsubj) = c("Subject")
trainsubj = read.table("train/subject_train.txt")
names(trainsubj) = c("Subject")
testdata = cbind(testsubj,testdata)
traindata = cbind(trainsubj, traindata)

##Merge the datasets to form a single data set
data = rbind(testdata, traindata)


##Identify columns for mean and std deviation
ab = grepl(c("mean"),clnamesdata[,2]) | grepl(c("std"),clnamesdata[,2])

##Adding TRUE to ab to account for Subject and ActivityID
ab1 = c(TRUE, TRUE)
ab = append(ab1, ab)

##Subset data for only mean and std deviation
data1 = data[ab]

##Replace Activity id with name
activitynames = read.table("activity_labels.txt")

for (i in 1:length(data1)) {
        activityid = data1$Activity
        data1$Activity = activitynames[activityid, 2]
}

## Create tidy data set

tidydata =  group_by(data1, Subject, Activity) %>% summarise_each(c("mean"))

## Write tidydata to file
write.table(tidydata, file="tidydataset.txt", row.names = FALSE)
