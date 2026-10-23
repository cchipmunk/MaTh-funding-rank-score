library(dplyr)
library(ggplot2)
library(reshape2)
library(data.table)


############################
### Exploratory analysis ##########################################
###########################


### Scores
dat <- read.csv("../data/clean/scores_long.csv")

### Values

dat_clean <- dat[!is.na(dat$value),]
dat_clean <- unique(dat_clean)

dat_clean$grant_id <- as.factor(dat_clean$grant_id)


### Mean and Sd
mean(dat_clean$value)
sd(dat_clean$value, na.rm = TRUE)

### Size
length(unique(dat_clean$grant_id))
length(unique(dat_clean$RandomRevID))


hist(dat_clean$value, main = "Frequency of Scores given",
     xlab = "Score", xlim = c(1,5), col = "darkseagreen")



### Number of observationsper object
for (i in unique(dat_clean$grant_id)) {
  cat(i)
  print(length(dat_clean[dat_clean$grant_id == i,]$value))
}



### Scale take from Gallo et al.

val_min <- c()
val_max <- c()

for (i in 1:length(unique(dat_clean$grant_id))) {
  print(unique(dat_clean$grant_id)[i])
  val_min[i] <- min(dat_clean[dat_clean$grant_id == unique(dat_clean$grant_id)[i],]$value)
  val_max[i] <- max(dat_clean[dat_clean$grant_id == unique(dat_clean$grant_id)[i],]$value)
}



plot_dat <- data.frame(
  ID = c(unique(dat_clean$grant_id)),
  min = val_min,
  max = val_max)

plot_dat <- plot_dat[order(plot_dat$min),]



### Span per proposal.
plot_dat <- plot_dat %>% rowwise() %>% mutate( mymean = mean(c(min,max) )) %>%
  arrange(mymean) %>% mutate(ID =factor(ID, ID))

plot_dat <- plot_dat %>% rowwise() %>% arrange(min) %>% mutate(ID =factor(ID, ID))

ggplot(plot_dat) +
  geom_segment( aes(x=ID, xend=ID, y=max, yend = min), color="darkseagreen") +
  geom_point( aes(x=ID, y=max), color="darkgrey", size=3 ) +
  geom_point( aes(x=ID, y=min), color="darkgrey", size=3 ) +
  coord_flip()+
  theme_light() +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    plot.title = element_text(size=22, hjust = 0.5),
    text = element_text(size = 14)
  ) +
  xlab("Proposal IDs") +
  ylim(c(1,5)) +
  ylab("Score") +
  ggtitle("Span of scores per proposals")


### Span per assessors


val_min <- c()
val_max <- c()

for (i in 1:length(unique(dat_clean$RandomRevID))) {
  print(unique(dat_clean$RandomRevID)[i])
  val_min[i] <- min(dat_clean[dat_clean$RandomRevID == unique(dat_clean$RandomRevID)[i],]$value)
  val_max[i] <- max(dat_clean[dat_clean$RandomRevID == unique(dat_clean$RandomRevID)[i],]$value)
}

plot_dat_2 <- data.frame(
  ID = unique(dat_clean$RandomRevID),
  min = val_min,
  max = val_max
)

plot_dat_2$ID <- as.factor(plot_dat_2$ID)


ggplot(plot_dat_2) +
  geom_segment( aes(x=ID, xend=ID, y=max, yend = min), color="darkseagreen") +
  geom_point( aes(x=ID, y=max), color="darkgrey", size=3 ) +
  geom_point( aes(x=ID, y=min), color="darkgrey", size=3 ) +
  coord_flip()+
  theme_light() +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    plot.title = element_text(size=22, hjust = 0.5),
    text = element_text(size = 14)
  ) +
  ylim(c(1,5)) +
  xlab("Assessor IDs") +
  ylab("Score") +
  ggtitle("Span of scores per Assessor")


###################
### Ranking data ################################################3
###################

dat <- read.csv(file = "../data/clean/rank_full_long.csv")

dat_ranks <- dat[!is.na(dat$value),]

rank_1 <- c()
rank_2 <- c()
rank_3 <- c()
rank_4 <- c()
rank_5 <- c()
rank_6 <- c()

rank_ids <- unique(dat_ranks$grant_id)


for (i in 1:11){
  rank_1[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 1)
  rank_2[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 2)
  rank_3[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 3)
  rank_4[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 4)
  rank_5[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 5)
  rank_6[i] <- sum(dat_ranks[dat_ranks$grant_id == rank_ids[i],]$value == 6)
}

matrix_counts <- data.frame(
  "grant_id" = rank_ids,
  "1st" = rank_1,
  "2nd" = rank_2,
  "3rd" = rank_3,
  "4th" = rank_4,
  "5th" = rank_5,
  "6th" = rank_6
)

matrix_probs <- data.frame(
  "grant_id" = rank_ids,
  "1st" = rank_1 /10,
  "2nd" = rank_2/10,
  "3rd" = rank_3/10,
  "4th" = rank_4/10,
  "5th" = rank_5/10,
  "6th" = rank_6/10
)

matrix_probs <- matrix_probs[order(matrix_probs$X1st, matrix_probs$X2nd,
                                   matrix_probs$X3rd, matrix_probs$X4th,
                                   matrix_probs$X5th, matrix_probs$X6th,
                                   decreasing = TRUE), ]

order <- matrix_probs$grant_id
order
matrix_probs

matrix_probs$grant_id <- factor(matrix_probs$grant_id, levels = order, ordered = T)

heat_format <- melt(setDT(matrix_probs), id.vars = c("grant_id"), variable.name = "Rank")

matrix_probs <- matrix_probs[order(matrix_probs$X1st, matrix_probs$X2nd,
                                   matrix_probs$X3rd, matrix_probs$X4th,
                                   matrix_probs$X5th, matrix_probs$X6th,
                                   decreasing = TRUE), ]


ggplot(heat_format, aes(Rank, grant_id, fill= value)) + 
  geom_tile() +
  geom_text(aes(label = if_else (condition = value > 0,
                                 as.character(value),"")), color = "black") +
  scale_fill_gradient(low="white", high="lightslateblue") +
  theme(text = element_text(size = 14),
        plot.title = element_text(size=22, hjust = 0.5),
  ) +
  scale_size_area(
    limits = c(0, 0.6),
    max_size = 18
  ) +
  ggtitle("Rank frequencies in data") +
  xlab("Ranks") +
  ylab("Objects") +
  scale_x_discrete(labels=c("X1st" = "1st", "X2nd" = "2nd",
                            "X3rd" = "3rd", "X4th" = "4th",
                            "X5th" = "5th", "X6th" = "6th")) +
  labs(fill = "probability")
