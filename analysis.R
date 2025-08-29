
library(tidyverse)
library(janitor)
library(readr)
library(lubridate)
library(patchwork)
library(here)
library(paletteer)



bq1 <- readRDS("output/bq1.rds")
bq2 <- readRDS("output/bq2.rds")
bq3 <- readRDS("output/bq3.rds")
prm <- readRDS("output/prm.rds")

source("R/function.R")

df_ca <- readRDS("output/df_ca.rds")
df_k  <- readRDS("output/df_k.rds")
df_mg <- readRDS("output/df_mg.rds")
df_nh4 <- readRDS("output/df_nh4.rds")
df_no3 <- readRDS("output/df_no3.rds")


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

ggsave("figures/plot_k.png", plot_k)


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

ggsave("figures/plot_no3.png", plot_no3)




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

ggsave("figures/plot_ca.png", plot_ca)



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

ggsave("figures/plot_nh4.png", plot_nh4 )



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

ggsave("figures/plot_mg.png", plot_mg)



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

saveRDS(combined_figure, "output/combined_figure.rds")

