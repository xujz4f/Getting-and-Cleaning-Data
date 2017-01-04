#download files
list.files("C:/Users/Jiadi/Desktop/CourseraDataScience/cleandata/week4/UCI HAR Dataset", recursive=TRUE)
#read files
filesPath <- "C:/Users/Jiadi/Desktop/CourseraDataScience/cleandata/week4/UCI HAR Dataset"

# Read subject files
dataSubjectTrain <- read.table(file.path(filesPath, "train", "subject_train.txt"))
dataSubjectTest  <- read.table(file.path(filesPath, "test" , "subject_test.txt" ))


# Read activity files
dataActivityTrain <- read.table(file.path(filesPath, "train", "Y_train.txt"))
dataActivityTest  <- read.table(file.path(filesPath, "test" , "Y_test.txt" ))

#Read feathure data files.
dataTrain <- read.table(file.path(filesPath, "train", "X_train.txt" ))
dataTest  <- read.table(file.path(filesPath, "test" , "X_test.txt" ))


#1. Merges the training and the test sets to create one data set.

#combine Train and Test data and set names to variables

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
names(dataSubject)<-c("subject")

dataActivity<- rbind(dataActivityTrain, dataActivityTest)
names(dataActivity)<-c("Activity")


dataFeaturesNames <- read.table(file.path(filesPath, "features.txt"))
dataFeatures<- rbind(dataTrain,dataTest)
names(dataFeatures)<-dataFeaturesNames$V2


# Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#2 Extracts only the measurements on the mean and standard deviation for each measurement.

Data2 <- dataFeatures[,grep("mean\\(\\)|std\\(\\)", dataFeaturesNames[,2])]

#3. Uses descriptive activity names to name the activities in the data set
label<-read.table(file.path(filesPath, "activity_labels.txt"))
dataActivity[,1]<-label[(dataActivity[,1]),2]

#4Appropriately labels the data set with descriptive variable names.
Data4 <- cbind(dataSubject,dataActivity,dataFeatures)
head(Data4)
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data5<-aggregate(. ~subject + Activity, Data4, mean)
Data5<-Data5[order(Data5$subject,Data5$Activity),]

write.table(Data5, file = "Data5.txt", row.names = FALSE)
