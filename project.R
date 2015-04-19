setwd("~/Documents/datasciencecoursera/MachineLearning")
rm(list=ls())
# submit function
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

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
###############################


# model using tree Train Accuracy: 0.4972 Test Accuracy 0.4899
modTree <- train(classe~.,method="rpart",data=train)

predTreeTrain <- predict(modTree,train)
confusionMatrix(predTreeTrain,train$classe)

predTree <- predict(modTree,test)
confusionMatrix(predTree,test$classe)

# model using Logit Boost - Train Accuracy : 0.9043 - Test Accuracy : 0.8966
modLB <- train(classe~.,method="LogitBoost",data=train)

predLBTrain <- predict(modLB,train)
confusionMatrix(predGLMTrain,train$classe)

predLB <- predict(modLB,test)
confusionMatrix(predLB,test$classe)

# model using  - Train Accuracy : 0.7084  - Test Accuracy : 0.6936
modLDA <- train(classe~.,method="lda",data=train)

predLDATrain <- predict(modLDA,train)
confusionMatrix(predLDATrain,train$classe)

predLDA <- predict(modLDA,test)
confusionMatrix(predLDA,test$classe)

# model using Gradient Boosting - Train Accuracy : 0.9772  - Test Accuracy : 0.9618
modLDA <- train(classe~.,method="gbm",data=train)

predLDATrain <- predict(modLDA,train)
confusionMatrix(predLDATrain,train$classe)

predLDA <- predict(modLDA,test)
confusionMatrix(predLDA,test$classe)

# model using C5.0 - Train Accuracy : 1  - Test Accuracy : 0.9934
modLDA <- train(classe~.,method="C5.0",data=train)

predLDATrain <- predict(modLDA,train)
confusionMatrix(predLDATrain,train$classe)

predLDA <- predict(modLDA,test)
confusionMatrix(predLDA,test$classe)

# model using random forest
modRF <- randomForest(classe~.,data=training)

predRF <- predict(modRF,test)
confusionMatrix(predRF,test$classe)