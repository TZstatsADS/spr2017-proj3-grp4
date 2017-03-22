library('FNN')
# read data
label_data <- read.csv("../data/labels.csv",header = T)
label=factor(label_data[,1])
feature10000<-read.csv("../data/histsall 10000.csv", header = F)
feature10000=t(feature10000)
# accroding to pca get new feature data

pca <- prcomp(feature10000, scale = T)
rot<- data.frame(pca$rotation)
rot <- as.matrix(rot)
feature_data <- feature10000%*%rot
dim(feature_data)

# this part generate train data and test data
n=2000
sampe_index=sample(1:n,n/5)
train_data=feature_data[-sampe_index,]
train_label <-label[-sampe_index] 
test_data <- feature_data[sampe_index,]
test_label <-label[sampe_index]

# this part is the function defined and it takes 4 variables train_data, train_label, test_data, k
knn_predict <- function(train_data,train_label,test_data,k=1){
  knn_result=knn(train_data,test_data,cl=train_label,k=k,prob = T)
  return(knn_result)}

knn_predict(train_data,train_label,test_data)

sum(knn_result==test_label)/length(test_label)
#following might not useful
#mean(predict_rate)
#predict=sum(knn_result==test[,1])/length(test[,1])
#predict_rate=c(predict_rate,predict)
#table(knn_result,test[,1])




















