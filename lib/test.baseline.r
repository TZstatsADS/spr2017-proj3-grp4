library(gbm)

test.baseline=function(model,test.data)
{
  prediction=ifelse(predict(model$gbm,test.data,n.trees=model$n)>0,1,0)
  return(prediction)
}