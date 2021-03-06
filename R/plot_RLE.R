#' RLE plot
#' @param exprsMatrix a matrix
#' @author Kevin Wang
#' @import ggplot2
#' @importFrom rlang .data
#' @importFrom stats median quantile
#' @export
#' @examples
#' n = 30
#' p = 1000
#' exprsMatrix = cbind(
#' matrix(rnorm((n - 3)*p), nrow = p),
#' matrix(rnorm(3*p, mean = 5), nrow = p)
#' )
#' boxplot(exprsMatrix)
#' plot_RLE(exprsMatrix)
plot_RLE = function(exprsMatrix){

  if(is.null(colnames(exprsMatrix))){
    colnames(exprsMatrix) = paste0("sample_", 1:ncol(exprsMatrix))
  }

  sampleMedian = apply(exprsMatrix, 2, median)
  sampleQ1 = apply(exprsMatrix, 2, quantile, 0.25)
  sampleQ3 = apply(exprsMatrix, 2, quantile, 0.75)

  rlePlotdf = tibble::tibble(
    sampleID = colnames(exprsMatrix) %>% forcats::as_factor(),
    sampleMedian = sampleMedian,
    sampleQ1 = sampleQ1,
    sampleQ3 = sampleQ3
  )


  rlePlot = rlePlotdf %>%
    ggplot2::ggplot(aes(x = .data$sampleID,
                        y = .data$sampleMedian,
                        label = .data$sampleID)) +
    geom_point() +
    geom_errorbar(aes(ymin = .data$sampleQ1, ymax = .data$sampleQ3), width = 0) +
    geom_hline(yintercept = 0, colour = "red") +
    theme_classic(18) +
    theme(legend.position = "bottom",
          axis.text.x = element_text(angle = 90))


  result = list(
    rlePlotdf = rlePlotdf,
    rlePlot = rlePlot
  )
  return(result)
}
