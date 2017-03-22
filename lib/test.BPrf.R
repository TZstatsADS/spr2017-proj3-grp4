test.BP<- function(model, testdata) {
  pre.BP<- predict(model, testdata, type = "class")
  return(pre.BP)
}
test.rf <- function(model,testdata) {
  return(predict(model.rf, testdata, type = "class"))
}