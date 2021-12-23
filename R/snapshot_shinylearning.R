snapshot_shinylearning <- function(path = getwd()) {
  # determine how many sub-apps are present
  #browser()
  apps <- fs::dir_ls(path, type = "directory", regexp = ".*/page.*")

  n_apps <- length(apps)

  # create dir for next app snapshot
  #new_snapshot_dir <- fs::dir_create(fs::path(path, glue::glue("page{n_apps + 1}")))
  
  # copy files from current snapshot to the new snapshot
  #current_files <- fs::dir_ls(fs::path(path, glue::glue("page{n_apps}")))

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


  return(n_apps)
}