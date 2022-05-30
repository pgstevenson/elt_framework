# 99-helper.R
# Storage for helper functions and immutable variables
# Paul Stevenson 30-May-2022

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

extract_xlsx <- function(wd, config, windows = TRUE) {
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

#' name_map
#' @param x a tibble including columns `e_name` and `t_name`
#' @return a named character vector of new colum names with names of old column names
#' @examples 
#' \dontrun{
#' params <- tibble(e_name = c("old", "name"), t_name = c("new", NA))
#' name_map(params)
#' }
name_map <- function(x) {
  d <- setNames(x$t_name, x$e_name)
  d[!is.na(d)]
}