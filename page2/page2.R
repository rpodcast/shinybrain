page2_ui <- function(id) {
    ns <- NS(id)

    tagList(
        h1("More polish"),
        nav_links,
        fluidRow(
          column(
            width = 3,
            shinyWidgets::pickerInput(
              inputId = "Id094",
              label = "Select/deselect all options", 
              choices = LETTERS,
              options = list(`actions-box` = TRUE), 
              multiple = TRUE
            )
          )
        ),
        fluidRow(
          column(
            width = 12,
            DT::DTOutput(ns("mytable")
          )
        ),
        fluidRow(
          column(
            width = 12,
            plotOutput(ns("plot"))
          )
        )
      )
    )
}

page2_server <- function(input, output, session) {
  
  data(beavers)
  b1_df <- beaver1
  b2_df <- beaver2

  output$mytable <- renderDT({
    b1_df
  })

  output$plot <- renderPlot({
    ggplot(b1_df, aes(x = time, y = temp)) +
      geom_point()
  })
}