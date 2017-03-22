library(DMwR)
library(nnet)
train.bp=function(train.data)
{
 model.nnet <- nnet(y ~ ., data = train.data, linout = F,
                     size = 2, decay = 0.01, maxit = 200,
                     trace = F, MaxNWts = 20000)
 return(model.nnet)
}
