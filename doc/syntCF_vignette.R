## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup,eval=FALSE---------------------------------------------------------
#  library(SyntCF)
#  

## ----eval=FALSE---------------------------------------------------------------
#  set.seed(1)
#  tsn=365*10
#  x1 <- as.numeric(tsn + arima.sim(model = list(ar = 0.999), n = tsn))
#  x2 <- as.numeric(tsn + arima.sim(model = list(ar = 0.98), n = tsn))
#  x3 <- as.numeric(tsn + arima.sim(model = list(ar = 0.97), n = tsn))
#  x4 <- as.numeric(tsn + arima.sim(model = list(ar = 0.96), n = tsn))
#  y <- as.numeric(1.2 * x1 + x2 +  x3 +  x4 +  rnorm(tsn))
#  y <- as.numeric(1.2 * x1 + rnorm(tsn))
#  

## ----eval=FALSE---------------------------------------------------------------
#  y[(365*9):(365*10)] <- y[(365*9):(365*10)] + 5
#  Dates <- seq.Date(as.Date("2014-01-01"), by = 1, length.out = tsn)
#  data <-cbind.data.frame(Dates,y, x1,x2,x3,x4)
#  setDT(data)
#  data[Dates%between%c("2014-01-01", "2022-12-28"),treatment:=0]
#  data[Dates%between%c("2022-12-29", "2023-12-29"),treatment:=1]

## ----eval=FALSE---------------------------------------------------------------
#  plot.ts(data)

## ----eval=FALSE---------------------------------------------------------------
#  
#   trainModel<-syntCFtrain(frm = y~x1+x2+x3+x4,
#                          data=data,
#                          p.var=data$treatment,
#                          Dates=data$Dates,
#                          p.start="2022-12-29",
#                          p.end="2023-12-29",
#                          testingPeriod=365,
#                          tuneLength=3)
#  
#  
#  #Time ellapsed
#  trainModel$Model$times$everything

## ---- eval=FALSE--------------------------------------------------------------
#   modelEval<-syntCFmetrics(trainModel,quantiles=c(0.1, 0.9))
#   modelEval$trainr$trainMetrics
#   modelEval$testr$testMetrics
#   modelEval$quants$intervalMetrics
#  

## ---- eval=FALSE--------------------------------------------------------------
#  
#  estEffect<-syntCFest(modelEval)
#  
#  estEffect$Estimates
#  

## ---- eval=FALSE--------------------------------------------------------------
#  #plot
#  syntCFplot(estEffect)

