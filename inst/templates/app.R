# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)

# source module scripts ----
# DO NOT MODIFY!
module_files <- fs::dir_ls(".", regexp = "page*", recurse = TRUE, type = "file")
purrr::walk(module_files, ~source(.x))

# create navigation bar UI code ----
nav_links <- tagList(
  tags$ul(
      tags$li(
      tags$a(href = "/", "home"),
      )
  )
)

# first application wrapper ----
page1 <- function() {
  page(
    href = "/",
    ui = function(request) {
      tagList(
        tags$head(
          includeCSS("www/navigation.css")
        ),
        page1_ui()
      )
    },
    server = function(input, output, session) {
      page1_server(input, output, session)
    }
  )
}

# launch brochure app ----
brochure::brochureApp(page1())