install.packages("tidyverse")
install.packages("janitor")
install.packages("readr")
install.packages("lubridate")
install.packages("here")
install.packages("patchwork")
install.packages("palette")


library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(patchwork)
library(here)
library(paletteer)

source("R/function.R")

# Storing, reading, and cleaning data

bq1 <- read_csv(here("data/QuebradaCuenca1-Bisley.csv")) %>% 
  clean_names()

bq2 <- read_csv(here("data/QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names()


bq3 <- read_csv(here("data/QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names()


prm <- read_csv(here("data/RioMameyesPuenteRoto.csv")) %>% 
  clean_names() 




# Combining the sites and cleaning the data
comb_table <- bind_rows(bq1, bq2, bq3, prm) %>% 
  mutate(sample_date = lubridate::ymd(sample_date)) %>% 
  mutate(year = lubridate::year(sample_date)) %>% 
  select(sample_date, k, no3_n, mg, ca, nh4_n, sample_id, year)  # selecting variables of interest


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

# Creating vectors to use in the function

dates <- comb_table_subset_date$sample_date

conc <- comb_table_subset_date$k

names(comb_table_subset_date)

# Creating a data set for the potassium concentration

df_k <- comb_table_subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_k = sapply(sample_date,
                         moving_average,
                         dates = sample_date,
                         conc = k,
                         win_size_wks = 9))


# Plotting the moving average of the potassium concentration
plot_k <- ggplot(df_k, aes(x = sample_date, y = conc_k, color = sample_id)) +
  geom_line() + 
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(0.4, 1.6)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = NULL,
       y = "K mg l⁻¹",
       color = "Site") +
  theme_minimal()

print(plot_k)

# Creating a data set for the nitrate-N concentration

df_no <- comb_table_subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_no = sapply(sample_date,
                         moving_average,
                         dates = sample_date,
                         conc = no3_n,
                         win_size_wks = 9))

# Plotting the moving average of the nitrate-N concentration

plot_no <- ggplot(df_no, aes(x = sample_date, y = conc_no, color = sample_id)) +
  geom_line() + 
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(5, 500)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = NULL,
       y = "NO₃-N ug l⁻¹",
       color = NULL) +
  theme_minimal() + 
  theme(legend.position = "none")

print(plot_no)


# Creating a data set for the magnesium concentration

df_mg <- comb_table_subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_mg = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = mg,
                          win_size_wks = 9))

# Plotting the moving average of the magnesium concentration

plot_mg <- ggplot(df_mg, aes(x = sample_date, y = conc_mg, color = sample_id)) +
  geom_line() + 
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(0, 5)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = NULL,
       y = "Mg mg l⁻¹") +
  theme_minimal() + 
  theme(legend.position = "none")

print(plot_mg)


# Creating a data set for the calcium concentration

df_ca <- comb_table_subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_ca = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = ca,
                          win_size_wks = 9))

# Plotting the moving average of the calcium concentration

plot_ca <- ggplot(df_ca, aes(x = sample_date, y = conc_ca, color = sample_id)) +
  geom_line() +
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(0, 10)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = NULL,
       y = "Ca mg l⁻¹") +
  theme_minimal() + 
  theme(legend.position = "none")

print(plot_ca)

# Creating a data set for the  ammonium-N concentration

df_nh4_n <- comb_table_subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_nh4_n = sapply(sample_date,
                         moving_average,
                         dates = sample_date,
                         conc = nh4_n,
                         win_size_wks = 9))


# Plotting the moving average of the ammonia concentration
plot_nh4_n <- ggplot(df_nh4_n, aes(x = sample_date, y = conc_nh4_n, color = sample_id)) +
  geom_line() +
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(0, 80)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "NH4-N ug l⁻¹") +
  theme_minimal() + 
  theme(legend.position = "none")

print(plot_nh4_n)

combined_figure <- plot_k / plot_no / plot_mg / plot_ca / plot_nh4_n
print(combined_figure)


# Saving combined figures
ggsave(
  filename = here("figures", "combined_figures.jpg"),
  plot = combined_figure,
  width = 10,
  height = 14,
  dpi = 300
)

