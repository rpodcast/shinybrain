home <- function(nav_links) {
  brochure::page(
    href = "/",
    ui = function(request) {
      tagList(
        home_ui(nav_links)
      )
    },
    server = function(input, output, session) {
      home_server(input, output, session)
    }
  )
}