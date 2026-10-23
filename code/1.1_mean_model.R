# Libraries
library(pander)
library(ggplot2)
library(ggnewscale)
library(dplyr)

# Sourcing plotting function
source("./0.3_plotting_functions.R")

#################################
### fitting model to the data ######################################################
#################################

dat <- read.csv(file = "../data/clean/scores_long.csv")

ids <- as.character(unique(dat$grant_id))

thetas <- rep(NA, 11)


# Calculating the thetas
for (i in 1:length(ids)){
  thetas[i] <- mean(dat$value[dat$grant_id == ids[i]], na.rm = T)
}

final_dat <- as.data.frame(cbind(ids, thetas))
final_dat$thetas <- as.numeric(final_dat$thetas)

final_dat$thetas <- final_dat$thetas - mean(final_dat$thetas)

# Ordering
final_dat <- final_dat[order(final_dat$thetas, decreasing = F),]
final_dat$ids <- as.character(final_dat$ids)
final_dat$accept <- ifelse(test = final_dat$thetas <= final_dat[3,]$thetas,
                           TRUE, FALSE) 

# Selecting best ten for plot
final_dat <- final_dat[1:10,]


# Making plot
estimate <-final_dat$thetas
names <-final_dat$ids
accepted <- c(rep("Accepted", 3), rep("Rejected", 7))

make_plot_pop(estimate = estimate, names = names,
              model_name = "the mean scores model",
              accepted = accepted,
              y_lims = c(min(estimate*1.2), max(estimate*0.8)))

# Results for table
pander(final_dat)
