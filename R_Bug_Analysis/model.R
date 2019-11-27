install.packages('e1071', dependencies=TRUE)
#Loading required packages
install.packages('tidyverse')
install.packages('ggplot2')
install.packages('caret')
install.packages('caretEnsemble')
install.packages('psych')
install.packages('Amelia')
install.packages('mice')
install.packages('GGally')
install.packages('rpart')
install.packages('randomForest')
install.packages('ROCR')
install.packages('gplots')
install.packages('pROC')
install.packages('bartMachine')
install.packages('scmamp')
library(scmamp)
library(e1071)
library(pROC)
library(tidyverse)
library(ggplot2)
library(caret)
library(caretEnsemble)
library(psych)
library(Amelia)
library(mice)
library(GGally)
library(rpart)
library(randomForest)

library(gplots)
library(ROCR)

# 10 kinds of machine learning methods to modeling
# 10-10fold cross validation AUC and CE
# plotCD to compare those methods




xalan <- read.csv("R/assignment/xalan-2.4.csv")s
xalan$bug = ifelse(xalan$bug == '0',0,1)
xalan$bug <- factor(xalan$bug,levels = c(1,0),labels = c("True","False"))

idxTrain <- createDataPartition(y=xalan$bug,p=0.75,list=FALSE)
training <- xalan[idxTrain,]
testing <- xalan[-idxTrain,]

x = training[4:22]
y = training$bug

for (algo in c("nb","C5.0","LogitBoost","adaboost","RRF","rf","mda","gaussprLinear","bayesglm"))
{
  print(algo)
  model = train(x,y,algo,trControl=trainControl(method='cv',number=10))
  pred.algo <- predict(model,newdata = testing)
  matrix.algo <- confusionMatrix(pred,testing$bug)
}


