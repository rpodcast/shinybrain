page{{app_snapshot}}_demo <- function() {
  ui <- fluidPage(page{{app_snapshot}}_ui())
  server <- function(input, output, session) {
    page{{app_snapshot}}_server(input, output, session)
  }

  shinyApp(ui, server)
}
