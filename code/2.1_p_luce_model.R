# Libraries
library(ggplot2)
library(ggnewscale)
library(dplyr)
library(data.table)
library(PlackettLuce)
library(pander)

# Sourcing plotting functions
source("./0.3_plotting_functions.R")



##########################
# Fitting plackett luce ## ###################################################
##########################

dat <- read.csv("../data/clean/rank.csv")

pander(dat)

summary(dat)

dat_luce <- as.rankings(dat)

dat_luce

fit <- PlackettLuce(rankings = dat_luce)

# Exporting weight values from model and ordering them
results <- coef(fit, log = F)[order(coef(fit, log = F), decreasing = T)]
pander(results)


ids <- names(results)[1:10]
coef <- unname(results)[1:10]


### Reordering for simple interpretation 
#
# Coefficients are now probability of not being in first place
# 

coef <- (1 - coef)

pander(1 - results)

accepted <- c(rep("Accepted", 3), rep("Rejected", 7))

make_plot_pop(estimate = coef, names = ids, accepted = accepted, model_name = "the Plackett-Luce model")
