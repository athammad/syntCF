#' Compute evaluation metrics to measure regression performance.
#'
#' RMSE,MAPE and R2, are accompanied with additional metrics specifically designed to evaluate the goodness of the prediction intervals including
#' interval score,sharpness, underprediction, overprediction.
#' @param SCFobj Object of class syntCF.
#' @param quantiles Vector of quantiles for quantile prediction.
#' @param ... Other arguments to be passed to predict.
#' @return an object of class syntCF with the values for RMSPE, MAPE,R2 and the train and test set and vector of scoring rules metrics.
#' @examples
#'
#' \dontrun{
#' modelEval<-syntCFmetrics(trainModel,quantiles=c(0.1, 0.9))
#' modelEval$trainr$trainMetrics
#' modelEval$testr$testMetrics
#' modelEval$quants$intervalMetrics
#' }
#'
#' @export
#' @import data.table
#' @import caret
#' @import MLmetrics
#' @import scoringutils
#' @importFrom stats lm predict time
#' @importFrom utils askYesNo head tail


syntCFmetrics<-function(SCFobj,quantiles=c(0.1, 0.9),...){


  if(is.null(quantiles)) stop("syntCF requires a vector of quantiles for quantile prediction such as c(0.1, 0.9)")

  if(class(SCFobj)[1]=="syntCF"){

  outcome<-as.character(SCFobj$Model$terms[[2]])
  controls<-SCFobj$Model$finalModel$xNames
  #==========#ALL RESULTS ON TRAINING & TESTING
    #train
    trainr<-list(
      trainRes<-predict(SCFobj$Model,SCFobj$trainSet[ , ..controls]),
      trainMetrics<-cbind.data.frame(r2=caret::R2(trainRes,SCFobj$trainSet[[outcome]]),
      rmspe=MLmetrics::RMSPE(trainRes ,SCFobj$trainSet[[outcome]]),
      mape=MLmetrics::MAPE(trainRes ,SCFobj$trainSet[[outcome]])))

    names(trainr)<-c("trainRes","trainMetrics")
    #Test
    testr<-list(
      testRes<-predict(SCFobj$Model,SCFobj$testSet[ , ..controls]),
      testMetrics<-cbind.data.frame(r2=caret::R2(testRes,SCFobj$testSet[[outcome]]),
      rmspe=MLmetrics::RMSPE(testRes ,SCFobj$testSet[[outcome]]),
      mape=MLmetrics::MAPE(testRes ,SCFobj$testSet[[outcome]])))

    names(testr)<-c("testRes","testMetrics")
    #Quantiles
    quants<-list(
      PredsQ<- predict(SCFobj$Model$finalModel,SCFobj$testSet[ , ..controls],
                       type = "quantiles", quantiles =quantiles)$predictions,


      intervalMetrics<-colMeans(data.table::as.data.table(scoringutils::interval_score(
        true_values=SCFobj$testSet[[outcome]],
        lower=PredsQ[,1],
        upper=PredsQ[,2],
        interval_range=quantiles[2]-quantiles[1],
        weigh = TRUE,
        separate_results = T)))

      )

    names(quants)<-c("QuantieRes","intervalMetrics")




    aux<-list(
      theModel=SCFobj$Model,
      theTraining=SCFobj$trainSet,
      theTesting=SCFobj$testSet,
      thePset=SCFobj$pSet,
      callfunc=quantiles
    )
    #----------------------------------#
    syntCFmetrics<-list(trainr,testr,quants,aux)
    names(syntCFmetrics)<-c("trainr","testr","quants","aux")

    class(syntCFmetrics) <- c('syntCFmetrics',class(syntCFmetrics))
    return(syntCFmetrics)

    return(syntCFmetrics)

  }else{
    cat(Cerror(paste("\n","------------------------------------------------------")))
    cat(Cerror(paste("\n","Error: The object must be of class `syntCF`...")))
    cat(Cerror(paste("\n","------------------------------------------------------","\n\n")))

  }

}

