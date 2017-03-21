library(DMwR)
library(nnet)
feature <- read.csv("../data/sift_features.csv", header = T)
feature<- t(feature)
data <- data.frame(feature)
data$y <- c(rep(1,1000), rep(0,1000))
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




