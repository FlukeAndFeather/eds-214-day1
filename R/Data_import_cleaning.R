install.packages("tidyverse")
install.packages("janitor")
install.packages("readr")
install.packages("lubridate")
install.packages("here")


library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(here)


source("R/function.R")


# Data frame

bq1 <- read_csv(here("data/QuebradaCuenca1-Bisley.csv")) %>% 
  clean_names() %>% 
  mutate(site = "BQ1")

bq2 <- read_csv(here("data/QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names() %>% 
  mutate(site = "BQ2")


bq3 <- read_csv(here("data/QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names() %>% 
  mutate(site = "BQ3")


prm <- read_csv(here("data/RioMameyesPuenteRoto.csv")) %>% 
  clean_names() %>% 
  mutate(site ="PRM")




# Combining the sites and cleaning the data
comb_table <- bind_rows(bq1, bq2, bq3, prm) %>% 
  mutate(sample_date = lubridate::ymd(sample_date)) %>% 
  mutate(year = lubridate::year(sample_date)) %>% 
  select(sample_date, k, no3_n, mg, ca, nh4_n, site, year)  # selecting variables of interest


names(comb_table) # Checking the variables names  


# Checking class of the variables   
class(comb_table$no3_n)
class(comb_table$k)

# Switching class of nutrients to numeric
comb_table$k <- as.numeric(comb_table$k)
comb_table$no3_n <- as.numeric(comb_table$no3_n)
comb_table$mg <- as.numeric(comb_table$mg)
comb_table$ca <- as.numeric(comb_table$ca)
comb_table$nh4_n <- as.numeric(comb_table$nh4_n)



# Filter to years of interest

comb_table_subset_date <- comb_table %>%
  filter(year >= '1988' & year <= '1994')
