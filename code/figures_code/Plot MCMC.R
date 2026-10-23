
###############################################
### Estimating density of normal distribution ##################
###############################################

metropolis <- function(x1, x2){

  p_acc <- min(1, dnorm(x2) / dnorm(x1))
  
  if (rbinom(1, 1, p_acc) == 1){
    return(T)
  } else {return(F)}
}


new_cand <- function(x1){
  return(x1 + rnorm(1, mean = 0, sd = 0.15))
}


mcmc <- function(chain, n){
  
  for (x in 1:(n-1)) {
    while (is.na(chain[x+1])) {
      x1 <- chain[x]
      x2 <- new_cand(x1)
      if(metropolis(x1,x2)){
        chain[x+1] <- x2
        if(x %% (n/10) == 0){
          cat(x)
        }
      }
    }
  }
  return(chain)
}

set.seed(42)

n = 10000

chain1 <- rep(NA, n)
chain2 <- rep(NA, n)
chain3 <- rep(NA, n)

chain1[1] <- 8
chain2[1] <- 14
chain3[1] <- -8

chain1 <- mcmc(chain1, n)
chain2 <- mcmc(chain2, n)
chain3 <- mcmc(chain3, n)



par(mfrow = c(1,2))

plot(chain3, type = "l", col = "cornflowerblue", ylim = c(-6,6),
     ylab = "Sample", main = "Trace plot of one MCMC chain",
     xlab = "Iterations")
legend("topright", legend = c("Chain 1"), 
       col = c("cornflowerblue"), lty = c(1) )

plot(chain3, type = "l", col = "cornflowerblue", ylim = c(-6,6),
     ylab = "Sample", main = "Trace plots of three MCMC chains",
     xlab = "Iterations")
lines(chain1, type = "l", col = "darkgreen", ylim = c(-6,6))
lines(chain2, type = "l", col = "coral")
legend("topright", legend = c("Chain 1", "Chain 2", "Chain 3"), 
       col = c("cornflowerblue", "coral", "darkgreen"), lty = c(1,1,1) )




hist(c(chain1,chain2,chain3))

curve(
  dnorm(x, mean = 0, sd = 1), 
  from = -4, to = 4, n = 1000, add =  T,
  col = "darkseagreen",lwd = 1.5)

