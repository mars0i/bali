#!/bin/sh
# Given a series of filenames on a single line in stdin,
# e.g. produced via
#	echo <filenames> | thisscript
# the script constructs the R expression:
#	c("filename1","filename2",...,"filenameN")

sed -e 's/\([^ ][^ ]*\) */"\1",/g'  -e 's/\(.*\), */c(\1)/'
