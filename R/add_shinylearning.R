#' Initialize fresh shiny learning app
#' @param app_name string of the app name to use as the directory
#'   to store application files
#' @param path parent directory to store app files. Default is the
#'   current working directory
#' @param create_project Flag to create an RStudio project file
#'   in the application directory. Default is FALSE.
#' @param open Flag to open the project if using RStudio. Default
#'   is TRUE.
#' @param ... additional arguments to be used later
#'
#' @return invisibly the path to new application
add_shinylearning <- function(
  app_name, 
  path = getwd(), 
  create_project = FALSE,
  open = TRUE, ...) {
  # define path variables
  app_path <- fs::path(path, app_name)

  # remove current copy if it exists already
  if (fs::dir_exists(app_path)) {
    fs::dir_delete(app_path)
  }

  # create directory in path with the app_name
  fs::dir_create(app_path)
  # copy the template files to the directory
  fs::dir_copy(
    system.file("templates", "www", package = "shinylearning"),
    app_path
  )

  fs::dir_copy(
    system.file("templates", "home", package = "shinylearning"),
    fs::path(app_path, "home")
  )

  fs::dir_copy(
    system.file("templates", "page", package = "shinylearning"),
    fs::path(app_path, "page1")
  )

  fs::file_copy(
    system.file("templates", "app.R", package = "shinylearning"), app_path
  )

  fs::file_copy(
    system.file("templates", "shinylearning-utils.R", package = "shinylearning"), app_path
  )

  # populate template home app module with app name as title
  tmp_contents <- xfun::read_utf8(fs::path(app_path, "home", "home.R"))
  filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_title = app_name)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = fs::path(app_path, "home", "home.R"), append = FALSE)

  # populate template page1 app module with app name as the title and number as app snapshot
  tmp_contents <- xfun::read_utf8(fs::path(app_path, "page1", "page.R"))
  filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_title = app_name, app_snapshot = 1)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = fs::path(app_path, "page1", "page1.R"))

  # remove placeholder file
  fs::file_delete(fs::path(app_path, "page1", "page.R"))

  # populate template page1 function with number as app snapshot
  tmp_contents <- xfun::read_utf8(fs::path(app_path, "page1", "page_function.R"))
  filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_snapshot = 1)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = fs::path(app_path, "page1", "page1_function.R"))

  # remove placeholder file
  fs::file_delete(fs::path(app_path, "page1", "page_function.R"))

  # create rstudio project file if requested
  if (create_project) {
    usethis::create_project(app_path, rstudio = TRUE, open = FALSE)
    # open project if using RStudio and flag is TRUE
    # thank you {golem}!

    if (isTRUE(open)) {
      if (rstudioapi::isAvailable() & rstudioapi::hasFun("openProject")) {
        rproj_file <- fs::path(app_path, glue::glue("{app_name}.Rproj"))
        rstudioapi::openProject(path = rproj_file)
      }
    }
  }

  # return app path
  invisible(app_path)
}