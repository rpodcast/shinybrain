get_pages <- function(path) {
  # determine how many sub-apps are present
  apps <- fs::dir_ls(path, type = "directory", regexp = ".*/page.*")
  apps <- fs::path_file(apps)
  return(apps)
}

#' @importFrom htmltools tagList tags
gen_navbar <- function(path) {
  # create navigation bar UI code ----
  page_ids <- get_pages(path)
  nav_links <- purrr::map(page_ids, ~{
      tags$ul(
        tags$li(
          tags$a(href = glue::glue("/{page_id}", page_id = .x), .x)
        )
      )
  })

  nav_links <- tagList(nav_links)
  return(nav_links)
}