#' Create new snapshot of the application
#' @param path directory path to the application
#' @param use_current_snapshot Flag to use the current (or latest) snapshot of the
#'   application as the source for the next snapshot. If set to `FALSE`, you must
#'   supply a valid snapshot name for the `snapshot_name` parameter.
#' @param snapshot_name Optional character string for the name of the desired
#' snapshot to use as the basis for the new snapshot. If no value is supplied,
#' then by default it will use the current or latest snapshot available in the app.
#' @param ... additional arguments to be used later
#'
#' @return invisibly the path of the new snapshot

snapshot_shinylearning <- function(path = getwd(), use_current_snapshot = TRUE, snapshot_name = NULL, ...) {
  # determine how many sub-apps are present
  apps <- fs::dir_ls(path, type = "directory", regexp = ".*/page.*")
  n_apps <- length(apps)

  # Create new directory for snapshot
  if (is.null(snapshot_name)) {
    current_snapshot_path <- fs::path(path, glue::glue("page{n_apps}"))
    current_snapshot_script <- glue::glue("page{n_apps}.R")
  } else {
    current_snapshot_path <- fs::path(path, snapshot_name)
    current_snapshot_script <- glue::glue("{snapshot_name}.R")
  }

  if (!fs::dir_exists(current_snapshot_path)) {
    stop(glue::glue("Specified snapshot name {snapshot_name} does not exist!", call. = FALSE))
  }

  new_snapshot_path <- fs::path(path, glue::glue("page{n_apps + 1}"))
  new_snapshot_script <- glue::glue("page{n_apps + 1}.R")

  fs::dir_copy(
    current_snapshot_path,
    new_snapshot_path
  )

  # rename the "previous" snapshot script to the new snapshot name
  fs::file_move(
    fs::path(new_snapshot_path, current_snapshot_script),
    fs::path(new_snapshot_path, new_snapshot_script)
  )

  snapshot_contents <- rlang::parse_exprs(x = file(fs::path(current_snapshot_path, current_snapshot_script)))

  file_conn <- file(fs::path(new_snapshot_path, new_snapshot_script))

  new_file_contents <- purrr::map(snapshot_contents, ~{
    current_fxn_name <- .x[[2]]
    fxn_suffix <- stringr::str_split(current_fxn_name, "_")[[1]][2]
    if (fxn_suffix == "demo") {
      res <- NULL
    } else {
      lhs <- glue::glue("page{n_apps + 1}_{fxn_suffix}")
      rhs <- .x[[3]]
      call <- rlang::call2("<-", lhs, rhs)
      call_str <- as.character(call)
      res <- c(call_str[[2]], call_str[[1]], call_str[[3]], "\n")
    }
    
    return(res)
  })

  # remove the NULL entry
  new_file_contents <- purrr::compact(new_file_contents)

  # convert back to character vector for writing to file
  new_file_char <- unlist(new_file_contents)

  # use template demo function file
  # to re-create demo code
  template_path <- fs::path(system.file("templates", "page", "page_demo.R", package = "shinylearning"))

  tmp_contents <- xfun::read_utf8(template_path)
  filled_tmp <- whisker::whisker.render(
      tmp_contents,
      data = list(app_snapshot = n_apps + 1)
  )

  writeLines(new_file_char, con = file_conn, sep = " ")
  close(file_conn)

  cat(filled_tmp, file = fs::path(new_snapshot_path, new_snapshot_script), append = TRUE, sep = "\n\n")

  fs::file_delete(fs::path(new_snapshot_path, "page_demo.R"))

  invisible(new_snapshot_path)
}
