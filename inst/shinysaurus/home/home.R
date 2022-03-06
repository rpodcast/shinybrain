home_ui <- function() {
  tagList(
    fluidRow(
      column(
        width = 12,
        shiny::includeMarkdown("home/introduction.md")
      )
    )
  )
}

home_server <- function(input, output, session) {
  # customize to your needs
}

home_demo <- function() {
  ui <- fluidPage(home_ui())
  server <- function(input, output, session) {
    home_server(input, output, session)
  }

  shinyApp(ui_server)
}