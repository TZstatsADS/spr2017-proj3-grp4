########################
### Cross Validation ###
########################

cv.function <- function(data, K){
  
  n <- nrow(data)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error.baseline <- rep(NA, K)
  cv.error.BP <- rep(NA, K)
  cv.error.rf <- rep(NA, K)
  cv.error.svm <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- data[s != i,]
    test.data <- data[s == i,]

    fit.baseline <- train.baseline(train.data)
    pred.baseline <- test.baseline(fit.baseline, test.data)  
    cv.error.baseline[i] <- mean(pred.baseline != test.data$y)

    fit.BP <- train.bp(train.data)
    pred.BP <- test.bp(fit.BP, test.data)  
    cv.error.BP[i] <- mean(pred.BP != test.data$y)
    
    fit.rf <- train.rf(train.data)
    pred.rf <- test.rf(fit.rf, test.data)  
    cv.error.rf[i] <- mean(pred.rf != test.data$y)
    
    fit.svm <- train.svm(train.data)
    pred.svm <- test.svm(fit.svm, test.data)  
    cv.error.svm[i] <- mean(pred.svm != test.data$y)
  }			
  cv.error<- data.frame(baseline = mean(cv.error.baseline) ,BP = mean(cv.error.BP), 
                        rf = mean(cv.error.rf), svm = mean(cv.error.svm))
  return(cv.error)
}
