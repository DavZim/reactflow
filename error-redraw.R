library(shiny)
library(bslib)
library(reactflow)


css <- "
.react-flow__node {
  background-color: lightblue;
  border-width: 0;
  filter: drop-shadow(0 0 2px lightgray) drop-shadow(0 0 5px lightgray);

}
.startNode {
  background-color: lightgreen;
}
.endNode {
  background-color: coral;
}
"
ui <- page_fillable(
  
  layout_column_wrap(
    width = 1 / 2,
    card(
      tags$head(tags$style(HTML(css))),
      actionButton("add", "Add random node"),
      h4("Selected Values"),
      verbatimTextOutput("selected_el")
    ),
    card(
      reactflowOutput("widgetOutput", height = "100%")
    )
  )
)


pos <- list(x = 0, y = 0)
nodes <- list(
  list(id = "1", type = "input", data = list(label = "k78 Breast Cancer"),
       className = "startNode"),
  
  list(id = "relapse", data = list(label = "Relapse")),
  list(id = "E1", data = list(label = "Assessment"), className = "endNode")
  
) |> 
  lapply(\(x) {
    x$position <- pos
    if ("className" %in% names(x) && x$className == "endNode") x$type <- "output"
    x
  })
edge_type <- "smoothstep"
edges <- list(
  list(source = "1", target = "relapse"),
  list(source = "relapse", target = "E1")
  
) |> lapply(\(x) {
  x$id <- paste0(x$source, x$target)
  x$type <- edge_type
  x$animated <- TRUE
  x
})

server <- function(input, output, session) {
  output$selected_el <- renderPrint(str(input$widgetOutput_click))
  
  graph <- reactiveValues(edges = edges, nodes = nodes)
  
  
  observeEvent(input$add, {
    print("Click")
    new_node <- list(
      id = paste0(sample(letters, 5, replace = TRUE), collapse = ""),
      data = list(label = paste0("Node ", input$add))
    )
    
    new_edge <- list(
      source = "1",
      target = new_node$id
    )
    
    graph$nodes <- append(graph$nodes, list(new_node))
    graph$edges <- append(graph$edges, list(new_edge))
  })
  
  
  output$widgetOutput <- renderReactflow({
    print("Redraw plot")
    reactflow(
      nodes = graph$nodes,
      edges = graph$edges,
      
      elementId = "widgetOutput",
      
      use_dagre = TRUE, dagre_direction = "TB", # TB, LR
      dagre_config = list(nodeWidth = 250, nodeHeight = 50),
      fitView = TRUE,
      snapToGrid = c(10, 10),
      allow_edge_connection = FALSE, # disable edge creation
      nodesDraggable = TRUE # default value, can be set to FALSE to disable dragging
    )
  })
}

shinyApp(ui, server)
