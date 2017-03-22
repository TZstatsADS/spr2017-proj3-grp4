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
gbm1=gbm(y~.,data=train.data,dist="adaboost",n.tree = 400,shrinkage=0.1)
n=gbm.perf(gbm1)
gbm2=gbm(y~.,data=train.data,dist="adaboost",n.tree = n,shrinkage=0.1)
return(list(gbm=gbm2,n=n))
}