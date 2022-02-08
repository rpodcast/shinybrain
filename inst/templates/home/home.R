home_ui <- function(nav_links) {
  tagList(
    nav_links,
    h1("{{app_title}}"),
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
