x <- seq(0, 10, by = 0.01)



curve(dnorm(x, mean = 2, sd = 0.3), from = 0, to = 5, n = 10000,
      col = "cornflowerblue", xlim = c(1,5),
      ylab = "Probability denstity", xlab = "Latent quality",
      main = "Example of Thurstonian latent quality distributions")

curve(dnorm(x, mean = 3, sd = .6), from = 0, to = 20, n = 10000,
      col = "forestgreen", add = T)

curve(dnorm(x, mean = 4, sd = 0.4), from = 0, to = 20, n = 10000,
      col = "orange", add = T)

legend("topright", 
       c("Object 1", "Object 2", "Object 3"), 
       col = c("cornflowerblue", "forestgreen", "orange"),
       lty = 1)
