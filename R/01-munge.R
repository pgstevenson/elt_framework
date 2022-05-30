#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

#### Test ----

# Test if there is at least two arguments: if not, return an error
if (length(args) < 2)
  stop("Two arguments must be supplied (input files and output file)./n", call. = FALSE)

files <- unlist(strsplit(args[1], ",", fixed = TRUE))

# Check if all input files exists: if not, return an error
if (!all(vapply(files, file.exists, logical(1))))
  stop(paste("One or more input files do not exist\n"), call. = FALSE)

#### Environment ----

library(dplyr)
library(labelled)
library(lubridate)
library(purrr)

source("R/99-helper.R")

#### Data import ----

for (i in 1:length(files)) {
  x <- unlist(strsplit(files[i], "//"))
  file_name <- sub(".RDS", "", x[length(x)])
  assign(file_name, readRDS(files[i]))
}

#### Import data dictionary parameters ----

dict <- yaml.load_file("conf/00_dictionary_template.yml")
params <- map_dfr(dict$parameters, as.data.frame)

#### Data wrangling ----

# TO DO:
#  - Look for outliers/errors/unexpected values
#  - Add labels with labelled::

# Clean per data dictionary definitions

# what happens if there are no categorical/date variables??
factor_levels <- lapply(setNames(strsplit(params[params$type == "categorical" & !is.na(params$type),]$levels, ","),
                                 set_names(params[params$type == "categorical" & !is.na(params$type),]$e_name)), trimws)

date_formats <- setNames(params[params$type == "date" & !is.na(params$type),]$format,
                         params[params$type == "date" & !is.na(params$type),]$e_name)

example1 <- example1 %>%
  mutate(across(params[params$type == "numeric" & !is.na(params$type),]$e_name, as.numeric),
         across(params[params$type == "boolean" & !is.na(params$type),]$e_name, as.logical),
         across(starts_with(paste0(params[params$type == "checkbox" & !is.na(params$type),]$e_name, "_")),
                ~as.logical(as.numeric(.))),
         across(params[params$type == "categorical" & !is.na(params$type),]$e_name,
                ~factor(., levels = factor_levels[[cur_column()]])),
         mutate(across(params[params$type == "date" & !is.na(params$type),]$e_name, ~match.fun(date_formats[[cur_column()]])(.x)))) %>%
  set_names(~ifelse(. %in% names(name_map(params)), name_map(params)[.], .))

# nest checkbox parameters
for (i in params[params$type == "checkbox" & !is.na(params$type),]$e_name) {
  example1 <- nest(example1, !!sym(i) := starts_with(paste0(i, "_")), .names_sep = "_")
}

#### Save data ----

save(dat, file = args[2])

