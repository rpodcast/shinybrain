#' Compose single page of shinylearning app
#' @param nav_links list of navigation bar elements created with `gen_navitems`.
#' @param page_id page identifer.
#' @param title application title
#' @param bg color of the navigation bar
#' @return list produced by `brochure::page`
#' @export
app_page <- function(nav_links, page_id = "page1", title = "myapp", bg = "#0062cc") {
  if (page_id == "home") {
    href <- "/"
  } else {
    href <- paste0("/", page_id)
  }

  brochure::page(
    href = href,
    ui = function(request) {
      tagList(
        bslib::page_navbar(
          title = title,
          bg = bg,
          !!!nav_links,
          footer = div(
            rlang::exec(paste(page_id, "ui", sep = "_"))
          )
        )
      )
    },
    server = function(input, output, session) {
      rlang::exec(paste(page_id, "server", sep = "_"), input, output, session)
    }
  )
}