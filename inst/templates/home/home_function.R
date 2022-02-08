home <- function(nav_links) {
  page(
    href = "/",
    ui = function(request) {
      tagList(
        tags$head(
          includeCSS("www/navigation.css")
        ),
        home_ui(nav_links)
      )
    },
    server = function(input, output, session) {
      home_server(input, output, session)
    }
  )
}