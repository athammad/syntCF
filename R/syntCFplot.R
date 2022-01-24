#' Printing and plotting a syntCFest object
#
#' Methods for printing and plotting the results of an analysis results object returned by syntCFest().
#' @param SCFobj Object of class syntCFest.
#' @param ... Other arguments to be passed to the ggplot2
#' @return returns a ggplot2 plot.
#' @examples
#'
#' \dontrun{
#' syntCFplot(estEffect)
#' }
#' @export
#' @import ggplot2
#' @import data.table


syntCFplot<-function(SCFobj,...){


  if(class(SCFobj)[1]=="syntCFest"){


    # p <- ggplot(SCFobj$estDF, aes(time))+
    #   geom_ribbon(aes(ymin=ql, ymax=qu),fill ="#AED6F1",show.legend = F)+
    #   #geom_line(aes(y=CF,color="#EC7063"),linetype = 2)+
    #   geom_point(aes(y=CF,color="#EC7063"))+
    #   geom_line(aes(y =actual,color="#EC7063"),linetype = 1)+
    #   theme_bw()+
    #   geom_vline(xintercept=as.numeric(as.Date(first(SCFobj$estDF[treat==1,time]))), linetype=4)+
    #   labs(color = '',y= "Outcome", x = "Time")+
    #   theme(legend.position="none", legend.box = "horizontal")

    options(bitmapType="cairo")
    p<-ggplot2::ggplot(SCFobj$estDF, aes(time))+
      ggplot2::geom_ribbon(aes(ymin=ql, ymax=qu),fill ="#3C8352",alpha=0.2,show.legend = F)+
      ggplot2::geom_point(aes(y=CF),color="black")+
      ggplot2::geom_line(aes(y =actual),color="#1269F3")+
      ggplot2::geom_vline(xintercept=as.numeric(as.Date(data.table::first(SCFobj$estDF[treat==1,time]))), linetype=4)+
      ggplot2::theme_bw() +
      ggplot2::labs(color = '',y= "Outcome", x = "Time")+
      ggplot2::theme(legend.position="none", legend.box = "horizontal")





    p

    return(p)

  }else{
    cat(Cerror(paste("\n","------------------------------------------------------")))
    cat(Cerror(paste("\n","Error: The object must be of class `syntCFest`...")))
    cat(Cerror(paste("\n","------------------------------------------------------","\n\n")))

    }
}


