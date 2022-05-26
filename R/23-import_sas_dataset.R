#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

#### Tests ----

# Test if there is at least two arguments: if not, return an error
if (length(args) < 2)
  stop("Two arguments must be supplied (input path and output file)./n", call. = FALSE)

# Check if input path exists: if not, return an error
if (!dir.exists(args[1]))
  stop(paste("Input path does not exist:", args[1], "\n"), call. = FALSE)

#### Import data ----

cat(paste("Importing SAS datasets from:", args[1], "\n"))
dat <- acbiometrics::import_SAS(args[1])

#### Save data ----

cat(paste("Saving data to:", args[2], "\n"))
saveRDS(dat, file = args[2])

#### Finish ----

cat("OK\n")
