## Restarting

# reading and creating clean data frames of the raw data

library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(patchwork)
library(here)


bq1 <- read_csv(here("data/QuebradaCuenca1-Bisley.csv"), na = "-9999", show_col_types = F) %>% 
  clean_names() %>% 
  mutate(site = "BQ1")

bq2 <- read_csv(here("data/QuebradaCuenca2-Bisley.csv"), na = "-9999", show_col_types = F) %>% 
  clean_names() %>% 
  mutate(site = "BQ2")


bq3 <- read_csv(here("data/QuebradaCuenca3-Bisley.csv"), na = "-9999", show_col_types = F) %>% 
  clean_names() %>% 
  mutate(site = "BQ3")


prm <- read_csv(here("data/RioMameyesPuenteRoto.csv"), na = "-9999", show_col_types = F) %>% 
  clean_names() %>% 
  mutate(site ="PRM")



#COMBINING THE SITES AND CLEARNING THE DATA
comb_table <- bind_rows(bq1, bq2, bq3, prm) %>% #since all of the columns are the same, we can combine all of the rows using bind_rows()
  mutate(sample_date = lubridate::ymd(sample_date)) %>% #convert data to ISO format
  mutate(year = lubridate::year(sample_date)) %>% #create new year column
  mutate(month = lubridate::month(sample_date)) %>% #create new month column
  mutate(day = lubridate::day(sample_date))


#select variables of interest
comb_table %>% select(sample_date, sample_id, sample_time, no3_n, k, site, year, month, sample_date) 

# Checking class of the variables   
class(comb_table$no3_n)
class(comb_table$k)
class(comb_table_subset_date$sample_date)
comb_table_subset_date$sample_date <- as.Date(comb_table_subset_date$sample_date)

# filter to months of interest

comb_table_subset_date <- comb_table %>%
  filter(year >= '1988' & year <= '1994')

# Create vectors to use in the function

Dates <- comb_table_subset_date$sample_date

Concentration <- comb_table_subset_date$k

# Creating function of the moving average

moving_ave <- function(focal_date, Dates, Concentration, win_size_wks) {
  
  is_in_window <- (Dates > focol_date - (win_size_wks / 2) * 7) & (Dates > focal_date + (win_size_wks / 2) * 7)

window_conc <- Concentration [is_in_window]

result <- mean(window_conc) 
}



comb_table_subset_date$final_average <- sapply(
  comb_table_subset_date$sample_date,
  moving_ave,
  dates = comb_table_subset_date$sample_date,
  conc = comb_table_subset_date$k,
  win_size_wks = 9
)





