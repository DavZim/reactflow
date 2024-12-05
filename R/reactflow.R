#' @importFrom htmlwidgets JS
#' @export
htmlwidgets::JS

#' A
#'
#' A
#' @param message a
#' @param width a
#' @param height a
#' @param elementId a
#' @param ... elements passed to ReactFlow (see https://reactflow.dev/api-reference/react-flow)
#'
#' @import htmlwidgets
#'
#' @export
reactflow <- function(nodes, edges, controls = NULL, mini_map = NULL,
                      background = NULL, allow_edge_connection = TRUE,
                      use_dagre = FALSE, dagre_direction = c("LR", "TB"), 
                      dagre_config = list(nodeWidth = 200, nodeHeight = 40),
                      ...,
                      width = NULL, height = NULL,
                      elementId = NULL) {

  dagre_direction <- match.arg(dagre_direction)
  
  # describe a React component to send to the browser for rendering.
  component <- reactR::component(
    "ReactFlow",
    list(nodes = nodes, edges = edges, elementId = elementId,
         allow_edge_connection = allow_edge_connection, 
         use_dagre = use_dagre, dagre_direction = dagre_direction,
         dagre_config = dagre_config, ...)
  )

  # create widget
  hw <- htmlwidgets::createWidget(
    name = "reactflow",
    reactR::reactMarkup(component),
    width = width,
    height = height,
    package = "reactflow"
  )

  children <- list(controls, background, mini_map)
  children <- children[!sapply(children, is.null)]
  
  if (length(children) > 0) hw$x$tag$children <- children
  hw
}

#' Creates a mini map for the ReactFlow component
#'
#' Note the mini map is not a standalone component, it is a child of ReactFlow
#' 
#' @param ... arguments passed to ReactFlow, see official source below
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

#' see also https://reactflow.dev/api-reference/components/controls
#' @export
controls <- function(...) {
  reactR::React$Controls(...)
}
#' see also https://reactflow.dev/api-reference/components/background
#' @export
background <- function(...) {
  reactR::React$Background(...)
}


#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.reactflow <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for reactflow
#'
#' Output and render functions for using reactflow within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a reactflow
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name reactflow-shiny
#'
#' @export
reactflowOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'reactflow', width, height, package = 'reactflow')
}

#' @rdname reactflow-shiny
#' @export
renderReactflow <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, reactflowOutput, env, quoted = TRUE)
}
