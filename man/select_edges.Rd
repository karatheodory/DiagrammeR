% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select_edges.R
\name{select_edges}
\alias{select_edges}
\title{Select edges in a graph}
\usage{
select_edges(graph, edge_attr = NULL, search = NULL, set_op = "union",
  from = NULL, to = NULL)
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph} that is created using
\code{create_graph}.}

\item{edge_attr}{an optional character vector of
edge attribute values for filtering the edges
returned.}

\item{search}{an option to provide a logical
expression with a comparison operator (\code{>},
\code{<}, \code{==}, or \code{!=}) followed by a
number for numerical filtering, or, a regular
expression for filtering the nodes returned through
string matching.}

\item{set_op}{the set operation to perform upon
consecutive selections of graph nodes. This can
either be as a \code{union} (the default), as an
intersection of selections with \code{intersect},
or, as a \code{difference} on the previous
selection, if it exists.}

\item{from}{an optional vector of node IDs from
which the edge is outgoing for filtering the list of
edges present in the graph.}

\item{to}{an optional vector of node IDs to which
the edge is incoming for filtering the list of
edges present in the graph.}
}
\value{
a graph object of class \code{dgr_graph}.
}
\description{
Select edges from a graph object of
class \code{dgr_graph}.
}
\examples{
# Create a node data frame (ndf)
nodes <-
  create_nodes(
    nodes = 1:4,
    type = "basic",
    label = TRUE,
    value = c(3.5, 2.6, 9.4, 2.7))

# Create an edge data frame (edf)
edges <-
  create_edges(
    from = c(1, 2, 3),
    to = c(4, 3, 1),
    rel = c("a", "z", "a"),
    value = c(6.4, 2.9, 5.0))

# Create a graph with the ndf and edf
graph <-
  create_graph(
    nodes_df = nodes,
    edges_df = edges)

# Explicitly select the edge `1` -> `4`
graph <-
  graph \%>\%
  select_edges(from = 1, to = 4)

# Verify that an edge selection has been made
# using the `get_selection()` function
get_selection(graph)
#> [1] "1 -> 4"

# Select edges based on the relationship label
# being `Z`
graph <-
  graph \%>\%
  clear_selection \%>\%
  select_edges(edge_attr = "rel", search = "z")

# Verify that an edge selection has been made, and
# recall that the `2` -> `3` edge uniquely has the
# `z` relationship label
get_selection(graph)
#> [1] "2 -> 3"

# Select edges based on the edge value attribute
# being greater than 3.0 (first clearing the current
# selection of edges)
graph <-
  graph \%>\%
  clear_selection \%>\%
  select_edges(edge_attr = "value", search = ">3.0")

# Verify that the correct edge selection has been
# made; in this case, edges `1` -> `4` and
# `3` -> `1` have values for `value` greater than
# 3.0
get_selection(graph)
#> [1] "1 -> 4" "3 -> 1"
}

