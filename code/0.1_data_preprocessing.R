library(reshape2)
library(pander)
library(dplyr)
library(rankrate)
library(data.table)
library(psych)
library(ggplot2)




##################
# Ranking data ################################################################
##################


dat <- read.csv("../data/raw/00_ranks.csv")
new_dat <- dat[c(-2,-4),] #12 already removed
rev_id <- new_dat$RandomRevID

summary(new_dat)


new_names <- paste0("x", seq(-1,28))
colnames(new_dat) <- new_names

new_dat <- new_dat[,c(-1,-2)] 

non_na <- c(3,4,13,16,17,19,20,21,22,23,25)


new_dat_full <- new_dat
new_dat_clean <- new_dat[,non_na]

pander(new_dat_clean)
pander(new_dat_full)


write.csv(new_dat_full, file = "../data/clean/rank_full.csv", row.names = F)
write.csv(new_dat_clean, file = "../data/clean/rank.csv", row.names = F)


# Long format for joint model

new_dat_full$RandomRevID <- rev_id
new_dat_full$RandomRevID <- as.character(new_dat_full$RandomRevID )

dat_rank_long <- melt(setDT(new_dat_full), id.vars = c("RandomRevID"), variable.name = "grant_id")


write.csv(dat_rank_long, file = "../data/clean/rank_full_long.csv", row.names = F)


##################
### Scoring data ################################################################
##################

# Already clean


dat <- read.csv("../data/raw/00_scores.csv")

#Removing double review
dat <- dat[-2,]

new_names <- c("RandomRevID", paste0("x", seq(0,28)))
colnames(dat) <- new_names

#Removing second column
dat <- dat[,-2]

for (i in 2:29) {
  dat[,i] <- as.numeric(dat[,i])
}
dat[,1] <- as.character(dat[,1])


pander(dat)

dat_long <- melt(setDT(dat), id.vars = c("RandomRevID"), variable.name = "grant_id")


write.csv(dat_long, file = "../data/clean/scores_long.csv", row.names = F)
write.csv(dat, file = "../data/clean/scores.csv", row.names = F)






##################
# Missing data  ################################################################
##################
#
# Taken from the Rankrate package directly as the data is not well documented.
#

# Scoring data
scores <- AIBS$ratings[c(-2,-12),]
pander(scores)
sum(is.na(scores))
21/280


# Ranking data
dat <- rankrate::AIBS$rankings
pander(dat)
dat_miss <- attr(dat, "assignments")[c(-2,-12, -4),]

sum(dat_miss) / 280

sum(dat_miss == FALSE)

dat_miss*1 - 1

# Missing data needing truncation:
#
# x3 8th row
# x22 4th assessor
#
# (All the rest of MCI data made it in no top 6)
#
# Truncating the data does not change anything



####################################
### Agreement in ranks and scores #####################################
####################################

#scores
dat1 <- read.csv("../data/clean/scores.csv")

dat_ICC1 <- t(dat1)
colnames(dat_ICC1) <- dat_ICC1[1,]
dat_ICC1 <- as.data.frame(dat_ICC1[-1,])

ICC(dat_ICC1, lmer = TRUE)


#Ranks
dat2 <- read.csv("../data/clean/rank.csv")

dat_ICC2 <- t(dat2)
dat_ICC2 <- as.data.frame(dat_ICC2)

# Replacing observation of NA, with greater or equal than 7th position
for (i in 1:11) {
  for(j in 1:9){
    if (is.na(dat_ICC2[i,j])){
      dat_ICC2[i,j] <- 7
    }
  }
}

ICC(dat_ICC2, lmer = T)


# Ranks and scores agreement

# Importing data
dat_scores <- read.csv("../data/clean/scores_long.csv")
dat_ranks <- read.csv("../data/clean/rank_full_long.csv")


#Joining scores and ranks
dat_joint <- dat_scores
dat_joint$value_rank <- rep(NA, 280)
dat_joint$value_rank[dat_joint$RandomRevID %in% unique(dat_ranks$RandomRevID)] <-
  dat_ranks$value

dat_joint <- dat_joint[complete.cases(dat_joint),]


jitter_amount <- 0.001

ggplot(dat_joint) +
  geom_jitter( aes(x=value, y= as.numeric(value_rank), colour = "Datapoints"), alpha = 0.6, 
               height = jitter_amount, size = 3) +
  scale_colour_manual(name = "Values", values = c("Datapoints" = "darkseagreen")) +
  scale_y_continuous(name = "Rank given to object") +
  xlab("Score given to object") +
  ggtitle("Agreement between ranks and scores") +
  theme_bw() 


cor(dat_joint$value, dat_joint$value_rank)
