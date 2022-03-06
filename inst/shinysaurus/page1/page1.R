page1_ui <- function() {
  tagList(
    fluidRow(
      column(
        width = 12,
        shinipsum::random_DT(
          nrow = 10,
          ncol = 5
        )
      ),
    ),
    fluidRow(
      column(
        width = 12,
        plotOutput("plot")
      )
    )
  )
}

page1_server <- function(input, output, session) {
  
  random_plot <- shinipsum::random_ggplot("bar")

  output$plot <- renderPlot({
    random_plot
  })
}

page1_demo <- function() {
  ui <- fluidPage(page1_ui())
  server <- function(input, output, session) {
    page1_server(input, output, session)
  }

  shinyApp(ui, server)
}