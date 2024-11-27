library(shiny)
library(reactflow)

ui <- fluidPage(
  titlePanel("reactR HTMLWidget Example"),
  reactflowOutput('widgetOutput')
)

server <- function(input, output, session) {
  output$widgetOutput <- renderReactflow({
    nodes <- list(
      list(id = "1", position = list(x = 0, y = 0), data = list(label = "1")),
      list(id = "2", position = list(x = 0, y = 100), data = list(label = "2"))
    )
    edges <- list(
      list(id = "e1-2", source = "1", target = "2")
    )
    reactflow(
      nodes = nodes,
      edges = edges,

      miniMap(), 
      controls(), 
      background()
    )
  })
}

shinyApp(ui, server)