page1_ui <- function() {
  tagList(
    fluidRow(
      h2("Explore"),
      column(
        width = 6,
        plotOutput("plot")
      ),
      column(
        width = 6,
        shinipsum::random_DT(
          nrow = 10,
          ncol = 3
        )
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

page1_theme <- function() {
  bslib::bs_theme(bootswatch = "materia")
}
