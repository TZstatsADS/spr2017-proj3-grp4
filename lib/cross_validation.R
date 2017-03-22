########################
### Cross Validation ###
########################

cv.function <- function(data, d, K){
  
  n <- length(y.train)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error.baseline <- rep(NA, K)
  cv.error.glm <- rep(NA, K)
  cv.error.BP <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- data[s != i,]
    test.data <- data[s == i,]

    par <- list(depth=d)
    fit <- train.BP(train.data, par)
    pred <- test.BP(fit, test.data)  
    cv.error[i] <- mean(pred != test.label)  
    
  }			
  return(c(mean(cv.error),sd(cv.error)))
  
}
