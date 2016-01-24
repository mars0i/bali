# R

# Create data.frames for one set of same-param runs in the April 2015 formats.
# The April2015 baliplus data might not be in the same format as later
# data.  I have a plan to generate it in a different way.

# First run the procedures to generate the cooked data. 
# Then run this:

aprilCreateDFs <- function(trantype, religeffect) {
  setwd("~/src/data.bali/april2015/cooked") # GENERALIZE this line
  setwd(paste0(trantype, "/", religeffect)) # move to location of data

  # these are local, right? need to export them
  religtype.df    <- data.frame(data=c(t(read.csv("religtype.csv", header=F))),
                                bin=rep(1:50,100),
                                run=c(sapply(1:100, function(i){rep(i,50)})),
                                relig=rep(religeffect, 5000),  # will allow combining into larger data.frames
                                tran=rep(trantype, 5000))      # ditto

  avgharvestha.df <- data.frame(data=c(t(read.csv("avgharvestha.csv", header=F))),
                                bin=rep(1:50,100), 
                                run=c(sapply(1:100, function(i){rep(i,50)})),
                                relig=rep(religeffect, 5000),
                                tran=rep(trantype, 5000))

  # NEEDS FURTHER TESTING:
  religtypeAvg.df    <- data.frame(data=sapply(1:50, function(i){mean(religtype.df$data[religtype.df$bin==i])}),
                                   bin=1:50,
                                   relig=rep(religeffect, 50),
                                   tran=rep(trantype, 50))

  avgharvesthaAvg.df <- data.frame(data=sapply(1:50, function(i){mean(avgharvestha.df$data[avgharvestha.df$bin==i])}),
                                   bin=1:50,
                                   relig=rep(religeffect, 50),
                                   tran=rep(trantype, 50))

  list(religtype.df, religtypeAvg.df, avgharvestha.df, avgharvesthaAvg.df)
}

aprilCreateAll <- function() {
  rel.df     <- data.frame(data=c(), bin=c(), run=c(), relig=c(), tran=c())
  relavg.df  <- data.frame(data=c(), run=c(), relig=c(), tran=c())
  harv.df    <- data.frame(data=c(), bin=c(), run=c(), relig=c(), tran=c())
  harvavg.df <- data.frame(data=c(), run=c(), relig=c(), tran=c())

  for (trantype in c("0025global", "1global", "50global")) {
    for (religeffect in c("05step", "08step", "linear", "sigmoidey")) {
       print(paste(trantype, religeffect))
       dfs <- aprilCreateDFs(trantype, religeffect)
       rel.df <- rbind(rel.df, dfs[[1]])
       relavg.df  <- rbind(relavg.df, dfs[[2]])
       harv.df  <- rbind(harv.df, dfs[[3]])
       harvavg.df   <- rbind(harvavg.df, dfs[[4]])
     }
  }

  trantype <- "notran"
  for (religeffect in c("nonoise", "norelig")) {
     print(paste(trantype, religeffect))
     dfs <- aprilCreateDFs(trantype, religeffect)
     rel.df <- rbind(rel.df, dfs[[1]])
     relavg.df  <- rbind(relavg.df, dfs[[2]])
     harv.df  <- rbind(harv.df, dfs[[3]])
     harvavg.df   <- rbind(harvavg.df, dfs[[4]])
   }

  # define at top level
  assign("relig.df", rel.df, envir=.GlobalEnv)
  assign("religAvg.df", relavg.df, envir=.GlobalEnv)
  assign("avgharvestha.df", harv.df, envir=.GlobalEnv)
  assign("avgharvesthaAvg.df", harvavg.df, envir=.GlobalEnv)
}


# tips:
#
# Then to make a histogram from the avg data, you can do:
# 
# barchart(data ~ bin, data=religtypeAvg.df, horizontal=F, origin=0)
# Or to rotate the bin labels:
# barchart(data ~ bin, data=religtypeAvg.df, horizontal=F, origin=0, scales = list(x = list(rot = 90)))
# 
# Note the "origin=0" is important.  Otherwise zeros look like > 0.
# 
# To show each run separately, using the original data.frame (it's quite interesting):
# barchart(data ~ bin | run, data=religtype.df, horizontal=F, origin=0)
