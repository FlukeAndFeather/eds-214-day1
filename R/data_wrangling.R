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
  clean_names()

bq2 <- read_csv(here("data/QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names()


bq3 <- read_csv(here("data/QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names()


prm <- read_csv(here("data/RioMameyesPuenteRoto.csv")) %>% 
  clean_names() 


saveRDS(bq1, "bq1.rds")
saveRDS(bq2, "bq2.rds")
saveRDS(bq3, "bq3.rds")
saveRDS(prm, "prm.rds")

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

saveRDS(combine_tables, "combine_tables")

# Filter to years of interest

subset_date <- combine_tables %>%
  filter(year >= '1988' & year <= '1994')

saveRDS(subset_date, "combine_tables")


# Creating vectors to use in the function

dates <- subset_date$sample_date

conc <- subset_date$k

names(subset_date)

# Creating a data set for the potassium concentration

df_k <- subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_k = sapply(sample_date,
                         moving_average,
                         dates = sample_date,
                         conc = k,
                         win_size_wks = 9))

saveRDS(df_k, "df_k.rds")

## Applying the function to the nitrate-N concentration


# Creating vectors to use in the function for the nitrate-N

dates <- subset_date$sample_date

conc <- subset_date$no3_n

names(subset_date)

# Creating a data set for the nitrate-N concentration

df_no3 <- subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_no = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = no3_n,
                          win_size_wks = 9))

saveRDS(df_no3, "df_no3.rds")

#### Applying the function to the magnesium concentration


# Creating vectors to use in the function for the magnesium

dates <- subset_date$sample_date

conc <- subset_date$mg



# Creating a data set for the magnesium concentration

df_mg <- subset_date %>%
  group_by(sample_id) %>%
  mutate(conc_mg = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = mg,
                          win_size_wks = 9))
saveRDS(df_mg, "df_mg.rds")


#### Applying the function to the calcium concentration


# Creating vectors to use in the function for the calcium 

dates <- subset_date$sample_date

conc <- subset_date$ca

# Creating a data set for the calcium concentration

df_ca <- subset_date%>%
  group_by(sample_id) %>%
  mutate(conc_ca = sapply(sample_date,
                          moving_average,
                          dates = sample_date,
                          conc = ca,
                          win_size_wks = 9))

saveRDS(df_ca, "df_ca.rds")


#### Applying the function to the ammonia-N


# Creating vectors to use in the function for the ammonia-N

dates <- subset_date$sample_date

conc <- subset_date$nh4_n

# Creating a data set for the  ammonium-N concentration

df_nh4 <- subset_date%>%
  group_by(sample_id) %>%
  mutate(conc_nh4_n = sapply(sample_date,
                             moving_average,
                             dates = sample_date,
                             conc = nh4_n,
                             win_size_wks = 9))
saveRDS(df_nh4, "df_nh4.rds")


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
  theme_minimal() +
  theme(
    axis.title = element_text(size = 14),               
    axis.text  = element_text(size = 12),                  
    legend.title = element_text(size = 13),               
    legend.text  = element_text(size = 11)               
  )


print(plot_k)

ggsave("plot_k.png", plot_k)

saveRDS(plot_k, "plot_k.rds")

# Plotting the moving average of the nitrate-N concentration

plot_no3 <- ggplot(df_no3, aes(x = sample_date, y = conc_no, color = sample_id)) +
  geom_line() + 
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(5, 500)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = NULL,
       y = "NO₃-N ug l⁻¹",
       color = NULL) +
  theme_minimal() + 
  theme(legend.position = "none")  +
  theme(
    axis.title = element_text(size = 14),                  
    axis.text  = element_text(size = 12),                  
  )



plot(plot_no3)

ggsave("plot_no3.png", plot_no3)
saveRDS(plot_no3, "plot_no3.rds")






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
  theme(legend.position = "none")  +
  theme(
    axis.title = element_text(size = 14),                  
    axis.text  = element_text(size = 12),                  
  )


plot(plot_ca)

ggsave("plot_ca.png", plot_ca)
saveRDS(plot_ca, "plot_ca.rds")


# Plotting the moving average of the ammonia concentration

plot_nh4 <- ggplot(df_nh4, aes(x = sample_date, y = conc_nh4_n, color = sample_id)) +
  geom_line() +
  geom_vline(xintercept = as.Date("1989-09-20"), 
             linetype = "dashed", color="black") +
  scale_y_continuous(limits = c(0, 80)) +
  scale_color_paletteer_d("wesanderson::Darjeeling2") +
  labs(title, x = "Year",
       y = "NH4-N ug l⁻¹") +
  theme_minimal() + 
  theme(legend.position = "none") +
  theme(
    axis.title = element_text(size = 14),                  
    axis.text  = element_text(size = 12),                  
                    )

plot(plot_nh4)

ggsave("plot_nh4.png", plot_nh4 )
saveRDS(plot_nh4, "plot_nh4.rds")


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
  theme(legend.position = "none") +
  theme(
    axis.title = element_text(size = 14),                  
    axis.text  = element_text(size = 12),                  
  )

print(plot_mg)

ggsave("plot_nmg.png", plot_mg)

saveRDS(plot_mg, "plot_mg.rds")



combined_figure <- plot_k / plot_no3 / plot_mg / plot_ca / plot_nh4
plot(combined_figure)



# Saving combined figures
ggsave(
  filename = here("figures", "combined_figure.jpg"),
  plot = combined_figure,
  width = 10,
  height = 13,
  dpi = 300
)

saveRDS(combined_figure, "combined_figure.rds")


