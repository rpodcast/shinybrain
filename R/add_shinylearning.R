#' Initialize fresh shiny learning app
#' @param path Name of the folder to create the app in.
#'   This will also be used as the app name.
#' @param app_name App name to use. By default, {shinylearning}
#'   uses `basename(path)`. If `path == '.'` & `app_name` is
#'   not explicitly set, then `basename(getwd())` will be used.
#' @param overwrite Boolean. Should the already existing app
#'   be overwritten?
#' @param open Boolean. Open the created app project?
#' @param ... additional arguments to be used later
#' 
#' @import cli
#'
#' @return invisibly the path to new application
add_shinylearning <- function(
  path,
  app_name = basename(path), 
  overwrite = FALSE,
  open = FALSE, 
  ...) {

  cat_rule("Creating your shinylearning app")

  # define flags for future customization
  create_homepage <- TRUE

  # remove current copy if it exists already
  if (fs::dir_exists(path)) {
    if (!isTRUE(overwrite)) {
      stop(
        paste(
          "App directory already exists.\n",
          "Set `add_shinylearning(overwrite = TRUE)` to overwrite anyway.\n",
          "Make sure you back up any important files first!"
        ),
        call. = FALSE
      )
    } else {
      cli_alert_warning("Overwriting existing app directory")
    }
  } else {
    cat_rule("Creating app directory")
    usethis::create_project(
      path = path,
      open = FALSE
    )
  }

  # create directory in path with the app_name
  #fs::dir_create(app_path)
  cat_rule("Copying template app files")

  # copy the template files to the directory
  fs::dir_copy(
    system.file("templates", "page", package = "shinylearning"),
    fs::path(path, "page1"),
    overwrite = TRUE
  )

  # temp fix to get rid of demo file
  fs::file_delete(fs::path(path, "page1", "page_demo.R"))

  fs::file_copy(
    system.file("templates", "app.R", package = "shinylearning"), 
    path,
    overwrite = TRUE
  )

  # fs::file_copy(
  #   system.file("templates", "shinylearning-utils.R", package = "shinylearning"), app_path
  # )

  if (create_homepage) {
    fs::dir_copy(
      system.file("templates", "home", package = "shinylearning"),
      fs::path(path, "home"),
      overwrite = TRUE
    )

    # populate template home app module with app name as title
    tmp_contents <- xfun::read_utf8(fs::path(path, "home", "home.R"))
    filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_title = app_name)
    )

    # write filled template lines to app file
    cat(filled_tmp, file = fs::path(path, "home", "home.R"), append = FALSE)
  }

  # populate app.R with create_homepage value
  tmp_contents <- xfun::read_utf8(fs::path(path, "app.R"))
  filled_tmp <- whisker::whisker.render(
    tmp_contents,
    data = list(app_title = app_name)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = fs::path(path, "app.R"), append = FALSE)

  # populate template page1 app module with app name as the title and number as app snapshot
  fill_template(path, template_file = "page.R", app_title = app_name, app_snapshot = 1, output_file = "page1.R", delete_template = TRUE)

  cli_alert_success("Copied app templates")

  cat_rule("Done")

  cat_line(
    paste0(
      "A new shinylearning app named ",
      app_name,
      " was created at ",
      normalizePath(path),
      " .\n"
    )
  )

  if (isTRUE(open)) {
    if (rstudioapi::isAvailable() & rstudioapi::hasFun("openProject")) {
      rstudioapi::openProject(path = path)
    } else {
      cli_alert_info("Unable to open project directly. Please open the project manually.")
      #setwd(path)
    }
  }

  # return app path
  return(
    invisible(
      normalizePath(path)
    )
  )
}