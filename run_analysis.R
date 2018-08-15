#This script retreive and proces the the smartphone dataset. The data
#was created bry 30 volunters (refered to as subject), who performed one of 
#six activities while carrying a recording smart phone.  
#
#Present script uses common R-function to retrieve data and dplyr
#package to proces og aggregate data. The main data processing steps are; 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average 
#   of each variable for each activity and each subject.


#Q1. Load and merge test- and train dataset

#1. Retreive & unzip 
setwd("C:/Dokumenter/Uddannelse/Andet/Coursera/Datascience/3GettingCleaning")
getwd()
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
sti<-"./Projectassignment/files.zip"
download.file(fileUrl, destfile=sti, mode='wb')
file.exists(sti)

f<-unzip(sti,exdir = "./Projectassignment")
print(f)

# rm(list = ls())
# load(list.files(pattern = "pa.RData$", recursive = TRUE))

#2. List relevant files 
# relevant files are those not in subdirectory "Inertial Signals")
listfiles <- list.files(pattern = "_train.txt$|_test.txt$", recursive = TRUE)
#listfiles <- list[!grepl("Inertial Signals",listfiles)]
i<-!grepl("Inertial Signals",listfiles)
listfiles <- listfiles[i]
listfiles
#[1] "Projectassignment/UCI HAR Dataset/test/subject_test.txt"  
#[2] "Projectassignment/UCI HAR Dataset/test/X_test.txt"        
#[3] "Projectassignment/UCI HAR Dataset/test/y_test.txt"        
#[4] "Projectassignment/UCI HAR Dataset/train/subject_train.txt"
#[5] "Projectassignment/UCI HAR Dataset/train/X_train.txt"      
#[6] "Projectassignment/UCI HAR Dataset/train/y_train.txt"

#3. Read relevant files as frames. 
#   Named variable as filename     
#   Create variable list called "listvar"
listvar = list()
for(i in seq_along(listfiles)){
  listvar[i] <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(listfiles[i]))
  inc <-read.table(listfiles[i])
  assign(as.character(listvar[i]),inc)
  #print(listfiles[i])   
}
rm(x,inc,i,listfiles)
ls()
# workspace now contains of a list of variables and the the following frames  
#"subject_test"  "subject_train" "X_test"        "X_train"       "y_test"        "y_train" 

#4. Merge relevant six dataframes using dplyr
library(dplyr)
test_data  <- bind_cols(list(X_test,y_test,subject_test))
train_data <- bind_cols(list(X_train,y_train,subject_train))
dat  <- bind_rows(test_data,train_data)
#563 cols & 10299 rows
names(dat)
rm(listvar,Y_test,y_test,X_test,X_train, Y_train, y_train, subject_test,subject_train,test_data,train_data)


#Q2 Extract measurement on "mean" and "std" place in frame called "datstdmean"
# also activity and subject_id should be kept
sti <- list.files(pattern = "features.txt$", recursive = TRUE)
namemap1 <- read.table(sti) #list of featues "V1"-"V561", but not "V1100" "V1101"
namemap2 <- data.frame(V1=c(1100,1101),V2=c("activity","subject_id"))
namemap <- rbind(namemap1,namemap2)
names(dat) <-namemap$V2

relevantcols <- grepl("mean\\(\\)|std\\(\\)|activity|subject_id", names(dat))
datstdmean<-dat[,relevantcols]
#79 cols 10299 rows
rm(namemap,namemap1,namemap2,sti,relevantcols)
names(datstdmean)


#Q3 Add descriptive activity names from "activity_labels.txt" to the "datstdmean" 
sti <- list.files(pattern = "activity_labels.txt$", recursive = TRUE)
activitymap <- read.table(sti)
#
#V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING


#Q4 Appropriate labels 
#   The activities are categorical variables and is transformed into a factor, 
#   which is nice when using data for statistical purposes and in generally a requirement   
#   when creating tidy datasets 
datstdmean$activity <- factor(datstdmean$activity, labels = activitymap$V2)

datstdmean$activity
unique(datstdmean$activity)
rm(activitymap)


#Q5 Tidy dataset with avg of each variable for each activicy and each subject 

# 5.1 Use dplyr to group by subject and activity and to calculate mean 
tidy <-        
  tbl_df(datstdmean) %>%                  # converts "datstdmean" into a data a dplyr 'data frame tbl'             
  group_by(subject_id,activity) %>%       # groupe on each of the 30 subjects
  summarise_each(funs(mean)) %>%          # calculate the mean of each column by subject
  print
 # [30 x 68]  head(tidy)

 sti <- "./Projectassignment/UCI_HAR_Tidydataset.txt"
 write.table(tidy,sti, row.names = false) 
 
