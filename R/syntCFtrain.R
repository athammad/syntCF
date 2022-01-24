#' Train Quantile Random Forests with Time Series Data using Caret and TimeSlice
#'
#' Main function of the library syntCF. A convinient wrapper around `caret` with a custom model based on `rangerts` to take time dependency of the data into account trough block bootstrapping.
#' Cross-Validation is based on data partitioning using a fixed or growing window. To account to uncertainty in the predicted counterfactual time series, the library uses quantile regression forests.
#' @param frm The formula, e.g. (y~x1+x2).
#' @param data The full dataset.
#' @param models Model passed to Caret. By default RangerTS.
#' @param p.var vector of zeros and ones indicating the policy.
#' @param Dates vector of dates for the whole dataset.
#' @param p.start A vector specifying the first time point or date of the policy.
#' @param p.end A vector specifying the last time point or date of the policy.
#' @param testingPeriod Length of testing period. By default is 365.
#' @param tuneLength An integer denoting the amount of granularity in the tuning parameter grid. See caret::train() for more details.
#' @param windowsCV The initial number of consecutive values in each training set sample. See caret::createTimeSlices() for more details.
#' @param seedVal Seed value for reproducibility.
#' @param fixedWindow logical, if FALSE, all training samples start at 1.
#' @param skip integer, how many (if any) resamples to skip to thin the total amount
#' @param verboseIter A logical for printing a training log.
#' @param allowParallel if a parallel backend is loaded and available, should the function use it?
#' @param ... Other arguments to be passed to caret.
#' @return an object of class syntCF
#' @examples
#' \dontrun{
#' set.seed(1)
#' tsn=365*10
#' x1 <- as.numeric(tsn + arima.sim(model = list(ar = 0.999), n = tsn))
#' y <- as.numeric(1.2 * x1 + rnorm(tsn))
#' #add effect of + 30 during what we will define as the tretament period
#' y[(365*9):(365*10)] <- y[(365*9):(365*10)] + 30
#' Dates <- seq.Date(as.Date("2014-01-01"), by = 1, length.out = tsn)
#' data <-cbind.data.frame(Dates,y, x1)
#' setDT(data)
#' data[Dates%between%c("2014-01-01", "2022-12-28"),treatment:=0]
#' data[Dates%between%c("2022-12-29", "2023-12-29"),treatment:=1]
#'

#' trainModel<-syntCFtrain(frm = y~x1,
#'                        data=data,
#'                        p.var=data$treatment,
#'                        Dates=data$Dates,
#'                        p.start="2022-12-29",
#'                        p.end="2023-12-29",
#'                        testingPeriod=365,
#'                        tuneLength=1,
#'                        windowsCV=NULL)
#'}
#' @export
#' @import data.table
#' @import caret
#' @importFrom stats lm predict time
#' @importFrom utils askYesNo head tail


syntCFtrain<-function(frm,#Y~.
                      data=NULL,#data
                      models=rangerTS,
                      p.var=NULL,#data$treatment,
                      Dates=NULL,#data$Dates,
                      p.start=NULL,#"2022-12-29",
                      p.end=NULL,#"2023-12-29",
                      testingPeriod=NULL,#365,
                      tuneLength=NULL,#tuneLength,
                      windowsCV=NULL,
                      seedVal=123,
                      fixedWindow=FALSE,
                      skip = 0,
                      verboseIter=TRUE,
                      allowParallel=TRUE,
                      ...){

  if(is.null(p.var)) stop("syntCF requires a vector of zeros and ones indicating the policy")
  if(is.null(Dates)) stop("syntCF requires a vector of dates")
  if(is.null(p.start)) stop("syntCF requires specifying the first time point or date of the policy in the format yyyy-mm-dd ")
  if(is.null(p.end)) stop("syntCF requires specifying the last time point or date of the policy in the format yyyy-mm-dd ")



callfunc<-list(p.var,Dates,p.start,p.end)

set.seed(seedVal)

#Define the dataSets
setDT(data)
trainSet<-head(data[Dates<p.start,],-testingPeriod)
testSet<-tail(data[Dates<p.start,],testingPeriod)
pSet<-data[Dates%between%c(p.start,p.end),]


if(is.null(windowsCV)){
  windowsCV=(length(unique(lubridate::year(trainSet[,Dates])))-2)*testingPeriod}


cat(Cnote(paste("======================================================","\n")))
cat(Cnote(paste("-N rows trainSet:",nrow(trainSet),"\n-windowsCV:",windowsCV,"\n-testingPeriod:",testingPeriod)))
cat(Cnote(paste("\n","======================================================","\n")))
ready<-askYesNo("do you want to continue with this settings?")


if(ready==T & !is.na(ready)){
  cat(Cnote(paste("\n","======================================================")))
  cat(CBwarn(paste("\n","Starting your Training...")))
  cat(Cnote(paste("\n","======================================================","\n\n")))

}else{
  cat(Cnote(paste("\n","------------------------------------------------------")))
  cat(CBwarn(paste("\n","Please redefine your settings and run this function again...")))
  cat(Cnote(paste("\n","------------------------------------------------------","\n\n")))

  opt <- options(show.error.messages=FALSE)
  on.exit(options(opt))
  stop()}




train_control <- caret::trainControl(method = "timeslice",
                              initialWindow=windowsCV,
                              horizon = testingPeriod,
                              fixedWindow = fixedWindow,
                              skip = skip,
                              verboseIter=verboseIter,
                              allowParallel=allowParallel,
                              savePredictions="final",
                              search = "random",...)



qlModel<-caret::train(frm,trainSet,
                   trControl = train_control,
                   tuneLength = tuneLength,
                   method =  rangerTS,
                   quantreg=TRUE, ...)


cat(Cnote(paste("\n","============================================================","\n",
                "Training done!..","\n", "Use the function `syntCFmetrics()` to check the results",
                "\n","============================================================","\n\n")))



syntCFRes<-list(Model=qlModel,trainSet=trainSet,testSet=testSet,pSet=pSet,callfunc=callfunc)

class(syntCFRes) <- c('syntCF',class(syntCFRes))
return(syntCFRes)
}

