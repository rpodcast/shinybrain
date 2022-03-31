read_appcode <- function(path, page_id) {
  r_files <- fs::dir_ls(fs::path(path, page_id), regexp = "\\.[rR]$", recurse = TRUE, type = "file")
  #rFiles <- list.files(pattern = "\\.[rR]$")
  #r_files

  res <- purrr::map(r_files, ~{
    readUTF8(.x) |> paste(collapse = "\n")
  })

  return(res)
}