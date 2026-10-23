# Libraries
library(ggplot2)
library(ggnewscale)
library(dplyr)



###############################
### Final plotting functions  ##########################################
###############################


make_plot_segment <- function(min, max, estimate, names, model_name = "...", accepted,
                              intercept_line = NA, ylims = c(min(min) + 0.3*min(min), 0),
                              y_label = "Latent quality"){
  
  if(length(names) != length(min) | length(names) != length(estimate) |
     length(names) != length(max) | length(names) != length(accepted)){
    cat("Warning: length of min,max,names and estimates not equal")
  } else {
    dat <- data.frame(min, max, estimate, names, accepted)
    dat$estimate <- as.numeric(dat$estimate)
    dat$min <- as.numeric(dat$min)
    dat$max <- as.numeric(dat$max)
    dat$accepted <- as.character(accepted)
    
    
    
    data <- dat %>% 
      rowwise() %>% 
      arrange(estimate) %>% 
      mutate(names=factor(names, names))
    
    cols <- c("Point estimate" = "black", "Accepted" = "olivedrab", "Rejected" = "grey",
              "Lottery" = "orchid", "80% CI" = "grey") 
    
    ggplot(data) +
      geom_segment( aes(x=names, xend=names, y=min, yend=max, colour=accepted), size = 1.5) +
      ylim(ylims) +
      scale_colour_manual(name = "50% CI", values = cols) +
      new_scale_color() +
      # geom_point( aes(x=names, y=min, colour="Lower bound"), size=3 ) +
      # geom_point( aes(x=names, y=max, colour="Upper bound"), size=3 ) +
      geom_point( aes(x=names, y=estimate, colour = "Point estimate"), size=2) +
      geom_hline(aes(yintercept = intercept_line, linetype = "Threshold"), color = "grey") +
      scale_linetype_manual(name = "Funding line", values = "dashed") +
      scale_colour_manual(name = "Estimates", values = cols) +
      xlab("") +
      ylab(y_label) +
      xlab("Object") +
      ggtitle(paste("Object quality according to", model_name)) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=0.5))
  }
  
}



make_plot_pop <- function(estimate, names, model_name = "...", accepted, y_label = "Latent quality",
                          y_lims = c(0.8 * min(estimate), 1.2 * max(estimate)), intercept_line = estimate[3]){
  
  if(length(names) != length(estimate)){
    cat("Warning: length of names and estimates not equal")
  } else {
    dat <- data.frame(estimate, names, accepted)
    dat$estimate <- as.numeric(dat$estimate)
    dat$names <- as.factor(dat$names)
    
    dat
    
    data <- dat %>% 
      rowwise() %>% 
      arrange(estimate) %>% 
      mutate(names=factor(names, names))
    
    data <- as.data.frame(data)
    data
    
    ggplot(data) +
      geom_hline(aes(yintercept = intercept_line, linetype = "Threshold"), color = "grey") +
      scale_linetype_manual(name = "Funding line", values = "dashed") +
      geom_point( aes(x=names, y= as.numeric(estimate), colour = accepted), size = 4) +
      scale_colour_manual(name = "Status", values = c("Accepted"="olivedrab", "Rejected" = "grey") ) +
      ylim(y_lims) +
      xlab("") +
      ylab(y_label) +
      xlab("Object") +
      ggtitle(paste("Object quality according to", model_name)) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=0.5))
  }
}


########################
### Example of calls  #####################################################
########################
#
# Use "ctrl" + "shift" + c" to uncomment multiple lines together



# set.seed(42)
# 
# # Create toy data
# value1 <- abs(rnorm(26))*2
# data <- data.frame(
#   x = LETTERS[1:26], 
#   estimate = value1, 
#   maximum = value1 + 3 + rnorm(26, sd=1),
#   minimum = value1 - 3 - rnorm(26, sd=1)
# )
# 
# #Order ascendingly
# data <- data %>% 
#   rowwise() %>% 
#   arrange(estimate) %>% 
#   mutate(names=factor(x, x))



# make_plot_segment(estimate = data$estimate, min = data$minimum, max = data$maximum,
#                   names = data$x, model_name = "toy example", 
#                   accepted = c(rep("Accepted", 3), rep("Lottery", 5), rep("rejected", 18)), 
#                   ylims = c(-5,10), y_label = "score", intercept_line = data$estimate[3])


# make_plot_pop(estimate = data$estimate, names = data$x, model_name = "Toy example",
#               intercept_line = data$estimate[3], y_lims = c(-1,8), y_label = "Score",
#               accepted = c(rep("Accepted", 3), rep("rejected", 23)) )
