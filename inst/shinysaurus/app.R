# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(dplyr)
library(DT)
library(ggplot2)
library(sortable)
library(metamer)
library(plotly)

app_title <- "shinysaurus"
bg <- "#007bff"

# source utility scripts ----
#source("shinylearning-utils.R", local = TRUE)

# source module scripts ----
# DO NOT MODIFY!
module_dirs <- fs::dir_ls(".", regexp = "page*", recurse = FALSE, type = "directory")
module_files <- fs::dir_ls(module_dirs, glob = "page*.R", recurse = TRUE, type = "file")
module_files <- c("home/home.R", module_files)

purrr::walk(module_files, ~source(.x))

# create navigation bar UI code ----
page_ids <- fs::dir_ls(".", regexp = "page*", type = "directory")
page_ids <- c("home", page_ids)
nav_links <- purrr::map(page_ids, ~gen_navitems(path = ".", active_tab = .x))
theme_list <- purrr::map(page_ids, ~rlang::call2(glue::glue("{p}_theme", p = .x)))

# launch brochure app ----
arg_list <- list(
  page_ids,
  nav_links,
  theme_list,
  app_title,
  bg
)
#page_list <- purrr::map2(page_ids, nav_links, ~rlang::call2("app_page", nav_links = .y, page_id = .x, title = app_title, bg = bg))
page_list <- purrr::pmap(arg_list, ~rlang::call2("app_page", nav_links = ..2, page_id = ..1, custom_theme = ..3, title = ..4, bg = ..5))
do.call(brochure::brochureApp, page_list)
