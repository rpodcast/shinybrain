page4_ui <- function() {
  ds_names <- unique(
    datasauRus::datasaurus_dozen$dataset
  )
  tagList(
    useBox(), 
    fluidRow(
      column(
        width = 12,
        my_dashboard_box(
          title = "Introduction",
          status = "success",
          collapsible = TRUE,
          collapsed = FALSE,
          closable = TRUE,
          shiny::includeMarkdown("docs/explore.md")
        )
      )
    ),
    fluidRow(
      column(
        width = 12, my_dashboard_box(
          title = "Explore",
          status = "success",
          collapsible = TRUE,
          collapsed = FALSE,
          maximizable = FALSE,
          width = 12, fluidRow(
          column(
            width = 12,
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
            bs4Dash::bs4InfoBoxOutput(
              "box_x",
              width = 4
            ),
            bs4Dash::bs4InfoBoxOutput(
              "box_y",
              width = 4
            ),
            bs4Dash::bs4InfoBoxOutput(
              "box_cor",
              width = 4
            )
          ),
            fluidRow(
            column(
              width = 6,
              plotly::plotlyOutput("ds_plot", height = "600px")
            ),
            column(
              width = 6,
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
              plotly::plotlyOutput("anim_plot", height = "1000px")
            )
          )
          )
        )
        )
      )
    )
  )
}
page4_server <- function(input, output, session) {

  # keep track of which rows
  df_rows <- reactiveVal(NULL)
  df_sub <- reactiveVal(NULL)

  data_df <- reactive(
    {
      req(input$data_select)
      extract_dataset(input$data_select)
    }
  )

  output$box_x <- bs4Dash::renderbs4InfoBox({
    req(data_df())
    if (!is.null(df_sub())) {
      df <- df_sub()
    } else {
      df <- data_df()
    }
    mean_val <- round(
      mean(df$x),
      1
    )
    sd_val <- round(
      sd(df$x),
      2
    )

    bs4Dash::bs4InfoBox(
      title = "Mean (SD) of X",
      color = "success",
      fill = TRUE,
      value = glue::glue(
        "{mean_val} ({sd_val})"
      ),
      icon = shiny::icon("table")
    )
  })

  output$box_y <- bs4Dash::renderbs4InfoBox({
    req(data_df())
    if (!is.null(df_sub())) {
      df <- df_sub()
    } else {
      df <- data_df()
    }
    mean_val <- round(
      mean(df$y),
      1
    )
    sd_val <- round(
      sd(df$y),
      2
    )
    bs4Dash::bs4InfoBox(
      title = "Mean (SD) of Y",
      color = "success",
      fill = TRUE,
      value = glue::glue(
        "{mean_val} ({sd_val})"
      ),
      icon = shiny::icon("table")
    )
  })
  output$box_cor <- bs4Dash::renderbs4InfoBox({
      req(data_df())
      if (!is.null(df_sub())) {
      df <- df_sub()
    } else {
      df <- data_df()
    }
      cor_val <- round(
        cor(x = df$x, y = df$y),
        2
      )
      bs4Dash::bs4InfoBox(
      title = "Correlation",
      color = "success",
      fill = TRUE,
      value = round(cor(x = df$x, y = df$y), 2),
      icon = shiny::icon("table")
      )
    }
  )
  output$ds_plot <- plotly::renderPlotly(
    {
      req(data_df())
      render_data_graph(data_df())
    }
  )

  # obtain rows selected in plotly chart and update reactive value
  observeEvent(event_data("plotly_selected", source = "A"), {

    df_rows_sel <- event_data("plotly_selected")$customdata
    df_rows(df_rows_sel)

    if (is.null(df_rows_sel)) {
      df_sub(NULL)
    } else {
      df_filtered <- dplyr::slice(data_df(), df_rows_sel)
      df_sub(df_filtered)
    }

  })

  ev_trigger <- reactive({
    tmp <- plotly::event_data("plotly_selected", source = "A")
    if (is.null(tmp)) {
      df_sub(NULL)
    }
    tmp
  })

  output$ds_table <- DT::renderDataTable(
    {
      req(data_df())
      ev_trigger()
      if (is.null(df_sub())) {
        res <- data_df()
      } else {
        res <- df_sub()
      }

      return(res)
    }, rownames = FALSE, options = list(dom = "tip")
  )
  metamer_df <- reactive({
    # show modal to say something is happening
    shinyalert::shinyalert(
      title = "Magic is Happening!",
      text = NULL,
      size = "m",
      closeOnEsc = FALSE,
      closeOnClickOutside = FALSE,
      type = "info",
      showConfirmButton = FALSE,
      showCancelButton = FALSE,
      timer = 0,
      imageUrl = "https://media.giphy.com/media/xTiTnAUgTbDrsUiHja/giphy.gif",
      imageWidth = 400,
      imageHeight = 400,
      animation = TRUE
    )

    res <- create_metamers(
      input$rank_list_2,
      perturbation = input$pert,
      N = input$iterations,
      trim = input$metamers)

    return(as.data.frame(res))
    }
  ) %>% bindEvent(input$animate)

  metamer_sum <- reactive({
    req(metamer_df())
    df <- tibble::as_tibble(metamer_df()) %>%
      group_by(.metamer) %>%
      summarize(
        mean_x = mean(x),
        mean_x_print = glue::glue("Mean(X) = {round(mean_x, 2)}"),
        mean_y = mean(y),
        mean_y_print = glue::glue("Mean(Y) = {round(mean_y, 2)}"),
        cor_xy = cor(x, y),
        cor_xy_print = glue::glue("Cor(X,Y) = {round(cor_xy, 2)}")
      ) %>%
      ungroup

    shinyalert::closeAlert()
    return(df)
  })


  output$anim_plot <- plotly::renderPlotly(
    {
      req(metamer_df())
      req(metamer_sum())
      req(input$frame)
      render_animation_graph(metamer_df(), metamer_sum(), frame = input$frame)
    }
  )
}

page4_demo <- function() {
  ui <- fluidPage(page4_ui())
  server <- function(
    input, output,
    session
  ) {
    page4_server(
      input, output,
      session
    )
  }

  shinyApp(ui, server)
}

page4_theme <- function() {
  bslib::bs_theme(
    bootswatch = "default",
    font_scale = NULL,
    `enable-gradients` = TRUE,
    `enable-shadows` = TRUE
  )
}
