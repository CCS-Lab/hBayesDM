#' Function to plot multiple figures
#'
#' Plots multiple figures
#' Based on codes from 'http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/'
#' @param ... Plot objects
#' @param plots List containing plot objects
#' @param cols Number of columns within the multi-figure plot
#'
#' @importFrom grid grid.newpage grid.layout pushViewport viewport
#' @export

multiplot <- function(...,
                      plots = NULL,
                      cols  = NULL) {

  if (is.null(plots)) {
    plots <- list(...)
  }

  numPlots = length(plots)

  # Make the panel
  plotCols = cols                          # Number of columns of plots
  plotRows = ceiling(numPlots/plotCols) # Number of rows needed, calculated from # of cols

  # Set up the page
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(plotRows, plotCols)))
  vplayout <- function(x, y)
    grid::viewport(layout.pos.row = x, layout.pos.col = y)

  # Make each plot, in the correct location
  for (i in 1:numPlots) {
    curRow = ceiling(i/plotCols)
    curCol = (i - 1) %% plotCols + 1
    plots_print = print(plots[[i]], vp = vplayout(curRow, curCol))
  }
}

