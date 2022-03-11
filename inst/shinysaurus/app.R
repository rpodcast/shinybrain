# load packages ----
library(shiny)
library(brochure)
library(shinipsum)
library(DT)
library(ggplot2)

app_title <- "shinysaurus"
bg <- "#18cc00"

# source utility scripts ----
#source("shinylearning-utils.R", local = TRUE)

# source module scripts ----
# DO NOT MODIFY!
module_files <- fs::dir_ls(".", regexp = "page*", recurse = TRUE, type = "file")
module_files <- c("home/home.R", module_files)

purrr::walk(module_files, ~source(.x))

# create navigation bar UI code ----
page_ids <- fs::dir_ls(".", regexp = "page*", type = "directory")
page_ids <- c("home", page_ids)


nav_links <- purrr::map(page_ids, ~gen_navitems(path = ".", active_tab = .x))

# launch brochure app ----
page_list <- purrr::map2(page_ids, nav_links, ~rlang::call2("app_page", nav_links = .y, page_id = .x, title = app_title, bg = bg))
do.call(brochure::brochureApp, page_list)