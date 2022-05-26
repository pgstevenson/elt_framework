# 01-main.R
#
# R Environment Initiation for TLF QC activities
# Created by Paul Stevenson, 2021-10-27
#

#### Environment ----

library(tidyverse)
library(acbiometrics)
library(glue)
library(lubridate)

#### helper functions ----

source("R/99-helper.R")

#### Immutable variables ----

# nominal_visits <- c("Screening", "Day -1", "Day 1", "Day 2", "Day 4", "End of Study")
# nominal_timepoints <- c("30 min pre-dose", "30 min", "60 min")
# nominal_treatments <- c("Placebo", "", "")

#### Load data ----

load("data/dat.RData")
data("MedDRA_order")
