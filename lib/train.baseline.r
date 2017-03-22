library(gbm)
library(caret)

train.baseline=function(train.data)
{
gbm1=gbm(y~.,data=train.data,dist="adaboost",n.tree = 400,shrinkage=0.1)
n=gbm.perf(gbm1)
gbm2=gbm(y~.,data=train.data,dist="adaboost",n.tree = n,shrinkage=0.1)
return(list(gbm=gbm2,n=n))
}