##########Using PCA to process data
# To imporve efficiency, we use PCA to do feature selection
# Combined with cross-validation step to avoid overfitting (set training and test data for PCA process)

# First read in 89511 features extracted from SIFT
sift_feature<-read.csv("sift_features.csv")
sift_feature<-t(sift_feature)

# then set k-fold cross-validation
k<-10
n <- nrow(sift_feature)
n.fold <- floor(n/k)
set.seed(1)
s <- sample(rep(1:k, c(rep(n.fold, k-1), n-(k-1)*n.fold)))  


for(i in 1:k) {
  train.data <- sift_feature[s != i,]
  test.data <- sift_feature[s == i,]
  Sigma=cov(train.data)
  Sigma_eigen=eigen(Sigma)
  Gamma=Sigma_eigen$vectors
  P_train=t(Gamma)%*%t(train.data)
  P_test=t(Gamma)%*%t(test.data)
  save(P_train,file=paste('train_',as.character(i),'.RData',sep=''))
  save(P_test,file=paste('test_',as.character(i),'.RData',sep=''))
  print(paste(as.character(i/k*100),'%',' completed',sep=''))
}


# Select the best num of pca dimension

x<-c(1:400)
y<-matrix(data=NA,ncol=400)
for(i in x) {
  y[i]<-sum(Sigma_eigen$values[1:x[i]])/sum(Sigma_eigen$values)
}

plot(x,y)

sum(Sigma_eigen$values[1:100])/sum(Sigma_eigen$values)
