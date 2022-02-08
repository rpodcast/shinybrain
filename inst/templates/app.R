# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)

# source utility scripts ----
source("shinylearning-utils.R", local = TRUE)

# source module scripts ----
# DO NOT MODIFY!
module_files <- c("home/home.R", "home/home_function.R", fs::dir_ls(".", regexp = "page*", recurse = TRUE, type = "file"))
purrr::walk(module_files, ~source(.x))

# create navigation bar UI code ----
page_ids <- c("home", ls(name = ".GlobalEnv", pattern = "^page\\d+$"))
nav_links <- purrr::map(page_ids, ~gen_navbar(path = ".", active_tab = .x, add_home = TRUE))

# launch brochure app ----

page_list <- purrr::map2(page_ids, nav_links, ~rlang::call2(.x, nav_links = .y))
do.call(brochure::brochureApp, page_list)
#do.call(brochure::brochureApp, list(page1(nav_links)))
#brochure::brochureApp(page1())