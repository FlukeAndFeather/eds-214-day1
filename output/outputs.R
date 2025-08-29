

bq1 <- readRDS("bq1.rds")
bq2 <- readRDS("bq2.rds")
bq3 <- readRDS("bq3.rds")
prm <- readRDS("prm.rds")

source("R/function.R")

df_ca <- readRDS("df_ca.rds")
df_k  <- readRDS("df_k.rds")
df_mg <- readRDS("df_mg.rds")
df_nh4 <- readRDS("df_nh4.rds")
df_no3 <- readRDS("df_no3.rds")


plot_k <- readRDS("plot_k.rds")
print(plot_k)

plot_mg <- readRDS("plot_mg.rds")
print(plot_mg)

plot_ca <- readRDS("plot_ca.rds")
print(plot_ca)

plot_no3 <- readRDS("plot_no3.rds")
print(plot_no3)

plot_nh4 <- readRDS("plot_nh4.rds")
print(plot_nh4)

combined_figure <- readRDS("combined_figure.rds")
print(combined_figure)




