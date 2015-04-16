# R

# Create dataframes for one set of same-param runs in the April 2015 formats.
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
                                relig=rep(religeffect, 5000),
                                tran=rep(trantype, 5000))

  avgharvestha.df <- data.frame(data=c(t(read.csv("avgharvestha.csv", header=F))),
                                bin=rep(1:50,100), 
                                run=c(sapply(1:100, function(i){rep(i,50)})),
                                relig=rep(religeffect, 5000),
                                tran=rep(trantype, 5000))

  # NEEDS FURTHER TESTING:
  religtypeAvg.df <- data.frame(data=sapply(1:50, function(i){mean(religtype.df$data[religtype.df$bin==i])}), bin=1:50)
  avgharvesthaAvg.df <- data.frame(data=sapply(1:50, function(i){mean(avgharvestha.df$data[avgharvestha.df$bin==i])}), bin=1:50)

  list(religtype.df, religtypeAvg.df, avgharvestha.df, avgharvesthaAvg.df)
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
# To show each run separately, using the original dataframe (it's quite interesting):
# barchart(data ~ bin | run, data=religtype.df, horizontal=F, origin=0)
