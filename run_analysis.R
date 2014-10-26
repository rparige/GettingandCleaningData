# Step1. Merge training and test datasets.

traindf <- read.table("./train/X_train.txt")

trainLabeldf <- read.table("./train/y_train.txt")
#table(trainLabeldf)
trainSubjectdf <- read.table("./train/subject_train.txt")
testdf <- read.table("./test/X_test.txt")
testLabeldf <- read.table("./test/y_test.txt") 
#table(testLabeldf) 
testSubjectdf <- read.table("./test/subject_test.txt")
combinedatdf <- rbind(traindf, testdf)
combineLabelsdf <- rbind(trainLabeldf, testLabeldf)
combineSubjectdf <- rbind(trainSubjectdf, testSubjectdf)

# Step2. Extracts only mean and standard deviation

featuredf <- read.table("./features.txt")

meanStddf <- grep("mean\\(\\)|std\\(\\)", featuredf[, 2])
combinedatdf <- combinedatdf[, meanStddf]

names(combinedatdf) <- gsub("\\(\\)", "", featuredf[meanStddf, 2])
names(combinedatdf) <- gsub("mean", "Mean", names(combinedatdf)) 
names(combinedatdf) <- gsub("std", "Std", names(combinedatdf)) 
names(combinedatdf) <- gsub("-", "", names(combinedatdf)) 

# Step3. cleanup labels
actdf <- read.table("./activity_labels.txt")
actdf[, 2] <- tolower(gsub("_", "", actdf[, 2]))
substr(actdf[2, 2], 8, 8) <- toupper(substr(actdf[2, 2], 8, 8))
substr(actdf[3, 2], 8, 8) <- toupper(substr(actdf[3, 2], 8, 8))
actLabeldf <- actdf[combineLabelsdf[, 1], 2]
combineLabelsdf[, 1] <- actLabeldf
names(combineLabelsdf) <- "activity"

cleaneddf <- cbind(combineSubjectdf, combineLabelsdf, combinedatdf)

write.table(cleaneddf, "cleanedData.txt") 
colnames(cleaneddf)[1]<-"Subject"

# Step5. Creates a second, independent with means of all columns
SubjectMeansdf<- ddply(cleaneddf,.(Subject, activity), colwise(mean))
SubjectMeansdf<- arrange(SubjectMeansdf, Subject)
head(SubjectMeansdf)
tail(SubjectMeansdf)

write.table(SubjectMeansdf, "SubjectMeans.txt") 
