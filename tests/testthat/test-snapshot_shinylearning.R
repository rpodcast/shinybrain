test_that("import file works", {
  
  snapshot_contents <- rlang::parse_exprs(x = file("page1.R"))

  browser()
  #testthat::expect_null(snapshot_contents)
  res <- NULL

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
    
    message(call_str)

    res <- c(call_str[[2]], call_str[[1]], call_str[[3]], "\n")
    return(res)
    
    #write(c(call_str[[2]], call_str[[1]], call_str[[3]]), file = fileConn, append = TRUE, sep=" ")
  })

  new_file_char <- unlist(new_file_contents)

  writeLines(new_file_char, con = fileConn, sep = " ")

  close(fileConn)


})

