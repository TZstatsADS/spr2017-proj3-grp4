library(DMwR)
library(nnet)
feature <- read.csv("../data/sift_features.csv", header = T)
feature<- t(feature)
data <- data.frame(feature)
data$y <- c(rep(0,1000), rep(1,1000))
data$y <- as.factor(data$y)

n <- nrow(data)
set.seed(2)
samp <- sample(1:n,n/5)  
traindata<- data[-samp, ]
testdata<- data[samp, ]

model.nnet <- nnet(y ~ ., data = traindata, linout = F,
                   size = 2, decay = 0.01, maxit = 200,
                   trace = F, MaxNWts = 20000)
pre.nnet <- predict(model.nnet, traindata, type = "class")
table(pre.nnet, traindata$y)

test.nnet <- predict(model.nnet, testdata, type = "class")
table(test.nnet, testdata$y)

############ Random Forest######################
# First tune random forest model, tune parameter 'mtry'
library(randomForest)
bestmtry <- tuneRF(y= traindata$y, x= traindata, stepFactor=1.5, improve=1e-5, ntree=600)
best.mtry <- bestmtry[,1][which.min(bestmtry[,2])]

model.rf <- randomForest(y ~ ., data = traindata, ntree=600, mtry=best.mtry, importance=T)
pre.rf <- predict(model.rf, traindata, type = "class")
table(pre.rf, traindata$y)

test.rf <- predict(model.rf, testdata, type = "class")
table(test.rf, testdata$y)
