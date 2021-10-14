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
nav_links <- tags$ul(
  tags$li(
    tags$a(href = "/", "home"), 
  ),
  tags$li(
    tags$a(href = "/page2", "page2"), 
  )
)

tab_links <- tags$div(
  class = "tabbable",
  tags$ul(
    class = "nav nav-tabs",
    tags$li(
      class = "active",
      tags$a(href = "/", "home", `data-toggle` = "tab", `data-bs-toggle`="tab", `data-value` = "home") 
    ),
    tags$li(
      tags$a(href = "/page2", "page2", `data-toggle` = "tab", `data-bs-toggle`="tab", `data-value` = "page2") 
    )
    # tags$li(
    #   tags$a(href = "/page2", "page2"), 
    # ),
    # tags$li(
    #   tags$a(href = "/contact", "contact"), 
    # )
  )
)

page_1 <- function(){
  page(
    href = "/",
    ui = function(request){
      page1_ui("page1", root_dir = file.path(here::here(), "page1"))
    },
    server = function(input, output, session){
      callModule(page1_server, "page1", root_dir = file.path(here::here(), "page1"))
    }
  )
}

page_2 <- function(){
  page(
    href = "/page2",
    ui =  function(request){
      page2_ui("page2")
    }, 
    server = function(input, output, session){
      callModule(page2_server, "page2")
    }
  )
}

brochureApp(
  # Pages
  page_1(),
  page_2()
)