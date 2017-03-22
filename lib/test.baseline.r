packages.used=c("gbm")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

library(gbm)

test.baseline=function(model,test.data)
{
  prediction=ifelse(predict(model$gbm,test.data,n.trees=model$n)>0,1,0)
  return(prediction)
}