#' Creates a Mini Map Component for a ReactFlow
#'
#' Note the mini map is not a standalone component, it is a child of ReactFlow
#' 
#' @param ... arguments passed to the component, see official source below
#'
#' @source <https://reactflow.dev/api-reference/components/minimap>
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
#' # basic mini map
#' reactflow(nodes, edges, mini_map())
#' 
#' # add pan and zoom function to mini map
#' reactflow(
#'   nodes,
#'   edges,
#'   mini_map(pannable = TRUE, zoomable = TRUE, nodeColor = "coral")
#' )
#' 
#' # provide a function for nodeColor
#' node_color <- JS("(node) => {
#'   if (node.type === 'input') return 'lightblue'
#'   if (node.id === '2') return 'lightgreen'
#'   return 'coral'
#' }")
#' reactflow(
#'   nodes,
#'   edges,
#'   mini_map(nodeColor = node_color)
#' )
#' 
#' # add nodeComponent to style the nodes in the minimap
#' node_component <- JS(reactR::babel_transform('
#'  ({ x, y }) => {
#'    return <circle cx={x} cy={y} r="25" fill="coral" />
#'  }
#' '))
#' reactflow(
#'   nodes,
#'   edges,
#'   mini_map(nodeComponent = node_component)
#' )
#' 
mini_map <- function(...) {
  reactR::React$MiniMap(...)
}
