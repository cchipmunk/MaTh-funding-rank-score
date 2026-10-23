# Libraries
library(ggplot2)
library(ggnewscale)
library(dplyr)
library(BayesMallows)
library(pander)

# Sourcing plotting functions
source("./0.3_plotting_functions.R")

#####################
### Fitting Mallows ########################################################
#####################

dat <- read.csv("../data/clean/rank.csv")

dat_mallows <- sapply(dat, as.numeric)

pander(dat_mallows)


dat_mallows <- setup_rank_data(rankings = dat_mallows)

test_1 <- compute_mallows(data = dat_mallows,
                          compute_options = set_compute_options(nmc = 5000, burnin = 2000))
assess_convergence(test_1)

# Converges after 1000 iterations --> set burn in to 2000 iterations

fit <- compute_mallows(
          data = dat_mallows,
          compute_options = set_compute_options(nmc = 20000, burnin = 2000, rho_thinning = 10)
          )

assess_convergence(fit)

concensus <- compute_consensus(fit)

results <- reshape(
  concensus, 
  direction = "wide", 
  idvar = "ranking",
  timevar = "cluster",
  varying = list(unique(concensus$cluster)),
  drop = "cumprob")[1:10,]

pander(results)

make_plot_pop(estimate = results$ranking, names = results$`Cluster 1`, model_name = "the Mallows model", 
              accepted = c(rep("Accepted", 3), rep("Rejected", 7)), y_label = "Rank in final ordering", y_lims = c(0,11))

