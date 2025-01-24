#' @importFrom htmlwidgets JS
#' @export
htmlwidgets::JS

#' A ReactFlow object
#'
#' @param nodes a
#' @param edges 
#' @param controls 
#' @param mini_map 
#' @param background 
#' @param allow_edge_connection 
#' @param use_dagre 
#' @param dagre_direction 
#' @param dagre_config 
#' @param ... elements passed to ReactFlow (see <https://reactflow.dev/api-reference/react-flow>)
#' @param width 
#' @param height a
#' @param elementId a
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
    package = "reactflow",
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "auto",
      defaultHeight = "auto"
    )
  )
  
  children <- list(controls, background, mini_map)
  children <- children[!sapply(children, is.null)]
  
  if (length(children) > 0) hw$x$tag$children <- children
  hw
}


#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.reactflow <- function(id, style, class, ...) {
  htmltools::tags$div(
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
reactflowOutput <- function(outputId, width = "100%", height = "400px"){
  htmlwidgets::shinyWidgetOutput(outputId, "reactflow", width, height, package = "reactflow")
}

#' @rdname reactflow-shiny
#' @export
renderReactflow <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, reactflowOutput, env, quoted = TRUE)
}
