setwd("~/Documents/datasciencecoursera/MachineLearning")
rm(list=ls())
library(caret)
library(rattle)

#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",destfile="pml-training.csv",method="curl")
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",destfile="pml-testing.csv",method="curl")

training <- read.csv("pml-training.csv",na.strings=c("NA","#DIV/0!",""))
testing <- read.csv("pml-testing.csv",na.strings=c("NA","#DIV/0!",""))

# Data Cleaning -
# Remove the first 7 columns as they are not needed
training <- training[-c(1:7)]
testing <- testing[-c(1:7)]

# Delete columns with missing values
training <- training[,colSums(is.na(training)) == 0]
testing <- testing[,colSums(is.na(testing)) == 0]

dim(training)
dim(testing)

# Check to see if any of the variable have near zero variance
nearZeroVar(training)

# partition the training data
inTrain <- createDataPartition(y=training$classe,p=.7,list=FALSE)
train <- training[inTrain,]
test <- training[-inTrain,]
dim(train);dim(test)

# model using tree
modTree <- train(classe~.,method="rpart",data=train)
predTree <- predict(modTree,test)
confusionMatrix(predTree,test$classe)

# model using random forest
modRF <- randomForest(classe~.,data=training)
predRF <- predict(modRF,test)
confusionMatrix(predRF,test$classe)