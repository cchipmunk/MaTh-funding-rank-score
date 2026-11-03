var_samples <- rgamma(100000, shape = 1.5, rate = 1.5)

hist(var_samples)

summary(var_samples)

options(scipen = 99)


prec_samples <- 1/ (var_samples)

hist(prec_samples)

summary(prec_samples)



inla_prec_samples <- rgamma(100000, shape = 1.5, rate = 1.5)

inla_var_samples <- 1 / inla_prec_samples


hist(inla_var_samples)
summary(inla_var_samples)
