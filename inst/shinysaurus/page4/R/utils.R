useBox <- function() {
  if (!requireNamespace(package = "bs4Dash")) {
    message("package 'bs4Dash' is required to run this function")
  }

  deps <- htmltools::findDependencies(bs4Dash::bs4DashPage(
    header = bs4Dash::bs4DashNavbar(),
    sidebar = bs4Dash::bs4DashSidebar(),
    body = bs4Dash::bs4DashBody()
  ))
  htmltools::attachDependencies(tags$div(), value = deps)
}

my_dashboard_box <- function(...) {
  tagList(
    bs4Dash::box(...)
  )
}

extract_dataset <- function(dataset) {
  df <- datasauRus::datasaurus_dozen

  df <- df %>%
    dplyr::filter(dataset == !!dataset) %>%
    dplyr::select(x, y)

  return(df)
}

render_data_graph <- function(df, register_select = TRUE, ...) {
  base <- plot_ly(
    df,
    x = ~x,
    y = ~y,
    customdata = seq(1, nrow(df)),
    source = "A"
  ) %>%
    layout(
      xaxis = list(range = c(0, 100)),
      yaxis = list(range = c(0, 100)),
      dragmode = "select"
    )

  if (register_select) {
    base <- event_register(base, "plotly_selecting")
  }

  return(base)
}

render_animation_graph <- function(metamer_df, metamer_sum, frame = 100) {
  base <- plot_ly(metamer_df,  x = ~x, y = ~y) %>%
    add_markers(frame = ~.metamer) %>%
    add_text(x = 90, y = 95, frame = ~.metamer, text = ~mean_x_print, data = metamer_sum, showlegend = FALSE) %>%
    add_text(x = 90, y = 93, frame = ~.metamer, text = ~mean_y_print, data = metamer_sum, showlegend = FALSE) %>%
    add_text(x = 90, y = 91, frame = ~.metamer, text = ~cor_xy_print, data = metamer_sum, showlegend = FALSE) %>%
    layout(
      xaxis = list(range = c(0, 100)),
      yaxis = list(range = c(0, 100))
    )

  base %>%
    animation_opts(frame = frame, easing = "linear", redraw = FALSE) %>%
    animation_button(
      x = 1, xanchor = "right", y = 0, yanchor = "bottom"
    )
}

create_metamers <- function(datasets, perturbation = 0.08, N = 30000, trim = 150, ...) {
  # obtain the first and last elements of datasets
  first_dataset <- datasets[1]
  second_dataset <- datasets[2]
  last_dataset <- datasets[length(datasets)]

  # derive first set of metamers
  df1 <- extract_dataset(first_dataset)
  df2 <- extract_dataset(second_dataset)

  metamers <- metamerize(
    data = df1,
    preserve = delayed_with(mean(x), mean(y), cor(x, y)),
    minimize = mean_dist_to(df2),
    perturbation = perturbation,
    N = N,
    trim = trim)

  return(metamers)
}
