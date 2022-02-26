get_pages <- function(path) {
  # determine how many sub-apps are present
  apps <- fs::dir_ls(path, type = "directory", regexp = "page.*")
  apps <- fs::path_file(apps)
  return(apps)
}

gen_navitems <- function(path, active_tab = "home", add_home = TRUE) {
  # create navigation bar UI code ----
  page_ids <- get_pages(path)
  page_links <- purrr::map_chr(page_ids, ~glue::glue("/{page_id}", page_id = .x))

  if (add_home) {
    page_ids <- c("home", page_ids)
    page_links <- c("/", page_links)
  }

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