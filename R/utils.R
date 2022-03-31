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
app_page <- function(nav_links, custom_theme, code_content, page_id = "page1", title = "myapp", bg = "#0062cc") {
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

# utility functions for reading file contents
# credit: https://github.com/rstudio/shiny/blob/ac84be956a1417a613e0b6ebeea75b08f9302df2/R/utils.R

# read a file using UTF-8 and (on Windows) convert to native encoding if possible
readUTF8 <- function(file) {
  enc <- checkEncoding(file)
  file <- base::file(file, encoding = enc)
  on.exit(close(file), add = TRUE)
  # enc2utf8 is a base R function
  x <- enc2utf8(readLines(file, warn = FALSE))
  tryNativeEncoding(x)
}

# if the UTF-8 string can be represented in the native encoding, use native encoding
tryNativeEncoding <- function(string) {
  if (!isWindows()) return(string)
  string2 <- enc2native(string)
  if (identical(enc2utf8(string2), string)) string2 else string
}

# assume file is encoded in UTF-8, but warn against BOM
checkEncoding <- function(file) {
  # skip *nix because its locale is normally UTF-8 based (e.g. en_US.UTF-8), and
  # *nix users have to make a conscious effort to save a file with an encoding
  # that is not UTF-8; if they choose to do so, we cannot do much about it
  # except sitting back and seeing them punished after they choose to escape a
  # world of consistency (falling back to getOption('encoding') will not help
  # because native.enc is also normally UTF-8 based on *nix)
  if (!isWindows()) return('UTF-8')
  size <- file.info(file)[, 'size']
  if (is.na(size)) stop('Cannot access the file ', file)
  # BOM is 3 bytes, so if the file contains BOM, it must be at least 3 bytes
  if (size < 3L) return('UTF-8')

  # check if there is a BOM character: this is also skipped on *nix, because R
  # on *nix simply ignores this meaningless character if present, but it hurts
  # on Windows
  if (identical(charToRaw(readChar(file, 3L, TRUE)), charToRaw('\UFEFF'))) {
    warning('You should not include the Byte Order Mark (BOM) in ', file, '. ',
            'Please re-save it in UTF-8 without BOM. See ',
            'https://shiny.rstudio.com/articles/unicode.html for more info.')
    return('UTF-8-BOM')
  }
  x <- readChar(file, size, useBytes = TRUE)
  if (is.na(iconv(x, 'UTF-8', 'UTF-8'))) {
    warning('The input file ', file, ' does not seem to be encoded in UTF8')
  }
  'UTF-8'
}

isWindows <- function() .Platform$OS.type == 'windows'