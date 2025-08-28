## Restarting

library(lubridate)
library(patchwork)
library(here)
library(paletteer)

comb_table %>% select(sample_date, sample_id, sample_time, no3_n, k, site, year, month) %>%
  
  
  comb_table$k <- as.numeric(comb_table$k)

dates <- comb_table_subset_date$sample_date
conc <- comb_table_subset_date$k


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

print(plot_k)



#_______________________





