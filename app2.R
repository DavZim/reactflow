library(shiny)
library(reactflow)

ui <- fluidPage(
  sidebarPanel(
    selectInput("dagre_direction", "Layout", c("TB", "LR"), selected = "LR"),
    h4("Selected Values"),
    verbatimTextOutput("selected_el")
  ),
  mainPanel(
    reactflowOutput("widgetOutput", height = "100vh")
  )
)

pos <- list(x = 0, y = 0)
nodes <- list(
  list(id = "1", type = "input", data = list(label = "input"), position = pos),
  list(id = "2", data = list(label = "node 2"), position = pos),
  list(id = "2a", data = list(label = "node 2a"), position = pos),
  list(id = "2b", data = list(label = "node 2b"), position = pos),
  list(id = "2c", data = list(label = "node 2c"), position = pos),
  list(id = "2d", data = list(label = "node 2d"), position = pos),
  list(id = "3", data = list(label = "node 3"), position = pos),
  list(id = "4", data = list(label = "node 4"), position = pos),
  list(id = "5", data = list(label = "node 5"), position = pos),
  list(id = "6", type = "output", data = list(label = "output"), position = pos),
  list(id = "7", type = "output", data = list(label = "output"), position = pos)
)
edge_type <- "smoothstep"
edges <- list(
  list(id = "e12", source = "1", target = "2", type = edge_type, animated = TRUE),
  list(id = "e13", source = "1", target = "3", type = edge_type, animated = TRUE),
  list(id = "e22a", source = "2", target = "2a", type = edge_type, animated = TRUE),
  list(id = "e22b", source = "2", target = "2b", type = edge_type, animated = TRUE),
  list(id = "e22c", source = "2", target = "2c", type = edge_type, animated = TRUE),
  list(id = "e2c2d", source = "2c", target = "2d", type = edge_type, animated = TRUE),
  list(id = "e45", source = "4", target = "5", type = edge_type, animated = TRUE),
  list(id = "e56", source = "5", target = "6", type = edge_type, animated = TRUE),
  list(id = "e57", source = "5", target = "7", type = edge_type, animated = TRUE)
)

server <- function(input, output, session) {
  output$selected_el <- renderPrint(str(input$widgetOutput_click))
  
  output$widgetOutput <- renderReactflow({
    print(paste("rerender", input$dagre_direction))
    
    reactflow(
      nodes = nodes,
      edges = edges,
      
      use_dagre = TRUE, dagre_direction = input$dagre_direction,
      fitView = TRUE,
      snapToGrid = c(20, 20),
      allow_edge_connection = FALSE, # disable edge creation
      nodesDraggable = TRUE # default value, can be set to FALSE to disable dragging
    )
  })
}

shinyApp(ui, server)
