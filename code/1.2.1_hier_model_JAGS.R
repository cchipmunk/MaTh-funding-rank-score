library(rjags)
library(pander)
library(coda)
library(gridExtra)
library(ggplot2)
library(ggnewscale)
library(dplyr)

# Sourcing plotting function
source("./0.3_plotting_functions.R")


########################
# Homemade JAGS model  ######################################################
########################

set.seed(42)
dat <- read.csv("../data/clean/scores_long.csv")

dat$RandomRevID <- as.character(paste0("x", dat$RandomRevID))

dat$RandomRevID <- as.factor(dat$RandomRevID)
dat$grant_id <- as.factor(dat$grant_id)

pander(dat)
str(dat)

#
### Defining model ------------------------------------------------------------
#

model_string <- '
  model  {
  
  # Likelihood ---------------------------------------------------------------
  
    for (i in 1:n){
      score[i] ~ dnorm(mu[i], tau_general)
      mu[i] <- overall_m + id_quality[object_id[i]] + ass_effect[assessor[i]]
    }
  
  # Priors for id and ass effect ----------------------------------------------
  
    for(j in 1:n_object){
      id_quality[j] ~ dnorm (0, tau_object)
    }
    
    for(k in 1:n_assessor){
      ass_effect[k] ~ dnorm(0, tau_ass)
    }
  
  
  # Prior for overall_m (uninformed) ----------------------------------------
  
    overall_m ~ dnorm(0, 10^(-3))
    
  # Hyperpriors ------------------------------------------------------------
  
    sigma_g ~ dgamma(1.5,1.5)
    tau_general <- 1 / (sigma_g^2) # Maximal uninformative
    
    sigma_o ~ dgamma(1.5,1.5)
    tau_object <- 1 / (sigma_o^2) # To fit with INLA model
  
    sigma_ass ~ dgamma(1.5,1.5)
    tau_ass <- 1 / (sigma_ass^2) # To fit with INLA model
    
  }

'

# Preparing data 

jags_dat <- list()

jags_dat$score <- dat$value
jags_dat$object_id <- dat$grant_id
jags_dat$assessor <- dat$RandomRevID

jags_dat$n_object <- length(unique(dat$grant_id))
jags_dat$n_assessor <- length(unique(dat$RandomRevID))

jags_dat$n <- length(dat$value)

str(jags_dat)



# Initiate with 10000 samples of adaptive sampling
model <- jags.model(textConnection(model_string),
                    data = jags_dat,
                    n.chains = 4,
                    n.adapt = 10000)

#Burn in 10000 samples
update(model, n.iter = 10000)

#Run the sampling
fit <- coda.samples(model = model,
                    variable.names = c("overall_m",
                                       "id_quality",
                                       "ass_effect",
                                       "sigma_g", "sigma_o", "sigma_ass"),
                    n.iter = 80000,
                    thin = 20)


#
### Convergence  ------------------------------------------------------------
#

# Supress scientific notation and set 3x1 window for plot
options(scipen=999)
par(mfrow = c(1,3))

traceplot(fit)

m.fit <- as.matrix(fit)

# Checking Autocorrelation 
col_ns <- paste0("id_quality[",1:28,"]")
col_ns <- c(col_ns, paste0("ass_effect[",1:10,"]"), "overall_m", "sigma_ass", "sigma_g", "sigma_o")

# For thesis figure run this code instead of full autocorrelation check
# col_ns <- c("id_quality[1]", "id_quality[10]", "overall_m")

for (i in col_ns) {
  sim <- m.fit[,i] 
  acf(sim, main = i, lag.max = 10, ylim = c(0, 0.1), ci = 0)
} 


gelman.diag(fit, autoburnin=F)

raftery.diag(fit)

heidel.diag(fit)


#
### Extracting outputs ------------------------------------------------------------
#


samples <- do.call("rbind", fit)
object_qualities <- samples[,11:38]

quant_25 <- rep(NA,28)
quant_75 <- rep(NA,28)

means <- colMeans(object_qualities)

for (i in 1:28) {
  quant_25[i] <- quantile(object_qualities[,i],0.25)
  quant_75[i] <- quantile(object_qualities[,i],0.75)
}

#In one table
overview <- rbind(means, quant_25, quant_75)
colnames(overview) <- levels(as.factor(jags_dat$object_id))
overview <- (overview[,order(overview[1,])])[,1:10]
pander(overview)


p1 <- make_plot_segment(min = overview[2,], max = overview[3,], estimate = overview[1,],
                  names = colnames(overview), model_name = "the hierarchical model for scores (JAGS)",
                  accepted = c(rep("Lottery",4), rep("Rejected",6)), 
                  intercept_line = overview[1,3],ylims = c(-1.2,-0.4))

p1


#################################
### Figure for Master's Thesis ################################################
#################################
#
# Combined with p2 from INLA script
# Both scripts ran in parallel
#
# Use "ctrl" + "shift" + c" to uncomment multiple lines together


# removing legend from p1 and changing titles
# p1 <- p1 + theme(legend.position="none") + ggtitle("JAGS fit")
# p2 <- p2 + ggtitle("INLA fit")
# grid.arrange(p1, p2, widths = c(1.6,2), 
#               top = textGrob(
#                 "Object qualities according to the Bayesian hierarchical model for scores", gp=gpar(fontsize=18)))
# 