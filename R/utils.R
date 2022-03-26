fill_template <- function(app_path, template_file, output_file, app_title, app_snapshot = 1, delete_template = TRUE, template_pkg_dir = "page") {

  # populate template file with app name as the title and number as app snapshot
  template_path <- fs::path(app_path, glue::glue("page{app_snapshot}"), template_file)

  # copy over template file if it is not in app_path
  if (!fs::file_exists(template_path)) {
    fs::file_copy(
      system.file("templates", template_pkg_dir, template_file, package = "shinylearning"), template_path
    )
  }

  output_path <- fs::path(app_path, glue::glue("page{app_snapshot}"), output_file)
  tmp_contents <- xfun::read_utf8(template_path)
  filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_title = app_title, app_snapshot = app_snapshot)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = output_path)

  if (delete_template) {
    fs::file_delete(template_path)
  }

  invisible(TRUE)
}

#' Compose single page of shinylearning app
#' @param nav_links list of navigation bar elements created with `gen_navitems`.
#' @param page_id page identifer.
#' @param title application title
#' @param bg color of the navigation bar
#' @return list produced by `brochure::page`
#' @export
app_page <- function(nav_links, custom_theme, page_id = "page1", title = "myapp", bg = "#0062cc") {
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
          theme = custom_theme,
          !!!nav_links,
          div(
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

brain_power <- function(path = getwd()) {
  withr::with_dir(path, shiny::runApp())
}

brain_snap <- function(snapshot_name, path = getwd()) {
  r_scripts <- fs::dir_ls(fs::path(path, snapshot_name), recurse = TRUE, type = "file")
  purrr::walk(r_scripts, ~source(.x))
  rlang::exec(paste(snapshot_name, "demo", sep = "_"))
}
