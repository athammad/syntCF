#' Estimate the effect of the policy or program using DID
#'
#' Estimate the effect of the treatment using difference-in-difference (DID) to account for any systematic error in the trained model.
#' The testing period is used in combination
#'
#' @param SCFobj Object of class syntCFmetrics.
#' @param use.weights Logical. if TRUE use the quantile interval prediction ratio as weigths in the final regression model.
#' @param ... Other arguments to be passed to the jtools and lm().
#' @return Printed output for the final regression model.
#' @examples
#'
#' \dontrun{
#' estEffect<-syntCFest(modelEval)
#' estEffect$Estimates
#'}
#' @export
#' @import data.table
#' @import caret
#' @import ranger
#' @import jtools
#' @importFrom stats lm predict time
#' @importFrom utils askYesNo head tail

syntCFest<-function(SCFobj,use.weights=F,...){

  if(class(SCFobj)[1]=="syntCFmetrics"){

    #prepare the objects
    outcome<-as.character(SCFobj$aux$theModel$terms[[2]])
    controls<-SCFobj$aux$theModel$finalModel$xNames

    #Results and actuals on the test
    testRes<-SCFobj$testr$testRes
    testActual<-SCFobj$aux$theTesting[[outcome]]

    #Results and actuals during the P
    pRes<-predict(SCFobj$aux$theModel,SCFobj$aux$thePset[ , ..controls])
    pActual<-SCFobj$aux$thePset[[outcome]]

    PredsQCF<- predict(SCFobj$aux$theModel$finalModel,SCFobj$aux$thePset[ , ..controls],
                     type = "quantiles", quantiles =SCFobj$aux$callfunc)$predictions

    #create dataframe for lm with actual, CF,Delta and the predicted quantiles
    estDF<-cbind.data.frame("time"=c(SCFobj$aux$theTesting$Dates,SCFobj$aux$thePset$Dates),
      "actual"=c(testActual,pActual),"CF"=c(testRes,pRes))
    estDF$treat<-as.factor(c(rep(0,length(testActual)),rep(1,length(pActual))))
    data.table::setDT(estDF)
    estDF[,Delta:=actual-CF] #delta(observed-counterfactual)

    allQres<-rbind(SCFobj$quants$QuantieRes,PredsQCF)
    colnames(allQres)<-c("ql","qu")
    estDF<-cbind(estDF,allQres)

    if(use.weights){
      #weights based on Quantiles
      estDF[,qw:=qu -ql]
      estDF[,interval_pred_ratio:=qw /CF]

      Estimates<-jtools::summ(lm(Delta~treat,weights =interval_pred_ratio,data=estDF),robust=T,digits=3,confint=T,...)

      EstRes<-list(Estimates=Estimates,estDF=estDF)
      names(EstRes)<-c("Estimates","estDF")
      class(EstRes) <- c('syntCFest',class(EstRes))

      return(EstRes)

    }else{
      Estimates<-jtools::summ(lm(Delta~treat,data=estDF),robust=T,digits=3,confint=T,...)

      EstRes<-list(Estimates=Estimates,estDF=estDF)
      names(EstRes)<-c("Estimates","estDF")
      class(EstRes) <- c('syntCFest',class(EstRes))

      return(EstRes)


    }

  }else{
    cat(Cerror(paste("\n","------------------------------------------------------")))
    cat(Cerror(paste("\n","Error: The object must be of class `syntCFmetrics`...")))
    cat(Cerror(paste("\n","------------------------------------------------------","\n\n")))

  }
  }

