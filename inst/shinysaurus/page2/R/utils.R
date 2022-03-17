useBox <- function() {
  if (!requireNamespace(package = "shinydashboard")) {
    message("package 'shinydashboard' is required to run this function")
  }

  deps <- htmltools::findDependencies(shinydashboard::dashboardPage(
    header = shinydashboard::dashboardHeader(),
    sidebar = shinydashboard::dashboardSidebar(),
    body = shinydashboard::dashboardBody()
  ))
  htmltools::attachDependencies(tags$div(), value = deps)
}

my_dashboard_box <- function(title, status, ...) {
  tagList(
    shinydashboard::box(
      ...,
      title = title, 
      status = status
    ) 
  )
}