#!/usr/bin/env Rscript
#
# hreyes June 2020
# separate-significantpairs-list.R
#######################################################################
# Read in a list of filtered hicexp qlf-compared results and separate
# each data frame into an individual file.
#
# Note that the parameter names(list) will be used to create the output
# table files.
########################################################################
#
#################### import libraries and set options ##################
library(optparse)
#
########################## functions ###################################
# it's dangerous to go alone! take this.
#
# save an individual data frame from the list
export_significantpairs_df <- function(sigpairs.name) {
  # select data frame from list
  sigpairs.df = significantpairs.list[[sigpairs.name]]
  
  # parse list name and dataframe name
  this.df = gsub("\\.", "-vs-", gsub(pattern = "sig.", "", sigpairs.name))
  the.parent = gsub("\\.significantpairs\\.Rds", "", basename(opt$input))
  
  # build name for outfile
  the.outfile = paste0(opt$outdir, "/", the.parent, "__", this.df, ".significantpairs.table.Rds")
  
  saveRDS(object = sigpairs.df, file = the.outfile)
}
# 
########################## read in data ###################################
option_list = list(
  make_option(opt_str = c("-i", "--input"), 
              type = "character",
              help = "Input list object of significant pairs as an Rds file"),
  make_option(opt_str = c("-o", "--outdir"), 
              type = "character", 
              help = "output directory for the individual dataframes")
)

opt <- parse_args(OptionParser(option_list=option_list))

significantpairs.list <- readRDS(file = opt$input)

if (class(significantpairs.list) != "list"){
  print_help(OptionParser(option_list=option_list))
  stop("The input file must be a list of significant pairs\n", call.=FALSE)
}
#
########### call function to write out individual data frames #############
lapply(names(significantpairs.list), export_significantpairs_df)
