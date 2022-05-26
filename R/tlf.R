library(tidyverse)
library(acbiometrics)

tlf <- tibble(tlf = c("", ""))

save(tlf, file = "data/dat.RData")

tlf %>%
  separate(tlf, into = c("tlf", "title"), sep = "(?<=(\\d{1}\\s))", extra = "merge") %>%
  mutate(across(c("tlf", "title"), trimws),
         across("tlf", str_remove_all, "(\t|\n|\r)")) %>% 
  separate(tlf, into = c("tlf", "number"), sep = "\\s") %>%
  copy_clip()
