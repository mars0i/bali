How to generate data for analysis
====
October 2015 and after procedure

Different git branches contain different pest and rainfall
configurations.  (master in Fall 2015 and Spring 2016 contains the
highest pest and rainfall values.)

In cheaha, for each behavior space experiment in a git branch, use
run100 to run 100 sim runs with that experiment.  (run100 created
11/2016, but just does what I/we were doing before.)  You should then
have 100 religtype*.csv files, each with 5001 lines.  That's the data.
There will also be 100 NetLogo "spreadsheet" csv's in a subdirectory.
These record the configuration of each of the runs.

Make sure that each set of 100 religtype*.csv's ends up in a subdir of a
single dir, and that there are no subdirs containing other
religtype*.csv's that don't belong in the same dataframe.  The following
procedure will look for csvs in each subdir of the current subdir.

From that directory, run src/R/createDataframeOctober2015.R using
qsub/submitanything.job. e.g. like this:

qsub -M mabrams@uab.edu -N HiHi ~/bali/src/qsub/submitanything.job Rscript ~/bali/src/R/createDataframeOctober2015.R

Or maybe it's necessary to override the default RAM and timeout values
that I set in submitanything.job (2G, 48 hours), e.g. like this:

qsub -M mabrams@uab.edu -N HiHi -l h_rt=24:00:00,vf=8G ~/bali/src/qsub/submitanything.job Rscript ~/bali/src/R/createDataframeOctober2015.R

This will create an R data file called balidf.rdata, containing the
dataframe bali.df.

Note: If you are running different branch configurations, make sure
that you move or rename R datafiles so they don't get overwritten, and
if you load multiple dataframes in one R session, you'll need to copy
them to different names, since they all start out with the same name.
