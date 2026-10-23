# Libraries
library(ggplot2)
library(ggnewscale)
library(dplyr)
library(psych)
library(pander)
library(RColorBrewer)

# Sourcing plotting functions
source("./0.3_plotting_functions.R")

#########################
### Fitting Thurstonian ########################################################
#########################


dat <- read.csv("../data/clean/rank.csv")

t <- thurstone(dat, ranks = T)



res <- rbind(- as.numeric(t$scale))
colnames(res) <- colnames(dat)
res 

res <- res[,order(t$scale, decreasing = T)]

res <- res[1:10]

pander(res)

names(res)
unname(res)

make_plot_pop(estimate = unname(res), names = names(res), 
              model_name = "the Thurstonian model", y_label = "latent quality",
              accepted = c(rep("Accepted",3), rep("Rejected",7)), y_lims = c(min(1.2*unname(res)), max(0.8*unname(res))))



# Visualisation of estimated distributions

colo <-brewer.pal(n = 10, name = "Set3")

curve(dnorm(x = x, mean = res[1], sd = 1), from = -6, to = 3, n = 5000, 
      col = colo[1], ylim = c(0,0.5))

for (i in 2:10) {
  curve(dnorm(x = x, mean = res[i], sd = 1), from = -5, to = 5, n = 5000, add = T, col = colo[i] )
}

