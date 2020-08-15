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
export_significantpairs_df <- function(sigpairs.name, output.dir) {
  
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

if (class(opt$input) != "list"){
  print_help(OptionParser(option_list=option_list))
  stop("The input file must be a list of significant pairs\n", call.=FALSE)
}

significantpairs.list <- readRDS(file = opt$input)
#
########### call function to write out individual data frames #############
lapply(names(significantpairs.list), export_significantpairs_df, output.dir=opt$outdir)
