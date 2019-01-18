#reads all necessary files
xtrain <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/train/Y_train.txt")
subtrain <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/train/subject_train.txt")
xtest <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/test/Y_test.txt")
subtest <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/features.txt")
activitylabels <- read.table("C:/Users/asus1/Desktop/UCI HAR Dataset/activity_labels.txt")

#compiles training, testing data by activity, subject and features
#changes labels (inc, obj 3 and 4 below)
subjall <- rbind(subtrain,subtest) #10299 x 1
colnames(subjall) <- "Subject"
actall <- rbind(ytrain,ytest) #10299 x 1
colnames(actall) <- "Activity"
featall <- rbind(xtrain,xtest) #10299 x 561

#OBJECTIVE 3: USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
actall$Activity[actall$Activity==1] <- as.character(activitylabels[1,2])
actall$Activity[actall$Activity==2] <- as.character(activitylabels[2,2])
actall$Activity[actall$Activity==3] <- as.character(activitylabels[3,2])
actall$Activity[actall$Activity==4] <- as.character(activitylabels[4,2])
actall$Activity[actall$Activity==5] <- as.character(activitylabels[5,2])
actall$Activity[actall$Activity==6] <- as.character(activitylabels[6,2])

#OBJECTIVE 4: APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
colnames(featall) <- t(features[2])

#OBJECTIVE 1: MERGES THE TRAINING AND THE TEST SETS 
alldata <- cbind(subjall,actall,featall)

#searches for variables with mentions of mean and std
meanstd <- grep(".*Mean.*|.*Std.*", names(alldata), ignore.case=TRUE)

#creates vector with 1 (subject ID), 2 (activity ID) and the IDs of variables with mean, std
meanstdcol <- c(1,2,meanstd)

#OBJECTIVE 2: EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
meanstddat <- alldata[,meanstdcol]

#OBJECTIVE 5: FROM THE DATA SET IN STEP 4, CREATES A SECOND, IND'T TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT

tidydata <- aggregate(.~Subject+Activity,meanstddat,mean)
write.table(tidydata, file="tidyhw.txt",row.names=FALSE)