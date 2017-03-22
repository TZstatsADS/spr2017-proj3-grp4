############ gbm ######################
packages.used=c("gbm", "caret")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

library(gbm)
library(caret)

train.baseline=function(train.data)
{
  gbm1=gbm(y~.,data=train.data,dist="adaboost",n.tree = 800,shrinkage=0.1)
  n=gbm.perf(gbm1)
  gbm2=gbm(y~.,data=train.data,dist="adaboost",n.tree = n,shrinkage=0.1)
  return(list(gbm=gbm2,n=n))
}

############ BP network ######################
train.BP<- function(traindata) {
  library(DMwR)
  library(nnet)
  traindata$y<- as.factor(traindata$y)
  model.nnet <- nnet(y ~ ., data = traindata, linout = F,
                     size = 3, decay = 0.01, maxit = 200,
                     trace = F, MaxNWts=5000)
  return(model.nnet)
}

############ Random Forest ######################
# First tune random forest model, tune parameter 'mtry'
train.rf<- function(traindata) {
  
  traindata$y<- as.factor(traindata$y)
  y.index<- which(colnames(traindata)=="y")
  library(randomForest)
  bestmtry <- tuneRF(y= traindata$y, x= traindata[,-y.index], stepFactor=1.5, improve=1e-5, ntree=600)
  best.mtry <- bestmtry[,1][which.min(bestmtry[,2])]
  
  model.rf <- randomForest(y ~ ., data = traindata, ntree=600, mtry=best.mtry, importance=T)
  return(model.rf)
}

############ SVM ######################
train.svm<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.svm<- svm(y~., data = traindata)
  return(model.svm)
}

########### Build the Training function ##########
Train <- function(data){
  
}

### model trainning
# read training feature data
norm2 = read.csv(file.choose(), header = T)
# add label on feature data
norm2$Num_Categories[1:1000] = 1
norm2$Num_Categories[1001:2000] = 0
# train model
model = Train(data = norm2, Y = Num_Categories)