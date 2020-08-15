#!/usr/bin/env Rscript
#
# hreyes August 2020
# generate-beds.R
#######################################################################
# Read in a significant pairs data frame and output two bed files
# with the columns necessary to plot a chord diagram.
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

}
# 
########################## read in data ###################################
option_list = list(
  make_option(opt_str = c("-i", "--input"), 
              type = "character",
              help = "Input data frame of significant pairs as an Rds file."),
  make_option(opt_str = c("-o", "--output_bed1"), 
              type = "character", 
              help = "File name (including path) for the significant pairs BED1."),
  make_option(opt_str = c("-p", "--output_bed2"), 
              type = "character", 
              help = "File name (including path) for the significant pairs BED2.")
)

opt <- parse_args(OptionParser(option_list=option_list))

if (is.null(opt$input)){
  print_help(OptionParser(option_list=option_list))
  stop("The input file is mandatory.n", call.=FALSE)
}

significantpairs.df <- readRDS(file = opt$input)

dim(significantpairs.df)
#
########### call function to write out individual data frames #############

