library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(patchwork)
library(here)
library(paletteer)

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


plot_K <- ggplot (data = group_PRM, aes(year, K)) +
  geom_line() +
  labs(title = "Potassium per year",
       x = "Year",
       y = "K") +
  



Join_table <- data_frame_prm %>% 
  full_join(data_frame_BQ1, join_by(Sample_Date)) %>%
  full_join(data_frame_BQ2) %>% 
  full_join(data_frame_BQ3)
  
 

df_date <- Join_table %>% 
  mutate(date = lubridate::ymd(Sample_Date)) %>%
  mutate(year = year(date),
         month = month(date),
         day = day(date)) 

# Trying to convert month and to to character so it doesn't turn into mean values 

Join_date %>% as.character(month, day)

class(Join_date$month)

Join_date_cha <- as.character(Join_date$month)

group_join <- Join_date %>% group_by(year) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))


ggplot(data = Join_date) +
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
  

  
  ggplot(data = group_join) +
    geom_line(aes(year, K)) +
    geom_line(aes(year, K.y)) +
    geom_line(aes(year, K.x))
  
  
  


  
  
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
  comb_table %>% select(sample_date, sample_id, sample_time, no3_n, k, site, year, month) %>%
    
  
  comb_table$k <- as.numeric(comb_table$k)
  
  # Checking class of the variables   
  class(comb_table$no3_n)
  class(comb_table$k)
  

  
 
  
  
  # filter to months of interest
  
  comb_table_subset_date <- comb_table %>%
    filter(year >= '1988' & year <= '1994')
  
  # Create vectors to use in the function
  
  dates <- comb_table_subset_date$sample_date
  
  conc <- comb_table_subset_date$k
  
  # calling function of the moving average

  

  
k_ma <- comb_table_subset_date$final_average <- sapply(
comb_table_subset_date$sample_date,
moving_average,
dates = comb_table_subset_date$sample_date,
conc = comb_table_subset_date$k,
win_size_wks = 9
  )
  
  view(k_ma)
 
  class(df_k$year)
  class(comb_table$k)  
   
  
df_k <- comb_table_subset_date %>% select(site, sample_date, year) %>% 
  mutate(conc_k = k_ma) %>% 
  group_by(site, year) %>% 
  summarise(conc_k = mean(conc_k, na.rm = TRUE), .groups = "drop")

ggplot(df_k, aes(x =year, y = conc_k, color = site, group = site)) +
  geom_line() +
  labs(title = "Potassium per year",
       x = "Year",
       y = "K")


df_k <- df_k %>%
  group_by(site, sample_date) %>%
  summarise(conc_k = mean(conc_k, na.rm = TRUE), .groups = "drop")

ggplot(df_k, aes(x = sample_date, y = conc_k, color = site)) +
  geom_line() +
  facet_wrap(~ site, scales = "free_y")

ggplot(df_k, aes(x = sample_date, y = conc_k, color = site, group = site)) +
  geom_line() +
  labs(title = "Potassium per year",
       x = "Year",
       y = "K")

moving_ave <- function(focal_date, dates, conc, win_size_wks) {
  is_in_window <- (dates > focal_date - (win_size_wks/2) * 7) &
    (dates < focal_date + (win_size_wks/2) * 7)
  window_conc <- conc[is_in_window]
  mean(window_conc, na.rm = TRUE)
}

df_k <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_k = sapply(sample_date,
                         moving_ave,
                         dates = sample_date,
                         conc = k,
                         win_size_wks = 9))

plot_k <- ggplot(df_k, aes(x = sample_date, y = conc_k, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(0.4, 1.6)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "K mg l⁻¹") +
  theme_minimal()
