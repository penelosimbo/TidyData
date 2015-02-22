# Readable names of needed columns
ColNames <- c("TimeBodyAccelerationMeanX",
              "TimeBodyAccelerationMeanY",
              "TimeBodyAccelerationMeanZ",
              "TimeBodyAccelerationStdDevX",
              "TimeBodyAccelerationStdDevY",
              "TimeBodyAccelerationStdDevZ",
              "TimeGravityAccelerationMeanX",
              "TimeGravityAccelerationMeanY",
              "TimeGravityAccelerationMeanZ",
              "TimeGravityAccelerationStdDevX",
              "TimeGravityAccelerationStdDevY",
              "TimeGravityAccelerationStdDevZ",
              "TimeBodyAccelJerkMeanX",
              "TimeBodyAccelJerkY",
              "TimeBodyAccelJerkZ",
              "TimeBodyAccelJerkStdDevX",
              "TimeBodyAccelJerkStdDevY",
              "TimeBodyAccelJerkStdDevZ",
              "TimeBodyGyroscopeMeanX",
              "TimeBodyGyroscopeMeanY",
              "TimeBodyGyroscopeMeanZ",
              "TimeBodyGyroscopeStdDevX",
              "TimeBodyGyroscopeStdDevY",
              "TimeBodyGyroscopeStdDevZ",
              "TimeBodyGyroJerkMeanX",
              "TimeBodyGyroJerkMeanY",
              "TimeBodyGyroJerkMeanZ",
              "TimeBodyGyroJerkStdDevX",
              "TimeBodyGyroJerkStdDevY",
              "TimeBodyGyroJerkStdDevZ",
              "TimeBodyAccelerationMagnitudeMean",
              "TimeBodyAccelerationMagnitudeStdDev",
              "TimeGravityAccelerationMagnitudeMean",
              "TimeGravityAccelerationMagnitudeStdDev",
              "TimeBodyAccelJerkMagnitudeMean",
              "TimeBodyAccelJerkMagnitudeStdDev",
              "TimeBodyGyroMagnitudeMean",
              "TimeBodyGyroMagnitudeStdDev",
              "TimeBodyGyroJerkMagnitudeMean",
              "TimeBodyGyroJerkMagnitudeStdDev",
              "FrequencyBodyAccelerationMeanX",
              "FrequencyBodyAccelerationMeanY",
              "FrequencyBodyAccelerationMeanZ",
              "FrequencyBodyAccelerationStdDevX",
              "FrequencyBodyAccelerationStdDevY",
              "FrequencyBodyAccelerationStdDevZ",
              "FrequencyBodyAccelJerkMeanX",
              "FrequencyBodyAccelJerkMeanY",
              "FrequencyBodyAccelJerkMeanZ",
              "FrequencyBodyAccelJerkStdDevX",
              "FrequencyBodyAccelJerkStdDevY",
              "FrequencyBodyAccelJerkStdDevZ",
              "FrequencyBodyGyroscopeMeanX",
              "FrequencyBodyGyroscopeMeanY",
              "FrequencyBodyGyroscopeMeanZ",
              "FrequencyBodyGyroscopeStdDevX",
              "FrequencyBodyGyroscopeStdDevY",
              "FrequencyBodyGyroscopeStdDevZ",
              "FrequencyBodyAccelerationMagnitudeMean",
              "FrequencyBodyAccelerationMagnitudeStdDev",
              "FrequencyBodyAccelJerkMagnitudeMean",
              "FrequencyBodyAccelJerkMagnitudeStdDev",
              "FrequencyBodyGyroscopeMagnitudeMean",
              "FrequencyBodyGyroscopeMagnitudeStdDev",
              "FrequencyBodyGyroJerkMagnitudeMean",
              "FrequencyBodyGyroJerkMagnitudeStdDev")

# Indices of corresponding columns in features data
ColIndices <- c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 
                86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166,
                201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268,
                269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427,
                428, 429, 503, 504, 516, 517, 529, 530, 542, 543)


# Converts data from a string containing numbers to a numeric vector
BreakData <- function(Str = character()){
    Num <- nchar(Str) %/% 16
    if(nchar(Str) %% 16 != 0) stop("Wrong data format.")
    
    NumVector <- numeric()
    for(i in 1:Num)
        NumVector[i] <- as.numeric(substr(Str, (i-1)*16+1, i*16))
    NumVector
}

# Loads data from either test or training dataset and returns a data frame
LoadData <- function(dir = "", ActTypes = data.frame(), 
                     mode = c("test", "train")){
    if(dir != "" & substr(dir, nchar(dir), nchar(dir)) != "/") 
        dir <- paste(dir, "/", sep = "")
    Tester <- as.integer(readLines(paste(dir, "subject_", mode, ".txt", 
                                         sep = "")))
    XTest <- readLines(paste(dir, "X_", mode, ".txt", sep = ""))
    
    Activity <- as.integer(readLines(paste(dir, "Y_", mode, ".txt", sep = "")))

    ResultData <- as.data.frame(setNames(replicate(length(ColNames),
                                numeric(0), simplify = F), ColNames))
    
    # Parsing every string into char vector
    for(i in 1:length(XTest)){
        DataStr <- BreakData(XTest[i])
        DataStr <- DataStr[ColIndices]
        ResultData[i, ] <- DataStr
    }
    
    DataAcc <- data.frame(Tester = Tester, ActID = Activity)
    DataAcc <- merge(DataAcc, ActTypes, by.x = "ActID", by.y = "ID", 
                     all.x = TRUE)
    ResultData$Tester <- DataAcc$Tester
    ResultData$Activity <- DataAcc$Activity
    ResultData
}

# Loads data from the guven files, merges all datasets in one and returns 
# a working dataset
GetData <- function(dir = ""){
    
    if(dir == "") dir <- getwd() 
    TestDataDir <- paste(dir, "test", sep = "/")
    TrainDataDir <- paste(dir, "train", sep = "/")
    
    ActivityTypes <- read.table(paste(dir, "activity_labels.txt", sep = "/"), 
                        sep = " ", col.names = c("ID", "Activity"),
                        stringsAsFactors = FALSE)
    TestData <- LoadData(TestDataDir, ActivityTypes, "test")
    TidyData <- LoadData(TrainDataDir, ActivityTypes, "train")
    TidyData <- rbind(TidyData, TestData)
    TidyData
}

# Calculating averages from a cleaned dataset
CalcAverages <- function(Data = data.frame()){
    aggregate(Data[, 1:66], by = Data[c("Tester", "Activity")], FUN = mean)
}

TidyData <- GetData()
Averages <- CalcAverages(TidyData)
write.table(Averages, "tidy_data_avg.txt", row.names = FALSE, sep = ",")