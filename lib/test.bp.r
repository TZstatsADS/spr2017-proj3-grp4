library(DMwR)
library(nnet)
test.bp=function(model,test.data)
{
  pre.nnet <- predict(model, test.data, type = "class")
  return(pre.nnet)
}