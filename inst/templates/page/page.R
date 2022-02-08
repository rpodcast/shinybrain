page{{app_snapshot}}_ui <- function(nav_links) {
    tagList(
        nav_links,
        h1("{{app_title}}"),
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

page{{app_snapshot}} <- function(nav_links) {
  page(
    href = "/page{{app_snapshot}}",
    ui = function(request) {
      tagList(
        tags$head(
          includeCSS("www/navigation.css")
        ),
        page{{app_snapshot}}_ui(nav_links)
      )
    },
    server = function(input, output, session) {
      page{{app_snapshot}}_server(input, output, session)
    }
  )
}