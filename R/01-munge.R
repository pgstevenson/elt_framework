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

#### Data import ----

for (i in 1:length(files)) {
  x <- unlist(strsplit(files[i], "//"))
  file_name <- sub(".RDS", "", x[length(x)])
  assign(file_name, readRDS(files[i]))
}

#### Data wrangling ----

dat <- etl

# Calculated cohort size of analysis sets

safety_N <- NULL

# safety_N <- adam$dat$ADSL %>%
#   SUBJID_COHORT() %>%
#   filter(SAFFL == "Y") %>%
#   select(SUBJID, COHORT) %>%
#   group_by(COHORT) %>%
#   summarise(n = n()) %>%
#   as.vector() %>%
#   deframe()

#### Save data ----

save(dat, rand, sets, safety_N, file = args[2])
