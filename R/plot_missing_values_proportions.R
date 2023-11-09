#' Visualization of missing values
#'
#' Makes a ggplot to visualize the proportion of missing values for all or selected columns in a data frame.
#' @param df a data frame.
#' @param vars a vector containing selected name(s) of variable(s) in `df`. These selected variables will be included in the plot. The default is to show the proportion of missing values for all variables in `df`.
#' @param point_color the color to be used for the points. The default is "blue".
#' @param line_color the color to be used for the lines. The default is "blue".
#' @param ylab the title of the y axis.
#' @param xlab the title of the x axis.
#'
#' @return a ggplot object visualizing the proportion of missing values for all or selected columns.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # Create the plot for all variables in airquality (a dataset in Base R)
#' plot_missing_values_proportions(df=airquality, point_color = 'darkgreen', line_color = 'darkgreen')
#'
#' # Create the plot for selected variables in airquality
#' plot_missing_values_proportions(df=airquality, vars = c(Ozone, Wind, Temp))
#'
#' # Change the title of the y axis.
#' plot_missing_values_proportions(df=airquality, ylab = "Columns")
plot_missing_values_proportions <- function(df, vars=tidyselect::everything(),
                                            point_color="blue", line_color="blue",
                                            ylab="Variables",
                                            xlab="Proportion of missing values"){

  # check if df is a dataframe
  if(!is.data.frame(df)) {
    stop('I am so sorry, but this function only works for data frame input!\n',
         'You have provided an object of class: ', class(df)[1])
  }

  # count the number of missing values in all (the default) or selected variables
  count_missing<- df %>%
    dplyr::summarize(dplyr::across({{vars}}, ~ sum(is.na(.x))))

  # Prepare data for the plot: Pivot count_missing from wide to long
  count_missing <- count_missing %>%
    tidyr::pivot_longer(cols = tidyselect::everything(),
                 names_to = "Variable",
                 values_to = "missing_count")

  # Plot it
  ggplot2::ggplot(data = count_missing,
                  ggplot2::aes(x = stats::reorder(Variable, missing_count))) +
    ggplot2::geom_bar(ggplot2::aes(y = missing_count/nrow(df)),
             stat = "identity",
             position = "dodge",
             width = 0.001,
             colour = line_color,
             fill = line_color) +
    ggplot2::geom_point(ggplot2::aes(y = missing_count/nrow(df)),
               colour = point_color,
               fill = point_color) +
    ggplot2::ylim(0, 1) +
    ggplot2::coord_flip() +
    ggplot2::labs(y = xlab,x = ylab)
}
