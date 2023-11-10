# Test for the color used and the GeomBar layer
example1 <- plot_missing_values_proportions(df=airquality, point_color = 'darkgreen',
                                            line_color = 'darkgreen')

test_that("example1", {
  expect_true(all(ggplot2::ggplot_build(example1)$data[[2]]$colour == "darkgreen"))
  expect_true("GeomBar" %in% class(example1$layers[[1]]$geom))
})

# Test for the identity of y used in aes() in two layers
example2 <- plot_missing_values_proportions(df=airquality,
                                            vars = c(Ozone, Wind, Temp))

test_that("Example2", {
  expect_equal(as.character(rlang::get_expr(example2$layers[[1]]$mapping$y)),
               as.character(rlang::get_expr(example2$layers[[2]]$mapping$y)))
})

# Test for change of the ylab
example3 <- plot_missing_values_proportions(df=airquality, ylab = "Columns")
test_that("Example3:ylab", {
  expect_true(example3$labels$x == "Columns")

})

# Test for returning error message when the input for df is not a dataframe
test_that("Non data frame input", {
  expect_error(plot_missing_values_proportions(df=c(4,3,5)), "I am so sorry, but this function only works for data frame input!
You have provided an object of class: numeric")
})

#clean up
rm('example1')
rm('example2')
rm('example3')

