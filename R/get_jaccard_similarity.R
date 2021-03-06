#' Get Jaccard similarity coefficient scores
#' @description Get the Jaccard similiarity coefficient
#' scores for one or more nodes in a graph.
#' @param graph a graph object of class
#' \code{dgr_graph}.
#' @param nodes an optional vector of node IDs to
#' consider for Jaccard similarity scores. If not
#' supplied, then similarity scores will be provided
#' for every pair of nodes in the graph.
#' @param direction using \code{all} (the default), the
#' function will ignore edge direction when
#' determining scores for neighboring nodes. With
#' \code{out} and \code{in}, edge direction for
#' neighboring nodes will be considered.
#' @param round_to the maximum number of decimal places
#' to retain for the Jaccard similarity coefficient
#' scores. The default value is \code{3}.
#' @return a matrix with Jaccard similiarity values
#' for each pair of nodes considered.
#' @examples
#' # Create a random graph
#' graph <-
#'   create_random_graph(
#'     10, 22, set_seed = 1)
#'
#' # Get the Jaccard similarity values for
#' # nodes `5`, `6`, and `7`
#' get_jaccard_similarity(graph, 5:7)
#' #>       5     6     7
#' #> 5 1.000 0.286 0.500
#' #> 6 0.286 1.000 0.286
#' #> 7 0.500 0.286 1.000
#' @importFrom igraph similarity V
#' @export get_jaccard_similarity

get_jaccard_similarity <- function(graph,
                                   nodes = NULL,
                                   direction = "all",
                                   round_to = 3) {

  # Convert the graph to an igraph object
  ig_graph <- to_igraph(graph)

  if (is.null(nodes)) {
    ig_nodes <- V(ig_graph)
  }

  if (!is.null(nodes)) {

    # Stop function if nodes provided not in
    # the graph
    if (!all(as.character(nodes) %in%
             get_node_ids(graph))) {
      stop("One or more nodes provided not in graph.")
    }

    # Get an igraph representation of node ID values
    ig_nodes <- V(ig_graph)[nodes]
  }

  # Get the Jaccard similarity scores
  if (direction == "all") {
    j_sim_values <-
      as.matrix(
        igraph::similarity(
          ig_graph,
          vids = ig_nodes,
          mode = "all",
          method = "jaccard"))
  }

  if (direction == "out") {
    j_sim_values <-
      as.matrix(
        igraph::similarity(
          ig_graph,
          vids = ig_nodes,
          mode = "out",
          method = "jaccard"))
  }

  if (direction == "in") {
    j_sim_values <-
      as.matrix(
        igraph::similarity(
          ig_graph,
          vids = ig_nodes,
          mode = "in",
          method = "jaccard"))
  }

  if (is.null(nodes)) {
    row.names(j_sim_values) <- graph$nodes_df$nodes
    colnames(j_sim_values) <- graph$nodes_df$nodes
  }

  if (!is.null(nodes)) {
    row.names(j_sim_values) <- graph$nodes_df$nodes[nodes]
    colnames(j_sim_values) <- graph$nodes_df$nodes[nodes]
  }

  # Round all values in matrix to set SD
  j_sim_values <- round(j_sim_values, round_to)

  return(j_sim_values)
}
