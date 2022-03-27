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
          maximizable = FALSE,
          width = 12,
          fluidRow(
            column(
              width = 10,
              fluidRow(
                column(
                  width = 8,
                  selectInput(
                    "data_select",
                    "Select your dataset",
                    choices = ds_names,
                    selected = ds_names[1]
                  )
                )
              ),
              fluidRow(
                column(
                  width = 6,
                  plotOutput("ds_plot")
                ),
                column(
                  width = 4,
                  DT::dataTableOutput("ds_table")
                )
              )
            )
          )
        )
      )
    )
  )
}

page2_server <- function(input, output, session) {

  # reactive for data frame selected
  data_df <- reactive({
    req(input$data_select)
    extract_dataset(input$data_select)
  })

  # exploration plot
  output$ds_plot <- renderPlot({
    req(data_df())
    p <- ggplot(data = data_df(), aes(x = x, y = y)) +
      geom_point() +
      scale_x_continuous(breaks = seq(0, 100, by = 10)) +
      scale_y_continuous(breaks = seq(0, 100, by = 10))

    p
  })

  # exploration table
  output$ds_table <- DT::renderDataTable({
    req(data_df())
    data_df()
  },
  rownames = FALSE,
  options = list(dom = 'tip'))
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

page2_theme <- function() {
  bslib::bs_theme(bootswatch = "default")
}
