#' @param root_dir optional defintion of the root directory of this app
page1_ui <- function() {
    tagList(
        h1("{{app_title}}"),
        nav_links,
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