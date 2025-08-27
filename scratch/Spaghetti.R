library(tidyverse)
library(janitor)
library(readr)
library(lubridate)

source("R/function.R")


BQ1 <- read_csv("data/QuebradaCuenca1-Bisley.csv")
BQ2 <- read_csv("data/QuebradaCuenca2-Bisley.csv")
BQ3 <- read_csv("data/QuebradaCuenca3-Bisley.csv")
PRM <- read_csv("data/RioMameyesPuenteRoto.csv")



names(PRM)


# Data frame

data_frame_prm <- PRM %>% 
  select("Sample_Date", "K", "NH4-N", "NO3-N", "Ca", "Mg") 


data_frame_BQ1 <- BQ1 %>% 
  select("Sample_Date", "K", "NH4-N", "NO3-N", "Ca", "Mg") 

data_frame_BQ2 <- BQ2 %>% 
  select("Sample_Date", "K", "NH4-N", "NO3-N", "Ca", "Mg") 

data_frame_BQ3 <- BQ3 %>% 
  select("Sample_Date", "K", "NH4-N", "NO3-N", "Ca", "Mg") 


PRM_date <- data_frame_prm %>% 
  mutate(date = lubridate::ymd(Sample_Date)) %>%
  mutate(year = year(date),
         month = month(date),
         day = day(date))


group_PRM <- PRM_date %>% group_by(year) %>%
summarise(across(where(is.numeric), mean, na.rm = TRUE))


ggplot(data = group_PRM, aes(year, K)) +
  geom_line() +
  labs(title = "Potassium per year",
       x = "Year",
       y = "K")



Join_table <- data_frame_prm %>% 
  full_join(data_frame_BQ1, join_by(Sample_Date)) %>%
  full_join(data_frame_BQ2) %>% 
  full_join(data_frame_BQ3)
  
 

df_date <- Join_table %>% 
  mutate(date = lubridate::ymd(Sample_Date)) %>%
  mutate(year = year(date),
         month = month(date),
         day = day(date)) 


group_join <- Join_date %>% group_by(year) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

ggplot(data_frame_BQ1 = group_join) +
  geom_line(aes(year, K)) +
  geom_line(aes(year, NH4-N)) +
  geom_line(aes(year, NO3-N)) +
  geom_line(aes(year, Ca)) +
  geom_line(aes(year, Mg))
  labs(title = "Potassium per year",
       x = "Year",
       y = "K")

  names(group_join)
  
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
  comb_table %>% select(sample_date, sample_id, sample_time, no3_n, k, site, year, month, str_ym_date) 
  
  # Checking class of the variables   
  class(comb_table$no3_n)
  class(comb_table$k)
  
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
  
  
  