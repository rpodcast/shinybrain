page{{app_snapshot}} <- function(nav_links) {
  brochure::page(
    href = "/page{{app_snapshot}}",
    ui = function(request) {
      tagList(
        page{{app_snapshot}}_ui(nav_links)
      )
    },
    server = function(input, output, session) {
      page{{app_snapshot}}_server(input, output, session)
    }
  )
}