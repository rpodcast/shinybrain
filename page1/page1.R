#' @param root_dir optional defintion of the root directory of this app
page1_ui <- function(root_dir = NULL) {
    if (is.null(root_dir)) {
      root_dir <- getwd()
    } 
    
    tagList(
        h1("Prototype Live on Twitch"),
        nav_links,
        #tab_links,
        fluidRow(
          column(
            width = 12,
            shiny::includeMarkdown(file.path(root_dir, "page1_intro.md"))
          )
        ),
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

page1_server <- function(input, output, session, root_dir = NULL) {
  
  random_plot <- shinipsum::random_ggplot("bar")

  output$plot <- renderPlot({
    random_plot
  })
}