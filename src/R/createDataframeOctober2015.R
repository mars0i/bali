# R

# Automatically install data.table package if necessary, and load it.
# Needed for rbindlist().
if(!require(data.table)){
    install.packages("data.table", dependencies=T)
    library(data.table)
}

createDataframeAndSave <- function(dirpath="*") {
  bali.df <- loadReligtypeCSVs(dirpath)
  save(bali.df, file="balidf.rdata")
}

# Calls csvs2df on the output of religtypeCSVs.
# returns a data.table dataframe.
loadReligtypeCSVs <- function(dirpath="*") {
  return(csvs2df(religtypeCSVs(dirpath)))
}

# Returns a vector of religtype csv file names, by default in every subdir
# of the current dir.  Pass "." as an argument to get csv file names
# inside the current dir.
religtypeCSVs <- function(dirpath="*") {
  return(Sys.glob(paste0(dirpath, "/religtype*.csv")))
}

# Returns a dataframe composed of data from each csv file whose name
# is listed in csvs.
csvs2df <- function(csvs) {
  bigdf <- rbindlist(lapply(csvs, read.csv))

  # The global.tran column might contain only integers.
  # Either way, we want R to treat the data as "factors", not integers:
  bigdf$global.tran <- factor(bigdf$global.tran)

  return(bigdf)
}

createDataframeAndSave()
