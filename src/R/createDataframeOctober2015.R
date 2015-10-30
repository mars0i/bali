# R

# Using rbind repeatedly may require too much RAM, but it's simple, so let's try it.
loadruns <- function(csvs) {
  n.runs <- length(csvs)
  # csv1 <- csvs[1]

  dfs <- vector("list", length=n.runs)


  for (i in 1:n.runs) {
  	dfs[i] <- read.csv(csvs[i])
  }

  return apply(rbind, dfs) # UNTESTED

}
