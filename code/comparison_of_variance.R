
# Plotting the three prior distributions

curve(dgamma(x, shape = 1, rate = 1), from = 0, to = 5, 
      main = "Precision prior for the random effects",
      ylab = "Probability density")


curve(dgamma(x, shape = 1, rate = 0.1), from = 0, to = 5, 
      main = "Precision prior for the error term",
      ylab = "Probability density")


curve(dnorm(x, mean = 0, sd = 1000), from = -5000, to = 5000, 
      main = "Prior for the intercept",
      ylab = "Probability density")


summary(rgamma(1000000, shape =1, rate =1))
sd(rgamma(1000000, shape =1, rate =1))

summary(rgamma(10000000, shape =1, rate =0.1))

summary(rnorm(10000000000, mean = 0, sd = 1000))

qnorm(.75, mean = 0, sd = 1000)
