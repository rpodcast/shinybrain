page{{app_snapshot}}_ui <- function(nav_links, bg = "#0062cc") {
  bslib::page_navbar(
    title = "{{app_title}}",
    bg = bg,
    !!!nav_links,
    footer = div(
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
  )
}

page{{app_snapshot}}_server <- function(input, output, session) {
  
  random_plot <- shinipsum::random_ggplot("bar")

  output$plot <- renderPlot({
    random_plot
  })
}
