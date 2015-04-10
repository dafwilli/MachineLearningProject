setwd("~/Documents/datasciencecoursera/MachineLearning")

#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",destfile="pml-training.csv",method="curl")
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",destfile="pml-testing.csv",method="curl")

training <- read.csv("pml-training.csv")
testing <- read.csv("pml-testing.csv")

