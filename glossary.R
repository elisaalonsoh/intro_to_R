
library(tidyverse)
library(readxl)

functions <- read_xlsx(file.path(getwd(), "functions.xlsx"))

# Get the last R documentation version of each package
packages <- functions %>% select(package) %>% unique()
version <- lapply(packages$package, function(a) {
  return(gsub('^.*versionsArray":\\["|".*$', '', 
              paste(readLines(paste0('https://www.rdocumentation.org/packages/',  a)), collapse = "")))
})

# Get the alias of each function
lapply(packages$package, require, character.only = TRUE)
alias <- lapply(functions$`function`, function(a) {
  hf <- as.character(help(a))
  keep <- grepl(paste0(functions %>% filter(`function` == a) %>% pull(package), "/help"), hf)
  return(gsub("^.*/", "", hf[keep]))
})

# Form URL
functions <- functions %>%
  left_join(packages %>% mutate(version = unlist(as.character(version)))) %>%
  mutate(alias = unlist(alias)) %>%
  mutate(doc = paste0("https://www.rdocumentation.org/packages/", package, 
                      "/versions/", version, 
                      "/topics/", alias))

