#' Render the graph in various formats
#' @description Using a \code{dgr_graph} object,
#' render the graph in the RStudio Viewer.
#' @param graph a \code{dgr_graph} object, created
#' using the \code{create_graph} function.
#' @param output a string specifying the output type;
#' \code{graph} (the default) renders the graph using
#' the \code{grViz} function, \code{vivagraph}
#' renders the graph using the \code{vivagraph}
#' function, and \code{visNetwork} renders the graph
#' using the \code{visnetwork} function.
#' @param layout a string specifying a layout type for
#' a \code{vivagraph} rendering of the graph, either
#' \code{forceDirected} or \code{constant}.
#' @param title an optional title for a graph when
#' using \code{output = "graph"}.
#' @param width an optional parameter for specifying
#' the width of the resulting graphic in pixels.
#' @param height an optional parameter for specifying
#' the height of the resulting graphic in pixels.
#' @examples
#' \dontrun{
#' # Set a seed
#' set.seed(24)
#'
#' # Create a node data frame (ndf)
#' nodes <-
#'   create_nodes(
#'     nodes = 1:26,
#'     label = TRUE,
#'     type = "basic",
#'     shape = sample(c("circle", "square"),
#'                    length(1:26),
#'                    replace = TRUE),
#'     fillcolor = sample(c("aqua", "orange",
#'                          "pink", "lightgreen",
#'                          "black", "yellow"),
#'                        length(1:26),
#'                        replace = TRUE))
#'
#' # Create an edge data frame (edf)
#' edges <-
#'   create_edges(
#'     from = sample(1:26, replace = TRUE),
#'     to = sample(1:26, replace = TRUE),
#'     rel = "to_node")
#'
#' # Create a graph object using the ndf and edf, and,
#' # add a few attributes for the graph appearance
#' graph <-
#'   create_graph(
#'     nodes_df = nodes,
#'     edges_df = edges,
#'     graph_attrs = "layout = twopi",
#'     node_attrs = c("fontname = Helvetica",
#'                    "style = filled"),
#'     edge_attrs = c("color = gray20",
#'                    "arrowsize = 0.5"))
#'
#' # Render the graph using Graphviz
#' render_graph(graph)
#'
#' # Render the graph using VivaGraph
#' render_graph(graph, output = "vivagraph")
#'
#' # Render the graph using visNetwork
#' render_graph(graph, output = "visNetwork")
#' }
#' @export render_graph

render_graph <- function(graph,
                         output = NULL,
                         layout = NULL,
                         title = NULL,
                         width = NULL,
                         height = NULL) {

  stopifnot(inherits(graph, "dgr_graph"))

  if (is.null(output) & !is.null(graph$graph_attrs)) {
    if ("output = visNetwork" %in% graph$graph_attrs) {
      output <- "visNetwork"
    }
    if ("output = vivagraph" %in% graph$graph_attrs) {
      output <- "vivagraph"
    }
    if ("output = graph" %in% graph$graph_attrs) {
      output <- "graph"
    }
    if ("output = Graphviz" %in% graph$graph_attrs) {
      output <- "graph"
    }
  }

  if (is.null(output)) {
    output <- "graph"
  }

  if (output == "graph") {

    if (!is.null(title)) {

      graph <-
        set_global_graph_attrs(
          graph, "graph", "label", paste0("'", title, "'"))

      graph <-
        set_global_graph_attrs(
          graph, "graph", "labelloc", "t")

      graph <-
        set_global_graph_attrs(
          graph, "graph", "labeljust", "c")

      graph <-
        set_global_graph_attrs(
          graph, "graph", "fontname", "Helvetica")

      graph <-
        set_global_graph_attrs(
          graph, "graph", "fontcolor", "gray30")
      }

    dot_code <- generate_dot(graph)

    grViz(
      diagram = dot_code,
      engine = layout,
      width = width,
      height = height)

  } else if (output == "vivagraph") {

    layout <-
      ifelse(is.null(layout) &
               node_count(graph) < 1000,
             "forceDirected", "constant")

    vivagraph(
      graph = graph,
      layout = layout,
      height = NULL,
      width = NULL)

  } else if (output == "visNetwork") {

    visnetwork(graph)
  }
}
