library(shiny)
library(reactflow)


# TODO test HTML in label!
# fíx webpack cutting function dependencies


# https://github.com/plotly/plotly.R/issues/985


css <- "
  /* special styling for selected nodes */
  .react-flow__node.selected {
    background-color: #FE5F55 !important;
    color: white !important;
  }
  /* custom class for an edge */
  .my-class > path {
    stroke: #256EFF;
    stroke-dasharray: 5, 5;
  }
  /* add glow effect for selected custom edge */
  .my-class.selected > path {
    stroke-opacity: 1;
    stroke-width: 1;
    filter: drop-shadow(0 0 2px #256EFF) drop-shadow(0 0 5px #256EFF);
  }
  /* nodes can be styled as well via general CSS rules */
  .my-node {
    background-color: #ffa000;
    color: white;
    border-width: 0;
    font-size: 1.5em;
    filter: drop-shadow(5px 5px 5px gray);
  }
  /* styling for the handle */
  .react-flow__handle {
    width: 10px;
    height: 10px;
    border-width: 0;
    background-color: #e91e63;
  }
"

ui <- fluidPage(
  sidebarPanel(
    tags$head(tags$style(HTML(css))),
    h4("Selected Values"),
    verbatimTextOutput("selected_el")
  ),
  mainPanel(
    reactflowOutput("widgetOutput", height = "100vh")
  )
)

nodes <- list(
  list(
    id = "1", position = list(x = 0, y = 0), width = 200, type = "input",
    data = list(label = "Default Node")
  ),
  list(
    id = "2", position = list(x = 100, y = 200),
    data = list(label = "Styled via Class"), className = "my-node"
  ),
  list(
    id = "3", position = list(x = 200, y = 400),
    data = list(label = "I have direct styles"),
    style = list("background-color" = "#2196f3",
                 color = "white",
                 "border-color" = "#0964AE",
                 "border-width" = "2px",
                 "font-size" = "1.5em",
                 filter = "drop-shadow(10px 10px 5px gray)")
  ),
  list(
    id = "4", position = list(x = 300, y = 600), type = "html",
    data = list(html = paste(
      "<div style='width: 150px;border: 1px solid lightgray;border-radius: 5px;",
      "display: flex;justify-content: center;background-color: coral;'>",
      "Hi <em>I</em> am <b>HTML</b></div>"))
  ),
  list(
    id = "5", position = list(x = 200, y = 700), type = "output",
    data = list(label = "Default Output Node")
  )
)

edges <- list(
  list(
    id = "e1-2", source = "1", target = "2", type = "straight",
    label = "default style"
  ),
  list(
    id = "e2-3", source = "2", target = "3", type = "smoothstep",
    label = "Animated Edge + smoothstep", animated = TRUE
  ),
  list(
    id = "e3-4", source = "3", target = "4", type = "bezier",
    style = list(stroke = "#FE5F55", "stroke-width" = 2, "stroke-dasharray" = "3, 3"),
    className = "my-class", label = "Click Me! (also styled + Bezier)"
  ),
  list(
    id = "e4-5", source = "4", target = "5", type = "step"
  )
)


server <- function(input, output, session) {
  output$selected_el <- renderPrint(str(input$widgetOutput_click))
  
  output$widgetOutput <- renderReactflow({
    reactflow(
      nodes = nodes,
      edges = edges,
      snapToGrid = c(20, 20),
      allow_edge_connection = FALSE, # disable edge creation
      nodesDraggable = TRUE # default value, can be set to FALSE to disable dragging
    )
  })
}

shinyApp(ui, server)
