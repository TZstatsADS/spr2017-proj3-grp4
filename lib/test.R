library(gbm)
library(caret)
library(DMwR)
library(nnet)
library(randomForest)

############ gbm ######################

test.baseline=function(model,test.data)
{
  prediction=ifelse(predict(model$gbm,test.data,n.trees=model$n)>0,1,0)
  return(prediction)
}

############ BP network ######################
test.bp=function(model,test.data)
{
  pre.nnet <- predict(model, test.data, type = "class")
  return(pre.nnet)
}

############ Random Forest ######################
test.rf <- function(model,test.data) {
  return(predict(model, test.data, type = "class"))
}


############ SVM ######################
test.svm <- function(model,test.data)
{
  return(predict(model,test.data,type="class"))
}
