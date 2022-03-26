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
