page{{app_snapshot}}_ui <- function() {
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

page{{app_snapshot}}_server <- function(input, output, session) {

  random_plot <- shinipsum::random_ggplot("bar")

  output$plot <- renderPlot({
    random_plot
  })
}

page{{app_snapshot}}_demo <- function() {
  ui <- fluidPage(page{{app_snapshot}}_ui())
  server <- function(input, output, session) {
    page{{app_snapshot}}_server(input, output, session)
  }

  shinyApp(ui, server)
}

page{{app_snapshot}}_theme <- function() {
  bslib::bs_theme(bootswatch = "default")
}
