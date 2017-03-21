library('FNN')


path='/training_data/training_data/sift_features'
path.folder<- paste(getwd(),path,sep = '')
feature_data=read.csv(paste(path.folder,'/sift_features.csv',sep = ''),header = T)
feature_data=t(feature_data)

path2='/training_data/training_data/'
path2.folder=paste(getwd(),path2,sep = '')
label_data=read.csv(paste(path2.folder,'labels.csv',sep = ''),header = T)
dim(label_data)

data_matrix=cbind(label_data,feature_data)


dim(data_matrix)

predict_rate=c()

for (k in 1:10){

n=2000
sampe_index=sample(1:n,n/5)
training=data_matrix[-sampe_index,]
test=data_matrix[sampe_index,]
dim(test)

cl=factor(training[,1])
knn_result=knn(training[,-1],test[,-1],cl,k=1,prob = T)
predict=sum(knn_result==test[,1])/length(test[,1])
predict_rate=c(predict_rate,predict)
table(knn_result,test[,1])

}


mean(predict_rate)


























