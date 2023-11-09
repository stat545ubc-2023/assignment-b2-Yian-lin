plot_missing_values_proportions <- function(df, vars=everything(),
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
    summarize(across({{vars}}, ~ sum(is.na(.x))))

  # Prepare data for the plot: Pivot count_missing from wide to long
  count_missing <- count_missing %>%
    pivot_longer(cols = everything(),
                 names_to = "Variable",
                 values_to = "missing_count")

  # Plot it
  ggplot(data = count_missing,
         aes(x = stats::reorder(Variable, missing_count))) +
    geom_bar(aes(y = missing_count/nrow(df)),
             stat = "identity",
             position = "dodge",
             width = 0.001,
             colour = line_color,
             fill = line_color) +
    geom_point(aes(y = missing_count/nrow(df)),
               colour = point_color,
               fill = point_color) +
    ylim(0, 1) +
    coord_flip() +
    labs(y = xlab,x = ylab)
}
