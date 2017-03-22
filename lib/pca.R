##########Using PCA to process data
# To imporve efficiency, we use PCA to do feature selection
# Combined with cross-validation step to avoid overfitting (set training and test data for PCA process)

# First read in 2000x10000 features extracted from SIFT
feature10000<-read.csv("../data/histsall 10000.csv", header = F)
feature10000<-t(feature10000)

# prcomp can handle the high dimension problem that the number of predictors are much larger than the number of
# observations, and it would get as much principal components. In this case, we would get 2000. Thus, we need not
# to select the suitable number of principal components.
pca <- prcomp(feature10000, scale = T)
rot<- (pca$rotation)[,1:500]
feature_new<- feature10000 %*% rot
feature_new<- matrix(unlist(feature_new),2000,500)
write.csv(feature_new, "../output/feature_new.csv")
