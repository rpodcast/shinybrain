page1 <- function(nav_links) {
  brochure::page(
    href = "/page1",
    ui = function(request) {
      tagList(
        page1_ui(nav_links)
      )
    },
    server = function(input, output, session) {
      page1_server(input, output, session)
    }
  )
}