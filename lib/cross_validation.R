########################
### Cross Validation ###
########################

cv.function <- function(data, K){
  
  n <- length(y.train)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error.baseline <- rep(NA, K)
  cv.error.BP <- rep(NA, K)
  cv.error.rf <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- data[s != i,]
    test.data <- data[s == i,]

    fit.baseline <- train.baseline(train.data)
    pred.baseline <- test.baseline(fit.baseline, test.data)  
    cv.error.baseline[i] <- mean(pred.baseline != test.data$y)

    fit.BP <- train.BP(train.data)
    pred.BP <- test.BP(fit.BP, test.data)  
    cv.error.BP[i] <- mean(pred.BP != test.data$y)
    
    fit.rf <- train.rf(train.data)
    pred.rf <- test.baseline(fit.rf, test.data)  
    cv.error.rf[i] <- mean(pred.rf != test.data$y)
  }			
  cv.error<- data.frame(baseline = c(mean(cv.error.baseline),sd(cv.error.baseline)) ,
                        BP = c(mean(cv.error.BP), sd(cv.error.BP)), 
                        rf = c(mean(cv.error.rf), sd(cv.error.rf)))
  return(cv.error)
}
