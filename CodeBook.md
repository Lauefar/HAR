The run_analysis.R does the following 
1 Downloads and unxip the Human Activity Recognition data from UCI Machine Learning Repository
2 Relevant files is placed in list 
     Relevant files are txt files with ending names "train" and "test", but not files placed in subdirectories.
3 Relevant files are loaded to workspace as frames and frame-names (variables) are kept in list
4 Test and train data frames are merged into one dataset using dplyr package 
5 Measurements categorized as mean or standard deviation is kept 
6 Activity values in merged dataset is factorizeed and replaced by activity descriptions found in features.txt 
7 A tidy dataset with mean values is created using pipeline operator %>% and plyr 
8 The tidy dataset is exported in file "UCI_HAR_Tidydataset.txt"

