library(INLA)
library(INLAjoint)



###
### Binomial + gaussian
###
# 
# dat_scores <- read.csv("../data/clean/scores_long.csv")
# dat_ranks <- read.csv("../data/clean/rank_full_long.csv")
# 
# 
# dat_ranks$value[is.na(dat_ranks$value)] <- 7
# dat_ranks$value[dat_ranks$value <= 3] <- 1
# dat_ranks$value[dat_ranks$value >= 4] <- 0
# 
# dat_joint <- dat_scores
# 
# dat_joint$value_rank <- rep(NA, 280)
# 
# 
# dat_joint$value_rank[dat_joint$RandomRevID %in% unique(dat_ranks$RandomRevID)] <-
#   dat_ranks$value
# 
# dat_joint$grant_id <- as.numeric(gsub('x', replacement =  "", dat_joint$grant_id))
# 
# str(dat_joint)
# 
# M_multi <- joint(
#   formLong = list(
#     value   ~ 1 + (1 | grant_id),
#     value_rank  ~ 1 + (1 | grant_id)
#   ),
#   dataLong = dat_joint, id = "grant_id",
#   family  = c("gaussian", "binomial"),
#   corLong = TRUE)
# 
# 
# summary(M_multi, sdcor = TRUE)
# 
# object_effect_rank <- M_multi$summary.random$IDIntercept_L1[29:56,]
# object_effect_score <- M_multi$summary.random$IDIntercept_L1[1:28,]
# 
# object_effect <- object_effect_score
# object_effect <- object_effect[order(object_effect$mean),]
# object_effect <- object_effect[1:10,]
# 
# 
# pander(object_effect)
# 
# widths_s_r_bin <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# info <- M_multi$marginals.random$IDIntercept_L1$index.17
# 
# 
# plot(M_multi$marginals.random$IDIntercept_L1$index.17)
# 
# quantile(M_multi$marginals.random$IDIntercept_L1$index.17[,1], probs = c(0.025,0.975))
# 
# 
# 
# 
# make_plot_segment(min = object_effect$`0.975quant`, max = object_effect$`0.025quant`, 
#                   estimate = object_effect$mean, ylims = c(-2,0), names = object_effect$ID, model_name = "the INLA hierarchical model",
#                   intercept_line = object_effect$mean[3], accepted = c(rep("Lottery", 8), rep("Rejected", 2)))
# 
# 
# 
# ###
# ### gaussian + gaussian
# ###
# 
# 
# 
# ## joint rank + score
# 
# 
# dat_scores <- read.csv("../data/clean/scores_long.csv")
# dat_ranks <- read.csv("../data/clean/rank_full_long.csv")
# 
# 
# 
# 
# dat_joint <- dat_scores
# 
# dat_joint$value_rank <- rep(NA, 280)
# 
# 
# dat_joint$value_rank[dat_joint$RandomRevID %in% unique(dat_ranks$RandomRevID)] <-
#   dat_ranks$value
# 
# dat_joint$grant_id <- as.numeric(gsub('x', replacement =  "", dat_joint$grant_id))
# 
# 
# 
# M_multi <- joint(
#   formLong = list(
#     value   ~ 1 + (1 | grant_id) + (1| RandomRevID),
#     value_rank  ~ 1 + (1 | grant_id) + (1| RandomRevID)
#   ),
#   dataLong = dat_joint, id = "grant_id",
#   family  = c("gaussian", "gaussian"),
#   corLong = TRUE)
# 
# 
# summary(M_multi)
# 
# 
# object_effect_rank <- M_multi$summary.random$IDIntercept_L1[29:56,]
# object_effect_score <- M_multi$summary.random$IDIntercept_L1[1:28,]
# 
# pander(object_effect_score)
# 
# object_effect <- object_effect_score
# object_effect <- object_effect[order(object_effect$mean),]
# object_effect <- object_effect[1:10,]
# 
# pander(object_effect)
# 
# widths_s_r <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# ## Score only
# 
# inla_score <- inla(formula = value ~ 1 + f(grant_id, model = "iid") + f(RandomRevID, model = "iid"), 
#                   data = dat_joint, quantiles = c(0.025,0.975))
# 
# 
# object_effect_score <- inla_score$summary.random$grant_id
# 
# object_effect <- object_effect_score
# object_effect <- object_effect[order(object_effect$mean),]
# object_effect <- object_effect[1:10,]
# 
# pander(object_effect)
# 
# 
# widths_s <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# 
# ## Rank only
# 
# inla_rank <- inla(formula = value_rank ~ 1 + f(grant_id, model = "iid"), 
#                    data = dat_joint, quantiles = c(0.025,0.975))
# 
# inla_rank$summary.random$grant_id
# 
# 
# object_effect_rank <- inla_rank$summary.random$grant_id
# 
# object_effect <- object_effect_rank[object_effect_rank$mode != 0,]
# object_effect <- object_effect[order(object_effect$mean),]
# object_effect <- object_effect[1:10,]
# 
# pander(object_effect)
# 
# widths_r <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# 
# ## Rank is on another scale so maybe it's normal to have larger deviations?
# 
# summary(widths_r)
# summary(widths_s)
# summary(widths_s_r)
# summary(widths_s_r_bin)
# 
# summary(widths_r[1:5])
# summary(widths_s[1:5])
# summary(widths_s_r[1:5])
# summary(widths_s_r_bin[1:5])
# 
# 
# 
# pander(read.csv(file = "../data/clean/rank.csv"))
# summary(read.csv(file = "../data/clean/scores.csv"))
# 
# 
# 
# 
# # First issue rank and scores disagree
# 
# plot(dat_joint$grant_id, dat_joint$value, ylim = c(0,7))
# points(dat_joint$grant_id, dat_joint$value_rank, col = "red")
# 
# 
# # Second widths
# 
# widths_s
# 
# unique(dat_joint$grant_id)
# 
# 
# plot(unique(dat_joint$grant_id), widths_s, ylim = c(0,4))
# 
# points(unique(dat_joint$grant_id), widths_r, col = "blue")
# 
# points(unique(dat_joint$grant_id), widths_s_r, col = "green")
# 
# 
# 
# summary(widths_s_r-widths_s)
# 
# 
# 
# #### Only analyse complete cases
# 
# 
# dat_2 <- dat_joint[complete.cases(dat_joint),]
# 
# 
# 
# ###
# ### gaussian + gaussian
# ###
# 
# 
# 
# ## joint rank + score
# 
# 
# 
# 
# 
# dat_joint <- dat_2
# 
# 
# M_multi <- joint(
#   formLong = list(
#     value   ~ 1 + (1 | grant_id) + (1| RandomRevID),
#     value_rank  ~ 1 + (1 | grant_id) + (1| RandomRevID)
#   ),
#   dataLong = dat_joint, id = "grant_id",
#   family  = c("gaussian", "gaussian"),
#   corRE = rep(1, length(unique(dat_joint$grant_id))))
# 
# 
# ?joint
# 
# summary(M_multi)
# 
# M_multi$summary.random$IDIntercept_L1[1:11,]
# 
# 
# object_effect_score <- M_multi$summary.random$IDIntercept_L1[1:11,]
# 
# pander(object_effect_score)
# 
# object_effect <- object_effect_score
# 
# 
# pander(object_effect)
# 
# widths_s_r <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# ## Score only
# 
# inla_score <- inla(formula = value ~ 1 + f(grant_id, model = "iid") + f(RandomRevID, model = "iid"), 
#                    data = dat_joint, quantiles = c(0.025,0.975))
# 
# 
# object_effect_score <- inla_score$summary.random$grant_id
# 
# object_effect <- object_effect_score
# 
# pander(object_effect)
# 
# 
# widths_s <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# 
# ## Rank only
# 
# inla_rank <- inla(formula = value_rank ~ 1 + f(grant_id, model = "iid") +
#                                                  f(RandomRevID, model = "iid"), 
#                   data = dat_joint, quantiles = c(0.025,0.975))
# 
# inla_rank$summary.random$grant_id
# 
# 
# object_effect <- inla_rank$summary.random$grant_id
# 
# 
# 
# pander(object_effect)
# 
# widths_r <- object_effect$`0.975quant` - object_effect$`0.025quant`
# 
# 
# 
# ## Rank is on another scale so maybe it's normal to have larger deviations?
# 
# summary(widths_r)
# summary(widths_s)
# summary(widths_s_r)
# 
# 
# # First issue rank and scores disagree
# 
# plot(dat_joint$grant_id, dat_joint$value, ylim = c(0,7))
# points(dat_joint$grant_id, dat_joint$value_rank, col = "red")
# 
# 
# # Second widths
# 
# plot(unique(dat_joint$grant_id), widths_s, ylim = c(0,1))
# 
# points(unique(dat_joint$grant_id), widths_r, col = "blue")
# 
# points(unique(dat_joint$grant_id), widths_s_r, col = "green")
# 
# 
# 
# summary(widths_s_r-widths_s)
# 
# summary(widths_r - widths_s)






## Check code make reproducible
## Check everything is fitted correctly




# If you take whole knowledge there are missing for ranks
# If you take only full data
# Different conclusions !

## Compute standard for score and ranks
## Run with Randemeffects for the full data

# 1 Standrdised data set
# 2 Just go for complete.cases data set (with standardized ) (vector of 11 random effect)
# 3 Go for full dataset (with standardization) (vector of 28 random effects)




###
### 1. Complete cases analysis ##################################################
###


# Importing data
dat_scores <- read.csv("../data/clean/scores_long.csv")
dat_ranks <- read.csv("../data/clean/rank_full_long.csv")


#Joining scores and ranks
dat_joint <- dat_scores
dat_joint$value_rank <- rep(NA, 280)
dat_joint$value_rank[dat_joint$RandomRevID %in% unique(dat_ranks$RandomRevID)] <-
  dat_ranks$value

head(dat_joint)

#Substituting grant_id for INLA joint
dat_joint$grant_id <- as.numeric(gsub('x', replacement =  "", dat_joint$grant_id))

# Only select complete cases
dat_2 <- dat_joint[complete.cases(dat_joint),]

# Standardising everything
dat_2$std_score <- (dat_2$value - mean(dat_2$value)) / sd(dat_2$value)
dat_2$std_rank  <- (dat_2$value_rank - mean(dat_2$value_rank)) / sd(dat_2$value_rank)


plot(dat_2$grant_id, dat_2$std_score, ylim = c(-3,3), col = "orchid", pch = 15)
points(dat_2$grant_id, dat_2$std_rank, col = "cornflowerblue", pch = 16)




### 1.1 Scores only ------------------------------------------------------------


inla_score <- inla(formula = std_score ~ 1 + f(grant_id, model = "iid") +
                   f(RandomRevID, model = "iid"), 
                   data = dat_2, quantiles = c(0.025,0.975))

widths_s_complete <- inla_score$summary.random$grant_id$`0.975quant` - inla_score$summary.random$grant_id$`0.025quant`

### 1.2 Rank only ------------------------------------------------------------


inla_rank <- inla(formula = std_rank ~ 1 + f(grant_id, model = "iid"), 
                  data = dat_2, quantiles = c(0.025,0.975))

widths_r_complete <- inla_rank$summary.random$grant_id$`0.975quant` - inla_rank$summary.random$grant_id$`0.025quant`


### 1.3 Joint model ----------------------------------------------------------


inla_sr_joint <- joint(
  formLong = list(
    std_score  ~ 1 + (1 | grant_id) + (1| RandomRevID),
    std_rank  ~ 1 + (1 | grant_id) 
  ),
  dataLong = dat_2, id = "grant_id",
  family  = c("gaussian", "gaussian"),
  # Please check the correlation structure again if you refit model
  # corRE =  list( 
  #   grant_id = TRUE)
  corLong = T
)


widths_sr_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[1:11] -
  inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[1:11]

# 
# widths_sr2_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[12:22] -
#   inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[12:22]

### 1.4 Comparison of performance

par(mfrow = c(2,1), mar = c(4,4,4,4))

plot(unique(dat_2$grant_id), widths_s_complete, ylim = c(0,3), col = "orchid", pch = 15,
     main = "Widths of uncertainty in complete cases")
points(unique(dat_2$grant_id), widths_r_complete, col = "cornflowerblue", pch = 16)
points(unique(dat_2$grant_id), widths_sr_complete, col = "darkseagreen", pch = 17)
# points(unique(dat_2$grant_id), widths_sr2_complete, col = "orange", pch = 18)

legend("topright",
       col = c("orchid", "cornflowerblue", "darkseagreen"),
       legend = c("score only", "rank only", "combined scores"),
       pch = c(15,16,17)
       )


mean(widths_s_complete - widths_sr_complete)
mean(widths_r_complete - widths_sr_complete)
mean(widths_r_complete - widths_s_complete)

t.test(widths_s_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
t.test(widths_r_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
t.test(widths_r_complete - widths_s_complete, alternative = "two.sided", mu = 0)



# Even with joint modelling and standardisation, the joint model is not more precise
# This can be due to the data disagreeing, or misspecified model (correlation of random effects) 

# Standardising again with other model. 

# Write section on joint modelling - today tomorrow.

# Focus on convergence diagnostic
# -> Take a look at the description of all functions
# -> Sumarise it in thesis in the annexe on convergence and show that I understood it.
# -> And that I have applied everything and if I am convinced 
# -> Less for this model, but more for the future.





###
### 2. Whole data analysis ##################################################
###

# Standardising everything
dat_joint$std_score <- (dat_joint$value - mean(dat_joint$value, na.rm = T)) / sd(dat_joint$value, na.rm = T)
dat_joint$std_rank  <- (dat_joint$value_rank - mean(dat_joint$value_rank, na.rm = T)) / sd(dat_joint$value_rank, na.rm = T)

# Plotting if desired
# 
# plot(dat_joint$grant_id, dat_joint$std_score, ylim = c(-3,3), col = "orchid", pch = 15)
# points(dat_joint$grant_id, dat_joint$std_rank, col = "cornflowerblue", pch = 16)
# 



### 1.1 Scores only ------------------------------------------------------------


inla_score <- inla(formula = std_score ~ 1 + f(grant_id, model = "iid") +
                     f(RandomRevID, model = "iid"), 
                   data = dat_joint, quantiles = c(0.025,0.975))

summary(inla_score)

mean_s_res <- inla_score$summary.random$grant_id$mean

widths_s_complete <- inla_score$summary.random$grant_id$`0.975quant` - inla_score$summary.random$grant_id$`0.025quant`

### 1.2 Rank only ------------------------------------------------------------


inla_rank <- inla(formula = std_rank ~ 1 + f(grant_id, model = "iid"), 
                  data = dat_joint, quantiles = c(0.025,0.975))

summary(inla_rank)

mean_r_res <- inla_rank$summary.random$grant_id$mean

widths_r_complete <- inla_rank$summary.random$grant_id$`0.975quant` - inla_rank$summary.random$grant_id$`0.025quant`


### 1.3 Joint model ----------------------------------------------------------


#What I think the model should be

inla_sr_joint <- joint(
  formLong = list(
    std_score  ~ 1 + (1 | grant_id) + (1| RandomRevID),
    std_rank  ~ 1 + (1 | grant_id) 
  ),
  dataLong = dat_joint, id = "grant_id",
  family  = c("gaussian", "gaussian"),
  # Please check the correlation structure again if you refit model
  # corRE =  list( 
  #   grant_id = TRUE)
  corLong = T
)

summary(inla_sr_joint)


mean_sr_res <-inla_sr_joint$summary.random$IDIntercept_L1$mean[1:28]


widths_sr_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[1:28] -
  inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[1:28]


# widths_sr2_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[29:56] -
#   inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[29:56]





### 1.4 Comparison of performance


plot(unique(dat_joint$grant_id), widths_s_complete, ylim = c(0,3), col = "orchid", pch = 15,
     main = "Widths of uncertainty in whole dataset")
points(unique(dat_joint$grant_id), widths_r_complete, col = "cornflowerblue", pch = 16)
points(unique(dat_joint$grant_id), widths_sr_complete, col = "darkseagreen", pch = 17)
# points(unique(dat_2$grant_id), widths_sr2_complete, col = "orange", pch = 18)

legend("topright",
       col = c("orchid", "cornflowerblue", "darkseagreen"),
       legend = c("score only", "rank only", "combined scores"),
       pch = c(15,16,17)
)

plot(unique(dat_joint$grant_id), mean_s_res, ylim = c(-2,2), col = "orchid", pch = 15,
     main = "Results on whole data set")
points(unique(dat_joint$grant_id), mean_r_res, col = "cornflowerblue", pch = 16)
points(unique(dat_joint$grant_id), mean_sr_res, col = "darkseagreen", pch = 17)

legend("topright",
       col = c("orchid", "cornflowerblue", "darkseagreen"),
       legend = c("score only", "rank only", "combined scores"),
       pch = c(15,16,17)
)



summary(mean_s_res - mean_sr_res)

mean(widths_s_complete - widths_sr_complete)
mean(widths_r_complete - widths_sr_complete)
mean(widths_r_complete - widths_s_complete)

t.test(widths_s_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
t.test(widths_r_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
t.test(widths_r_complete - widths_s_complete, alternative = "two.sided", mu = 0)



# My personal conclusion -> 
#    (1) The models speak to each other (highly positively correlated ranef) (cov = 0.86)
#        There is potential for a joint model!
#
#    (2) It is not possible to model with inla as inla assumes latent gaussian

#    (2) We show that Inla joint with complete cases performs worse than complete
#         cases -> To be expected as we are deleting a lot of information

#    (3) We provide a baseline for which to compare other models too

#    (4) When te models agree it increases seperation, when the models disagree
#        it decreases seperation
# 




###
### 2. Whole data analysis ##################################################
###

# Standardising everything

dat_joint$value_rank[is.na(dat_joint$value_rank)] <- 7

dat_joint$std_score <- (dat_joint$value - mean(dat_joint$value, na.rm = T)) / sd(dat_joint$value, na.rm = T)
dat_joint$std_rank  <- (dat_joint$value_rank - mean(dat_joint$value_rank, na.rm = T)) / sd(dat_joint$value_rank, na.rm = T)

# Plotting if desired
# 
# plot(dat_joint$grant_id, dat_joint$std_score, ylim = c(-3,3), col = "orchid", pch = 15)
# points(dat_joint$grant_id, dat_joint$std_rank, col = "cornflowerblue", pch = 16)
# 



### 1.1 Scores only ------------------------------------------------------------


inla_score <- inla(formula = std_score ~ 1 + f(grant_id, model = "iid") +
                     f(RandomRevID, model = "iid"), 
                   data = dat_joint, quantiles = c(0.025,0.975))

summary(inla_score)

mean_s_res <- inla_score$summary.random$grant_id$mean

widths_s_complete <- inla_score$summary.random$grant_id$`0.975quant` - inla_score$summary.random$grant_id$`0.025quant`

### 1.2 Rank only ------------------------------------------------------------


inla_rank <- inla(formula = std_rank ~ 1 + f(grant_id, model = "iid"), 
                  data = dat_joint, quantiles = c(0.025,0.975))

summary(inla_rank)

mean_r_res <- inla_rank$summary.random$grant_id$mean

widths_r_complete <- inla_rank$summary.random$grant_id$`0.975quant` - inla_rank$summary.random$grant_id$`0.025quant`


### 1.3 Joint model ----------------------------------------------------------


#What I think the model should be

inla_sr_joint <- joint(
  formLong = list(
    std_score  ~ 1 + (1 | grant_id) + (1| RandomRevID),
    std_rank  ~ 1 + (1 | grant_id) 
  ),
  dataLong = dat_joint, id = "grant_id",
  family  = c("gaussian", "gaussian"),
  # Please check the correlation structure again if you refit model
  # corRE =  list( 
  #   grant_id = TRUE)
  corLong = T
)

summary(inla_sr_joint)


mean_sr_res <-inla_sr_joint$summary.random$IDIntercept_L1$mean[1:28]


widths_sr_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[1:28] -
  inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[1:28]


# widths_sr2_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[29:56] -
#   inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[29:56]





### 1.4 Comparison of performance


plot(unique(dat_joint$grant_id), widths_s_complete, ylim = c(0,3), col = "orchid", pch = 15,
     main = "Widths of uncertainty in whole dataset")
points(unique(dat_joint$grant_id), widths_r_complete, col = "cornflowerblue", pch = 16)
points(unique(dat_joint$grant_id), widths_sr_complete, col = "darkseagreen", pch = 17)
# points(unique(dat_2$grant_id), widths_sr2_complete, col = "orange", pch = 18)

legend("topright",
       col = c("orchid", "cornflowerblue", "darkseagreen"),
       legend = c("score only", "rank only", "combined scores"),
       pch = c(15,16,17)
)

plot(unique(dat_joint$grant_id), mean_s_res, ylim = c(-2,2), col = "orchid", pch = 15,
     main = "Results on whole data set", ylab = "Latent quality", xlab = "object ID")
points(unique(dat_joint$grant_id), mean_r_res, col = "cornflowerblue", pch = 16)
points(unique(dat_joint$grant_id), mean_sr_res, col = "darkseagreen", pch = 17)

legend("topright",
       col = c("orchid", "cornflowerblue", "darkseagreen"),
       legend = c("score only", "rank only", "combined scores"),
       pch = c(15,16,17)
)


# ###
# ### 2. Whole data analysis with Thurst. ##################################################
# ###
# 
# # Standardising everything
# dat_joint$std_score <- (dat_joint$value - mean(dat_joint$value, na.rm = T)) / sd(dat_joint$value, na.rm = T)
# dat_joint$std_rank  <- (dat_joint$value_rank - mean(dat_joint$value_rank, na.rm = T)) / sd(dat_joint$value_rank, na.rm = T)
# 
# values <- dat2_scaled[,c("obj", "thurst_s")]
# colnames(values) <- c("grant_id", "rank_value") 
# 
# 
# # dat_joint$std_rank[dat_joint$grant_id == "x17"] <-  rep(values[1], 10)
# 
# # Plotting if desired
# # 
# # plot(dat_joint$grant_id, dat_joint$std_score, ylim = c(-3,3), col = "orchid", pch = 15)
# # points(dat_joint$grant_id, dat_joint$std_rank, col = "cornflowerblue", pch = 16)
# # 
# 
# ?joint
# 
# ### 1.1 Scores only ------------------------------------------------------------
# 
# 
# inla_score <- inla(formula = std_score ~ 1 + f(grant_id, model = "iid") +
#                      f(RandomRevID, model = "iid"), 
#                    data = dat_joint, quantiles = c(0.025,0.975))
# 
# summary(inla_score)
# 
# mean_s_res <- inla_score$summary.random$grant_id$mean
# 
# widths_s_complete <- inla_score$summary.random$grant_id$`0.975quant` - inla_score$summary.random$grant_id$`0.025quant`
# 
# ### 1.2 Rank only ------------------------------------------------------------
# 
# 
# inla_rank <- inla(formula = rank_value ~ 1 + f(grant_id, model = "iid"), 
#                   data = values, quantiles = c(0.025,0.975))
# 
# summary(inla_rank)
# 
# mean_r_res <- inla_rank$summary.random$grant_id$mean
# 
# inla_rank$summary.random$grant_id$mean
# 
# mean_r_res
# 
# widths_r_complete <- inla_rank$summary.random$grant_id$`0.975quant` - inla_rank$summary.random$grant_id$`0.025quant`
# 
# widths_r_complete
# 
# ### 1.3 Joint model ----------------------------------------------------------
# 
# 
# #What I think the model should be
# values$grant_id <- as.numeric(gsub('x', replacement =  "", values$grant_id))
# 
# dat_joint$grant_id <- as.numeric(gsub('x', replacement =  "", dat_joint$grant_id))
# 
# 
# 
# inla_sr_joint <- joint(
#   formLong = list(
#     std_score  ~ 1 + (1 | grant_id) + (1| RandomRevID),
#     rank_value  ~ 1 + (1 | grant_id) 
#   ),
#   dataLong = list(dat_joint, values), id = "grant_id",
#   family  = c("gaussian", "gaussian"),
#   corLong = T
# )
# 
# summary(inla_sr_joint)
# 
# 
# mean_sr_res <-inla_sr_joint$summary.random$IDIntercept_L1$mean[1:28]
# 
# 
# widths_sr_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[1:28] -
#   inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[1:28]
# 
# 
# # widths_sr2_complete <- inla_sr_joint$summary.random$IDIntercept_L1$`0.975quant`[29:56] -
# #   inla_sr_joint$summary.random$IDIntercept_L1$`0.025quant`[29:56]
# 
# 
# 
# 
# 
# ### 1.4 Comparison of performance
# 
# 
# plot(unique(dat_joint$grant_id), widths_s_complete, ylim = c(0,3), col = "orchid", pch = 15,
#      main = "Widths of uncertainty in whole dataset")
# points(unique(values$grant_id), widths_r_complete, col = "cornflowerblue", pch = 16)
# points(unique(dat_joint$grant_id), widths_sr_complete, col = "darkseagreen", pch = 17)
# # points(unique(dat_2$grant_id), widths_sr2_complete, col = "orange", pch = 18)
# 
# legend("topright",
#        col = c("orchid", "cornflowerblue", "darkseagreen"),
#        legend = c("score only", "rank only", "combined scores"),
#        pch = c(15,16,17)
# )
# 
# plot(unique(dat_joint$grant_id), mean_s_res, ylim = c(-2,2), col = "orchid", pch = 15,
#      main = "Results on whole data set")
# points(unique(values$grant_id), mean_r_res, col = "cornflowerblue", pch = 16)
# points(unique(dat_joint$grant_id), mean_sr_res, col = "darkseagreen", pch = 17)
# 
# legend("topright",
#        col = c("orchid", "cornflowerblue", "darkseagreen"),
#        legend = c("score only", "rank only", "combined scores"),
#        pch = c(15,16,17)
# )
# 
# 
# 
# summary(mean_s_res - mean_sr_res)
# 
# mean(widths_s_complete - widths_sr_complete)
# mean(widths_r_complete - widths_sr_complete)
# mean(widths_r_complete - widths_s_complete)
# 
# t.test(widths_s_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
# t.test(widths_r_complete - widths_sr_complete, alternative = "two.sided", mu = 0)
# t.test(widths_r_complete - widths_s_complete, alternative = "two.sided", mu = 0)
