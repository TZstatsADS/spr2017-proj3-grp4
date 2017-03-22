##########Using PCA to process data
# To imporve efficiency, we use PCA to do feature selection
# Combined with cross-validation step to avoid overfitting (set training and test data for PCA process)

# First read in 2000x10000 features extracted from SIFT
feature100000<-read.csv("../data/histsall 10000.csv", header = F)
feature100000<-t(feature100000)

# prcomp can handle the high dimension problem that the number of predictors are much larger than the number of
# observations, and it would get as much principal components. In this case, we would get 2000. Thus, we need not
# to select the suitable number of principal components.
pca <- prcomp(feature100000, scale = T)
rot<- data.frame(pca$rotation)
# write.csv(rot, "../output/rot.csv")