home_ui <- function(nav_links, bg = "#0062cc") {
  bslib::page_navbar(
    title = "{{app_title}}",
    bg = bg,
    !!!nav_links,
    footer = div(
      fluidRow(
        column(
          width = 12,
          shiny::includeMarkdown("home/introduction.md")
        )
      )
    )
  )
}

home_server <- function(input, output, session) {
  # customize to your needs
}
