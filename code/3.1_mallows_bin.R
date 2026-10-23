# Libraries
library(rankrate)
library(reshape2)
library(pander)
library(ggplot2)
library(dplyr)
library(ggnewscale)

# Sourcing plotting functions
source("./0.3_plotting_functions.R")



##################
# Ranking data ################################################################
##################

dat <- read.csv("../data/clean/rank.csv")
pander(dat)

# We add assessor 4 which we removed in cleaning so that the datasets match in size
# We reformulate the structure

ass_1 <- c(19,25,4,16,20,17, rep(NA, 22))
ass_2 <- c(17,25,21,22,4,19, rep(NA, 22))
ass_3 <- rep(NA, 28)
ass_4 <- c(25,19,17,20,13,16, rep(NA, 22))
ass_5 <- c(17,25,19,21,13,16, rep(NA, 22))
ass_6 <- c(25,17,19,21,4,23, rep(NA, 22))
ass_7 <- c(17,23,25,19,4,3, rep(NA, 22))
ass_8 <- c(19,25,17,21,4,23, rep(NA, 22))
ass_9 <- c(17,21,19,25,4,22, rep(NA, 22))
ass_10 <- c(19,21,4,23,20,17, rep(NA, 22))

dat_ranks <- rbind(ass_1,ass_2,ass_3,ass_4,ass_5,ass_6,ass_7,ass_8,ass_9,ass_10)
dat_ranks <- as.matrix(dat_ranks)

dat_ranks

##################
# Scoring data ### ############################################################
##################

dat <- read.csv("../data/clean/scores.csv")
dat <- dat[,-1]


# We apply the same transformation as done in the paper by Gallo et al.
dat_scores <- sapply(dat, function(x){(x-1)*10})



##########################
### Fitting the data #########################################
##########################


MLE_mb <- fit_mb(rankings=dat_ranks,
                 ratings=dat_scores,
                 M=40,method="ASTAR")

# Complicated syntax but basically joining results together in one dataframe
res <- rbind(paste0("x",MLE_mb$pi0[1,][1:10]), seq(1,10), round(MLE_mb$p[1,MLE_mb$pi0[1,][1:10]],3))

rownames(res) <- c("Proposal", "rank", "theta")
pander(res)

# Concensus parameter
round(MLE_mb$theta[1,],2)


################################
# Confidence and plot on Ranks #######################################################
################################


CI_fit <- ci_mb(rankings=dat_ranks,
                ratings=dat_scores,
                M=40,
                method="ASTAR",
                interval = .5, 
                nsamples = 50)


top_10 <- MLE_mb$pi0[1,][1:10]

min <- unname(CI_fit$ci_ranks[1,])[top_10]
max <- unname(CI_fit$ci_ranks[2,])[top_10]
estimate <- order(MLE_mb$pi0[1,])[top_10]

accepted <- estimate
accepted[accepted > 3] <-"Rejected"
accepted[accepted <= 3] <-"Accepted"

names <- paste0("x", top_10)


make_plot_segment(min = max, max = min, estimate = estimate, names =names, model_name = "the Mallows-Binomial model",
                  accepted, ylims = c(0,10.8), intercept_line = 3, y_label = "Rank in final ordering")



################################
# Confidence and plot on scores #######################################################
################################
# 
# Use "ctrl" + "shift" + c" to uncomment multiple lines together
# 


# top_10 <- MLE_mb$pi0[1,][1:10]
# 
# min <- unname(CI_fit$ci[1,])[top_10]
# max <- unname(CI_fit$ci[2,])[top_10]
# estimate <- (MLE_mb$p[1,])[top_10]
# 
# accepted <- c(rep("Accepted", 3), rep("Rejected",7))
# 
# names <- paste0("x", top_10)
# 
# 
# make_plot_segment(min = max, max = min, estimate = estimate, names =names, model_name = "Mallows-binomial",
#                   accepted, ylims = c(0,0.25), intercept_line = estimate[3])
