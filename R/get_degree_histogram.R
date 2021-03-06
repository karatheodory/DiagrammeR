#' Get histogram data for a graph's degree frequency
#' @description Get histogram data for a graph's
#' degree frequency. The bin width is set to 1 and
#' zero-value degrees are omitted from the output.
#' @param graph a graph object of class
#' \code{dgr_graph} that is created using
#' \code{create_graph}.
#' @return a named vector of degree counts (with
#' bin width equal to 1) where the degree values
#' serve as names.
#' @examples
#' # Create a random, directed graph with 18 nodes
#' # and 22 edges
#' random_graph <-
#'   create_random_graph(
#'     n = 18,
#'     m = 22,
#'     directed = TRUE,
#'     fully_connected = TRUE,
#'     set_seed = 20)
#'
#' # Get degree histogram data for `random_graph`
#' random_graph %>% get_degree_histogram
#' #> 0 1 2 3 4 5
#' #> 1 3 7 2 4 1
#' @importFrom igraph degree_distribution
#' @export get_degree_histogram

get_degree_histogram <- function(graph) {

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  # Get the degree distribution for the graph
  # and multiply by the total number of nodes to
  # resolve counts of nodes by degree
  deg_hist <-
    degree_distribution(ig_graph) *
    node_count(graph)

  # Transform to a named vector where the names are
  # the number of degrees
  names(deg_hist) <- seq(0, length(deg_hist) - 1)

  return(deg_hist)
}
