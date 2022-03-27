page3_ui <- function() {
  ds_names <- unique(
    datasauRus::datasaurus_dozen$dataset
  )
  tagList(
    useBox(), fluidRow(
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
                  width = 4,
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
                  width = 4,
                  uiOutput("box_x")
                ),
                column(
                  width = 4,
                  uiOutput("box_y")
                ),
                column(
                  width = 4,
                  uiOutput("box_cor")
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
        ),
        fluidRow(
          column(
          width = 12,
          my_dashboard_box(
            title = "Animate",
            status = "success",
            collapsible = TRUE,
            collapsed = FALSE,
            maximizable = FALSE,
            width = 12,
            fluidRow(
            column(
              width = 6,
              bucket_list(
                header = NULL,
                group_name = "bucket_list_group",
                orientation = "horizontal",
                add_rank_list(
                  input_id = "rank_list_1",
                  text = "Drag from here",
                  labels = as.list(ds_names)
                ),
                add_rank_list(
                  input_id = "rank_list_2",
                  text = "To here"
                )
              )
            ),
            column(
              width = 4,
              numericInput(
                "iterations",
                "Iterations",
                value = 30000
              ),
              numericInput(
                "pert",
                "pert",
                value = 0.5
              ),
              numericInput(
                "metamers",
                "metamers",
                value = 150
              ),
              numericInput(
                "frame",
                "Time btw Frames",
                value = 100
              ),
              actionButton(
                "animate",
                "Animate"
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              plotOutput("anim_plot")
            )
          )
          )
        )
        )
      )
    )
  )
}
page3_server <- function(input, output, session) {

  # reactive for data frame selected
  data_df <- reactive({
    req(input$data_select)
    extract_dataset(input$data_select)
  })

  # summary statistics
  output$box_x <- renderUI({
    req(data_df())
    df <- data_df()
    mean_val <- round(mean(df$x), 1)
    sd_val <- round(sd(df$x), 2)
    glue::glue("Mean (SD) of X: {mean_val} ({sd_val})")
  })

  # summary statistics
  output$box_y <- renderUI({
    req(data_df())
    df <- data_df()
    mean_val <- round(mean(df$y), 1)
    sd_val <- round(sd(df$y), 2)
    glue::glue("Mean (SD) of Y: {mean_val} ({sd_val})")
  })

  # summary statistics
  output$box_cor <- renderUI({
    req(data_df())
    df <- data_df()
    cor_val <- round(cor(x = df$x, y = df$y), 2)
    glue::glue("Correlation: {cor_val}")
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

  # animation data frame
  metamer_df <- reactive({
    req(input$rank_list_2)
    df1 <- extract_dataset(input$rank_list_2[1])
    df2 <- extract_dataset(input$rank_list_2[2])

    metamers <- metamerize(
      data = df1,
      preserve = delayed_with(mean(x), mean(y), cor(x, y)),
      minimize = mean_dist_to(df2),
      perturbation = input$pert,
      N = input$iterations,
      trim = input$metamers
    )

    return(as.data.frame(metamers))
  }) %>% bindEvent(input$animate)

  # animation plot placeholder
  # simply select one frame randomly
  output$anim_plot <- renderPlot({
    req(metamer_df())
    req(input$frame)

    plot_df <- metamer_df() %>%
      dplyr::filter(.metamer == sample(1:input$frame, 1))

    p <- ggplot(data = plot_df, aes(x = x, y = y)) +
      geom_point() +
      scale_x_continuous(breaks = seq(0, 100, by = 10)) +
      scale_y_continuous(breaks = seq(0, 100, by = 10))

    p
  })
}

page3_demo <- function() {
  ui <- fluidPage(page3_ui())
  server <- function(
    input, output,
    session
  ) {
    page3_server(
      input, output,
      session
    )
  }

  shinyApp(ui, server)
}

page3_theme <- function() {
  bslib::bs_theme(bootswatch = "default")
}
