install.packages("tidyverse")
install.packages("janitor")
install.packages("readr")
install.packages("lubridate")
install.packages("here")
install.packages("patchwork")
install.packages("palette")

library(tidyverse)
library(janitor)
library(lubridate)
library(patchwork)
library(here)
library(paletteer)

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


names(comb_table) # checking the variables names  


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

# Creating vectors to use in the function

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$k

names(comb_table_subset_date)

# Creating a data set for the potassium concentration

df_k <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_k = sapply(sample_date,
                         moving_average,
                         dates = sample_date,
                         conc = k,
                         win_size_wks = 9))


# Plotting the moving average of the potassium concentration
plot_k <- ggplot(df_k, aes(x = sample_date, y = conc_k, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(0.4, 1.6)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "K mg l⁻¹") +
  theme_minimal()

print(plot_k)


# Creating vectors to use in the function for the nitrate-N

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$no3_n

names(comb_table_subset_date)

# Creating a data set for the nitrate-N concentration

df_no <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_no = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = no3_n,
                          win_size_wks = 9))

# Plotting the moving average of the nitrate-N concentration

plot_no <- ggplot(df_no, aes(x = sample_date, y = conc_no, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(5, 500)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "NO₃-N ug l⁻¹") +
  theme_minimal()

print(plot_no)


# Creating vectors to use in the function for the magnesium

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$mg



# Creating a data set for the magnesium concentration

df_mg <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_mg = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc_mg = mg,
                          win_size_wks = 9))

# Plotting the moving average of the magnesium concentration

plot_mg <- ggplot(df_mg, aes(x = sample_date, y = conc_mg, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 5)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "Mg mg l⁻¹") +
  theme_minimal()

print(plot_mg)

# Creating vectors to use in the function for the calcium 

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$ca

# Creating a data set for the calcium concentration

df_ca <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_ca = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = ca,
                          win_size_wks = 9))

# Plotting the moving average of the calcium concentration

plot_ca <- ggplot(df_ca, aes(x = sample_date, y = conc_ca, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 10)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "Ca mg l⁻¹") +
  theme_minimal()

print(plot_ca)

# Creating vectors to use in the function for the ammonium-N

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$nh4_n

# Creating a data set for the  ammonium-N concentration

df_nh4_n <- comb_table_subset_date %>%
  group_by(site) %>%
  mutate(conc_nh4_n = sapply(sample_date,
                             moving_average,
                             dates = sample_date,
                             conc = nh4_n,
                             win_size_wks = 9))


# Plotting the moving average of the ammonium-N concentration
plot_nh4_n <- ggplot(df_nh4_n, aes(x = sample_date, y = conc_nh4_n, color = site)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 80)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "NH4-N ug l⁻¹") +
  theme_minimal()

print(plot_nh4_n)