#' Creates a Control Component for a ReactFlow
#'
#' Note control component is not a standalone component, it is a child of ReactFlow
#' 
#' @param ... arguments passed to the element, see official source below
#'
#' @source <https://reactflow.dev/api-reference/components/controls>
#' 
#' @export
#' @examples
#' nodes <- list(
#'   list(id = "1", position = list(x = 0, y = 0), data = list(label = "1"),
#'        type = "input"),
#'   list(id = "2", position = list(x = 50, y = 100), data = list(label = "2")),
#'   list(id = "3", position = list(x = 100, y = 200), data = list(label = "3"),
#'        type = "output")
#' )
#' edges <- list(
#'  list(id = "e1-2", source = "1", target = "2"),
#'  list(id = "e2-3", source = "2", target = "3"),
#'  list(id = "e1-3", source = "1", target = "3")
#' )
#' 
#' # basic control
#' reactflow(nodes, edges, controls())
#' 
#' # apply custom styling
#' reactflow(nodes, edges, controls(
#'   position = "top-right",
#'   orientation = "horizontal",
#'   # show values can be turned off, on by default
#'   showZoom = TRUE,
#'   showFitView = FALSE,
#'   showIntereactive = TRUE
#' ))
controls <- function(...) {
  reactR::React$Controls(...)
}