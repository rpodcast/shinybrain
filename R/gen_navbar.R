get_pages <- function(path) {
  # determine how many sub-apps are present
  apps <- fs::dir_ls(path, type = "directory", regexp = "page.*")
  apps <- fs::path_file(apps)
  return(apps)
}

#' Generate navigation bar for shinylearning app
#' @param path path to existing shinylearning app
#' @param active_tab which tab should be active when initializing the app.
#'   Default is `home`.
#' @return list of navigation bar elements created with `bslib`
#' @export
gen_navitems <- function(path, active_tab = "home") {
  # create navigation bar UI code ----
  page_ids <- get_pages(path)
  page_links <- purrr::map_chr(page_ids, ~glue::glue("{page_id}", page_id = .x))

  page_ids <- c("home", page_ids)
  page_links <- c("./", page_links)

  nav_links <- purrr::map2(page_ids, page_links, ~{
    if (.x == active_tab) {
      res <- tags$a(
        class = "active",
        href = glue::glue("{link}", link = .y),
        .x
      )
    } else {
      res <- tags$a(
        href = glue::glue("{link}", link = .y),
        .x
      )
    }

    res <- bslib::nav_item(res)
    return(res)
  })

  return(nav_links)
}
