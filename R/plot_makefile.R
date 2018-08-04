#' Plot Makefile rules as a graph
#'
#' @param m A parsed Makefile, obtained from `parse_makefile`
#' @importFrom igraph graph_from_data_frame
#' @importFrom igraph plot.igraph
#' @export
plot_makefile <- function(m) {
  # Restrict to descendants of a given target?

  gr <- igraph::graph_from_data_frame(
    m[, c("target", "prerequisite")],
    vertices = unique(c(m$target, m$prerequisite)),
    directed = TRUE)

  igraph::plot.igraph(gr)
}
