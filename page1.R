page1_ui <- function(id) {
    ns <- NS(id)

    tagList(
        h1("Prototype Live on Twitch"),
        nav_links,
        #tab_links,
        fluidRow(
          column(
            width = 12,
            shiny::includeMarkdown("page1_intro.md")
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
            plotOutput(ns("plot"))
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