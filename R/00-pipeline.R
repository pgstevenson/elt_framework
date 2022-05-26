#' Here I'm looking at a metadata driven approach to creating TFLs.
#' Configuration for all aspects of the analysis is found in config.yml with the
#' intention to be as abstract as possible.
#' 
#' The main task left to work out is create a mapping table to connect data set
#' variables against pre-defined variables used in the TFL dat aset generation
#' files. This should save a lot of time moving forward.
#' 
#' Created by Paul Stevenson 26-May-2022
#' 


#### Exit status key ----

c(`0` = "OK",
  `1` = "System call error",
  `2` = "Function not found")

#### Environment ----

library(yaml)
library(glue)

config <- yaml.load_file("config.yml")

setwd(config$wd)

#### Helper functions ----

extract_etl <- function(wd, config, windows = TRUE) {
  d <- glue('Rscript --vanilla "{wd}/R/{config$code}" "{config$path}" "{wd}/data/{config$output}"')
  if (!windows) return(d)  
  gsub("/", "\\\\", d)
}

extract_xls <- function(wd, config, windows = TRUE) {
  d <- glue('Rscript --vanilla "{wd}/R/{config$code}" "{config$input}" "{wd}/data/{config$output}"')
  if (!windows) return(d)
  gsub("/", "\\\\", d)
}

listing_data <- function(wd, config, windows = TRUE) {
  d <- vector(mode = "character", length = length(config$number))
  for (i in 1:length(config$number)) {
    d[i] <- glue('Rscript --vanilla "{wd}/analysis/Programs/Listings/{config$number[i]}.R" "{wd}" {config$number[i]}')
  }
  d
}

transform_data <- function(wd, config, windows = TRUE) {
  files <- paste(sapply(config$input, function(x) paste(wd, "data", x, sep = "/")), collapse = ",")
  d <- glue('Rscript --vanilla "{wd}/R/{config$code}" "{files}" "{wd}/data/{config$output}"')
  if (!windows) return(d)  
  gsub("/", "//", d)
}

#### Pipeline ----

# Step names
lapply(config$steps, function(x) x$name)

# Run pipeline
lapply(config$steps[5], function(step, debug) {
  
  if (!exists(step$type, where = sys.frame(), mode = "function")) return(2)
  
  print(step$name)
  
  if (debug) {
    return(do.call(step$type, list(wd = wd, config = step)))
  } else {
    return(system(do.call(step$type, list(wd = wd, config = step))))
  }
  
}, debug = T)

config$steps[[5]]$number
