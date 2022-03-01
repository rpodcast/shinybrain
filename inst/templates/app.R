# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)

add_home <- {{create_homepage}}

# source utility scripts ----
#source("shinylearning-utils.R", local = TRUE)

# source module scripts ----
# DO NOT MODIFY!
module_files <- fs::dir_ls(".", regexp = "page*", recurse = TRUE, type = "file")

if (add_home) {
  module_files <- c("home/home.R", "home/home_function.R", module_files)
}

purrr::walk(module_files, ~source(.x))

# create navigation bar UI code ----
page_ids <- ls(name = ".GlobalEnv", pattern = "^page\\d+$")

if (add_home) {
  page_ids <- c("home", page_ids)
}

nav_links <- purrr::map(page_ids, ~gen_navitems(path = ".", active_tab = .x, add_home = add_home))

# launch brochure app ----
page_list <- purrr::map2(page_ids, nav_links, ~rlang::call2(.x, nav_links = .y))
do.call(brochure::brochureApp, page_list)
