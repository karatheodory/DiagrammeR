#' Combine multiple edge data frames into a single
#' edge data frame
#' @description Combine several edge data frames in
#' the style of \code{rbind}, except, it works
#' regardless of the number and ordering of the
#' columns.
#' @param ... two or more edge data frames, which
#' contain edge IDs and associated attributes.
#' @return a combined edge data frame.
#' @examples
#' # Create an edge data frame
#' edges_1 <-
#'   create_edges(
#'     from = c(1, 1, 2, 3),
#'     to = c(2, 4, 4, 1),
#'     rel = "requires",
#'     color = "green",
#'     data = c(2.7, 8.9, 2.6, 0.6))
#'
#' # Create a second edge data frame
#' edges_2 <-
#'   create_edges(
#'     from = c(5, 7, 8, 8),
#'     to = c(7, 8, 6, 5),
#'     rel = "receives",
#'     arrowhead = "dot",
#'     color = "red")
#'
#' # Combine the two edge data frames
#' all_edges <-
#'   combine_edges(edges_1, edges_2)
#'
#' # View the combined edge data frame
#' all_edges
#' #>   from to      rel color data arrowhead
#' #> 1    1  2 requires green  2.7
#' #> 2    1  4 requires green  8.9
#' #> 3    2  4 requires green  2.6
#' #> 4    3  1 requires green  0.6
#' #> 5    5  7 receives   red            dot
#' #> 6    7  8 receives   red            dot
#' #> 7    8  6 receives   red            dot
#' #> 8    8  5 receives   red            dot
#' @export combine_edges

combine_edges <- function(...) {

  data_frames <- list(...)

  for (l in 1:length(data_frames)) {
    if (l == 1) {
      df1 <- data_frames[l][[1]]
      df2 <- data_frames[l + 1][[1]]
    }
    if (l > 1 & l < length(data_frames)) {
      df1 <- df_new
      df2 <- data_frames[l + 1][[1]]
    }
    if (l == length(data_frames)) {
      break
    }

    # Examine the column names for each data frame
    # and determine which columns are not common to
    # each df
    if (any(!(colnames(df2) %in% colnames(df1)))) {
      df_1_missing <-
        colnames(df2)[which(!(colnames(df2) %in%
                                colnames(df1)))]
    } else {
      df_1_missing <- NA
    }

    if (any(!(colnames(df1) %in% colnames(df2)))) {
      df_2_missing <-
        colnames(df1)[which(!(colnames(df1) %in%
                                colnames(df2)))]
    } else {
      df_2_missing <- NA
    }

    # Determine the new column names for the appended
    # data frames
    if (any(!is.na(df_1_missing))) {
      new_column_names_df1 <-
        c(colnames(df1), df_1_missing)
    } else {
      new_column_names_df1 <- NA
    }

    if (any(!is.na(df_2_missing))) {
      new_column_names_df2 <-
        c(colnames(df2), df_2_missing)
    } else {
      new_column_names_df2 <- NA
    }

    # Add missing columns to `df1`, with no values
    if (any(!is.na(df_1_missing))) {
      for (i in 1:length(df_1_missing)) {
        df1 <-
          cbind(df1, df_1_missing = rep("", nrow(df1)))

        if (i == length(df_1_missing)) {
          colnames(df1) <- new_column_names_df1
        }
      }
    }

    # Add missing columns to `df2`, with no values
    if (any(!is.na(df_2_missing))) {
      for (i in 1:length(df_2_missing)) {
        df2 <-
          cbind(df2, df_2_missing = rep("", nrow(df2)))

        if (i == length(df_2_missing)) {
          colnames(df2) <- new_column_names_df2
        }
      }
    }

    # Create a new data frame with combined rows
    for (i in 1:length(colnames(df1))) {
      if (i == 1) df_new <-
          data.frame(
            mat.or.vec(nr = nrow(df1) + nrow(df2),
                       nc = 0),
            stringsAsFactors = FALSE)

      df_col <-
        c(as.character(df1[,colnames(df1)[i]]),
          as.character(df2[,colnames(df1)[i]]))

      df_new <- cbind(df_new, df_col)
      colnames(df_new)[i] <- colnames(df1)[i]

      if (i == length(colnames(df1))) {
        for (j in 1:ncol(df_new)) {
          df_new[,j] <- as.character(df_new[,j])
        }
      }
    }
  }

  return(df_new)
}
