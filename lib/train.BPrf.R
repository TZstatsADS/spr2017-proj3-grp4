############ BP network######################
train.BP<- function(traindata) {
  library(DMwR)
  library(nnet)

  model.nnet <- nnet(y ~ ., data = traindata, linout = F,
                   size = 2, decay = 0.01, maxit = 200,
                   trace = F, MaxNWts = 20000)
  return(model.nnet)
}

############ Random Forest######################
# First tune random forest model, tune parameter 'mtry'
train.rf<- function(traindata) {
  
  library(randomForest)
  bestmtry <- tuneRF(y= traindata$y, x= traindata, stepFactor=1.5, improve=1e-5, ntree=600)
  best.mtry <- bestmtry[,1][which.min(bestmtry[,2])]

  model.rf <- randomForest(y ~ ., data = traindata, ntree=600, mtry=best.mtry, importance=T)
  return(model.rf)
}
