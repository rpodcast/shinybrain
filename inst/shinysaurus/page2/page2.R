page2_ui <- function() {
  # obtain names of available datasauRus data sets
  ds_names <- unique(datasauRus::datasaurus_dozen$dataset)
  tagList(
    useBox(),
    fluidRow(
      column(
        width = 12,
    my_dashboard_box(
          title = "Explore", 
          status = "success",
      collapsible = TRUE,
      collapsed = FALSE,
      maximizable = TRUE,
      width = 12,
      fluidRow(
            column(
              width = 4,
              selectInput(
                "explore_dataset",
                "Select your dataset",
                choices = ds_names,
                selected = ds_names[1]
              )
            )
          ),
          fluidRow(
        column(
          width = 6,
          plotOutput("plot")
        ),
        column(
          width = 6,
          shinipsum::random_DT(
            nrow = 10,
            ncol = 3
          )
        ),
      )
    ),
    fluidRow(
      h2("Animate"),
      selectInput(
        "datasets",
        "Data Set",
        choices = c(
          "A", "B",
          "C"
        ),
        selected = c(
          "A", "B",
          "C"
        ),
        multiple = TRUE
      ),
      numericInput(
        "iterations",
        "Iterations",
        value = 1000
      ),
      numericInput(
        "pert", "pert",
        value = 0.5
      ),
      numericInput(
        "metamers",
        "metamers",
        value = 150
      ),
      actionButton(
        "animate",
        "Animate"
      )
    ),
    fluidRow(
      column(
        width = 12,
        numericInput(
          "time_frames",
          "Time btw Frames",
          value = 100
        ),
        plotOutput("plot2")
          )
        )
      )
    )
  )
}
page2_server <- function(input, output, session) {
  random_plot <- shinipsum::random_ggplot("bar")
  random_plot2 <- shinipsum::random_ggplot("point")
  output$plot <- renderPlot(
    {
      random_plot
    }
  )
  output$plot2 <- renderPlot(
    {
      random_plot2
    }
  )
}
page2_demo <- function() {
  ui <- fluidPage(page2_ui())
  server <- function(
    input, output,
    session
  ) {
    page2_server(
      input, output,
      session
    )
  }

  shinyApp(ui, server)
}
