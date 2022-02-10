fill_template <- function(app_path, template_file, output_file, app_snapshot = 1, delete_template = TRUE, template_pkg_dir = "page") {

  
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
      data = list(app_snapshot = app_snapshot)
  )

  # write filled template lines to app file
  cat(filled_tmp, file = output_path)

  if (delete_template) {
    fs::file_delete(template_path)
  }

  invisible(TRUE)
}