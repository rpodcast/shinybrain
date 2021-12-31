snapshot_shinylearning <- function(path = getwd()) {
  # determine how many sub-apps are present
  #browser()
  apps <- fs::dir_ls(path, type = "directory", regexp = ".*/page.*")

  n_apps <- length(apps)

  # create dir for next app snapshot
  #new_snapshot_dir <- fs::dir_create(fs::path(path, glue::glue("page{n_apps + 1}")))
  
  # copy files from current snapshot to the new snapshot
  #current_files <- fs::dir_ls(fs::path(path, glue::glue("page{n_apps}")))

  # Create new directory for snapshot
  fs::dir_copy(
    fs::path(path, glue::glue("page{n_apps}")),
    fs::path(path, glue::glue("page{n_apps + 1}"))
  )

  # TODO:
  # - import the code for the previous snapshot via rlang
  # - find the function names in the UI and server parts of module
  # - change those to pageX_UI and pageX_server as appropriate
  # - re-create the fucntion calls with the new function names and add the previous arguments and body of function code
  # - write back out to a file

  # TODO: Make this dynamic based on user requesting a specific snapshot
  #       of the app, or default to the latest or "current" snapshot
  snapshot_contents <- rlang::parse_exprs(x = file("page1.R"))

  # TODO: Create file name dynamically
  fileConn <- file("new_file.R")

  new_file_contents <- purrr::map(snapshot_contents, ~{
    current_fxn_name <- .x[[2]]
    #message(glue::glue("current_fxn_name is {current_fxn_name}"))
    fxn_suffix <- stringr::str_split(current_fxn_name, "_")[[1]][2]
    #message(glue::glue("fxn suffix is {fxn_suffix}"))
    lhs <- paste("page2", fxn_suffix, sep = "_")
    rhs <- .x[[3]]
    #message(glue::glue("rhs is {rhs}"))
    call <- rlang::lang("<-", lhs, rhs)
    call_str <- as.character(call)
    #message(call_str)
    res <- c(call_str[[2]], call_str[[1]], call_str[[3]], "\n")
    return(res)
  })

  # convert back to character vector for writing to file
  new_file_char <- unlist(new_file_contents)
  writeLines(new_file_char, con = fileConn, sep = " ")
  close(fileConn)

  return(n_apps)
}