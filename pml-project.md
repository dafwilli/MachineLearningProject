---
title: "Practical Machine Learning Course Project"
author: "David Williams"
date: "April 25, 2015"
output: html_document
---

### Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

### Download and read files

```r
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",destfile="pml-training.csv",method="curl")
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",destfile="pml-testing.csv",method="curl")

training <- read.csv("pml-training.csv",na.strings=c("NA","#DIV/0!",""))
testing <- read.csv("pml-testing.csv",na.strings=c("NA","#DIV/0!",""))
```

### Cleaning Data
The following code performs three things: 1) removes the first 7 columns as they do not pertain to the analysis, 2)  Remove any columns that do not contain any data (all NA), and 3) check for any variables that have near zero variance.  Finally, check to see if the dimensions of training and testing are the same.


```r
# Remove the first 7 columns as they are not needed
training <- training[-c(1:7)]
testing <- testing[-c(1:7)]

# Delete columns with missing values
training <- training[,colSums(is.na(training)) == 0]
testing <- testing[,colSums(is.na(testing)) == 0]

# Check to see if any of the variable have near zero variance
nearZeroVar(training)
```

```
## integer(0)
```

```r
dim(training);dim(testing)
```

```
## [1] 19622    53
```

```
## [1] 20 53
```

### Partition the training data
Split the training data into to two section - one to train the model and the other to cross-validate.

```r
inTrain <- createDataPartition(y=training$classe,p=.7,list=FALSE)
train <- training[inTrain,]
cv <- training[-inTrain,]
```

###  Model the data
Using the caret package I created  six models using the package defaults.  The models produced the following:


```
## 
## -----------------------------------------------------
##   Model     Train Accuracy   Cross Validate Accuracy 
## ---------- ---------------- -------------------------
##   rpart         0.4972               0.4899          
## 
## LogitBoost      0.9043               0.8966          
## 
##    lda          0.7084               0.6936          
## 
##    gbm          0.9772               0.9618          
## 
##    C5.0           1                  0.9934          
## 
##     rf            1                  0.9937          
## -----------------------------------------------------
```

The most accurate model is the random forest which was perfect for the training data and very close for the validation data.  I used this model to predict on the test set and was able to predict all 20 samples.  However, we should not expect it to be perfect with out-of-sample data.  The data is from only 6 subjects and is likely tuned to them and clearly the 20 test samples are coming from these 6 subjects.  Most probably, we have overfitted the data to the 6 subjects and if we ran it on subjects NOT in the training set, it is likely that we would get much less accuracy.

A better - more realistic - way to model would be to split the data into 3 subsets where the training subset consists of the data from 4 of the 6 subjects, a validation subset of 1 subject and a testing subset of 1 subject.  More data would certainly help.

### Random Forest Model

```r
modRF <- randomForest(classe~.,data=training)

predRF <- predict(modRF,cv)
confusionMatrix(predRF,cv$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1674    0    0    0    0
##          B    0 1139    0    0    0
##          C    0    0 1026    0    0
##          D    0    0    0  964    0
##          E    0    0    0    0 1082
## 
## Overall Statistics
##                                      
##                Accuracy : 1          
##                  95% CI : (0.9994, 1)
##     No Information Rate : 0.2845     
##     P-Value [Acc > NIR] : < 2.2e-16  
##                                      
##                   Kappa : 1          
##  Mcnemar's Test P-Value : NA         
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            1.0000   1.0000   1.0000   1.0000   1.0000
## Specificity            1.0000   1.0000   1.0000   1.0000   1.0000
## Pos Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
## Neg Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
## Detection Rate         0.2845   0.1935   0.1743   0.1638   0.1839
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      1.0000   1.0000   1.0000   1.0000   1.0000
```

### Run on testing data 

```r
testRF <- predict(modRF,testing)
testRF
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```
