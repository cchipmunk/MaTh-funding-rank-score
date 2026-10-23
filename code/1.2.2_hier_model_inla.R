# Libraries
library(INLA)
library(data.table)
library(pander)
library(ggplot2)
library(dplyr)
library(ggnewscale)

# Sourcing plotting functions
source("./0.3_plotting_functions.R")


########################
# preprocessing data ###
########################

dat <- read.csv("../data/clean/scores_long.csv")

dat$RandomRevID <- as.character(paste0("x", dat$RandomRevID))
dat$RandomRevID <- as.factor(dat$RandomRevID)
dat$grant_id <- as.factor(dat$grant_id)

pander(dat)



###################################
### With two random effects   #############################################
###################################



# According to INLA documentation "loggamma" is the gamma prior
prec.prior <- list(prec = list(prior = "loggamma", param = c(1.5, 1.5)))

# Model call
fit_inla <- 
  inla(formula = value ~ 1 + f(grant_id, model = "iid", hyper = prec.prior) +
                 f(RandomRevID, model = "iid", hyper = prec.prior), 
                 data = dat, quantiles = c(0.25,0.75))


summary(fit_inla)
plot(fit_inla)


#Object effects and plotting

object_effect <- fit_inla$summary.random$grant_id # Found on my own...

object_effect <- object_effect[order(object_effect$mean),]
object_effect <- object_effect[1:10,]

object_effect

p2 <- make_plot_segment(min = object_effect$`0.75quant`, max = object_effect$`0.25quant`, 
                  estimate = object_effect$mean, names = object_effect$ID, model_name = "the Bayesian hierarchical model for scores (INLA)",
                  intercept_line = object_effect$mean[3], accepted = c(rep("Lottery", 4), rep("Rejected", 6)),
                  ylim = c(-1.2,-0.4))
p2
