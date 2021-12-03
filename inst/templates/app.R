# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)

# source module scripts ----
source("page1/page1.R")

# create navigation bar UI code ----
nav_links <- tagList(
  tags$ul(
      tags$li(
      tags$a(href = "/", "home"),
      )
  )
)

# first application wrapper ----
page_1 <- function() {
  page(
    href = "/",
    ui = function(request) {
      tagList(
        tags$head(
          includeCSS("www/navigation.css")
          # tags$style(
          #   includeCSS("www/navigation.css")
          # )
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
brochure::brochureApp(page_1())