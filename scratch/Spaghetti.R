library(tidyverse)
library(janitor)
library(readr)
library(lubridate)




BQ1 <- read_csv("data/QuebradaCuenca1-Bisley.csv")
BQ2 <- read_csv("data/QuebradaCuenca2-Bisley.csv")
BQ3 <- read_csv("data/QuebradaCuenca3-Bisley.csv")
PRM <- read_csv("data/RioMameyesPuenteRoto.csv")



View(PRM)


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
  
 

Join_date <- Join_table %>% 
  mutate(date = lubridate::ymd(Sample_Date)) %>%
  mutate(year = year(date),
         month = month(date),
         day = day(date)) 


group_join <- Join_date %>% group_by(year) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

ggplot(data = group_join) +
  geom_line(aes(year, K)) +
  geom_line(aes(year, NH4-N)) +
  geom_line(aes(year, NO3-N)) +
  geom_line(aes(year, Ca)) +
  geom_line(aes(year, Mg))
  labs(title = "Potassium per year",
       x = "Year",
       y = "K")

  names(group_join)
  