#' Here I'm looking at a metadata driven approach to ELT/ETL.
#' Configuration for all aspects of the analysis is found in config.yml with the
#' intention to be as abstract as possible.
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

config <- yaml.load_file("conf/config.yml")
setwd(config$wd)

source("R/99-helper.R")

#### Pipeline ----

# Step names
lapply(config$steps, function(x) x$name)

# Run pipeline
lapply(config$steps[1], function(step, debug) {
  
  if (!exists(step$type, where = sys.frame(), mode = "function")) return(2)
  
  print(step$name)
  
  if (debug) {
    return(do.call(step$type, list(wd = getwd(), config = step)))
  } else {
    return(system(do.call(step$type, list(wd = getwd(), config = step))))
  }
  
}, debug = FALSE)


#### TO DO ----

# make a requirements file that will install what's needed?
