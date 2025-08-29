

library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(here)


source("R/function.R")



# Data frame

bq1 <- read_csv(here("data/QuebradaCuenca1-Bisley.csv")) %>% 
  clean_names()

bq2 <- read_csv(here("data/QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names()


bq3 <- read_csv(here("data/QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names()


prm <- read_csv(here("data/RioMameyesPuenteRoto.csv")) %>% 
  clean_names() 


saveRDS(bq1, "output/bq1.rds")
saveRDS(bq2, "output/bq2.rds")
saveRDS(bq3, "output/bq3.rds")
saveRDS(prm, "output/prm.rds")

# Combining the sites and cleaning the data
combine_tables <- bind_rows(bq1, bq2, bq3, prm) %>% 
  mutate(sample_date = lubridate::ymd(sample_date)) %>% 
  mutate(year = lubridate::year(sample_date)) %>% 
  select(sample_date, k, no3_n, mg, ca, nh4_n, sample_id, year)  # selecting variables of interest


names(combine_tables) # Checking the variables names  


# Checking class of the variables   
class(combine_tables$no3_n)
class(combine_tables$k)

# Switching class of nutrients to numeric
combine_tables$k <- as.numeric(combine_tables$k)
combine_tables$no3_n <- as.numeric(combine_tables$no3_n)
combine_tables$mg <- as.numeric(combine_tables$mg)
combine_tables$ca <- as.numeric(combine_tables$ca)
combine_tables$nh4_n <- as.numeric(combine_tables$nh4_n)

saveRDS(combine_tables, "output/combine_tables")

# Filter to years of interest

subset_date <- combine_tables %>%
  filter(year >= '1988' & year <= '1994')

saveRDS(subset_date, "output/combine_tables")


