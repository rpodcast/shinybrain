library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)
library(plotly)

# source module scripts
source("page1/page1.R")
source("page2/page2.R")

#random_plot <- random_ggplot("bar")

# Creating a navlink
nav_links <- tagList(
  #div(
    #class = "navigationbar",
    tags$ul(
      tags$li(
        tags$a(href = "/", "home"),
      ),
      tags$li(
        tags$a(href = "/page2", "page2"),
      )
    )
  #)
)

page_1 <- function() {
  page(
    href = "/",
    ui = function(request) {
      tagList(
        tags$head(
          tags$style(
            includeCSS("www/navigation.css")
          )
        ),
        page1_ui(root_dir = file.path(here::here(), "page1"))
      )
    },
    server = function(input, output, session) {
      page1_server(input, output, session, root_dir = file.path(here::here(), "page1"))
    }
  )
}

page_2 <- function() {
  page(
    href = "/page2",
    ui =  function(request) {
      tagList(
        tags$head(
          tags$style(
            includeCSS("www/navigation.css")
          )
        ),
        page2_ui()
      )
    },
    server = function(input, output, session) {
      page2_server(input, output, session)
    }
  )
}

brochureApp(
    page_1(),
    page_2()
)