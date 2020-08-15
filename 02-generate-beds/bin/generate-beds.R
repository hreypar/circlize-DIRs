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
message("\nLoaded libraries.")
#
########################## read in data ################################
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
message("The data frame has been loaded.")
#
################### add an index to keep track of DIRs #################
significantpairs.df$DIRindex <- paste("DIR", seq(1:nrow(significantpairs.df)), sep="_")
message("An index has been generated to keep track of DIRs.")
#
################### subset data frame to generate beds #################
bed1 = significantpairs.df[ ,c("chr1", "start1", "end1", "logFC", "DIRindex")]
message("BED1 file has been created.")
bed2 = significantpairs.df[ ,c("chr2", "start2", "end2", "logFC", "DIRindex")]
message("BED2 file has been created.")
#
############################ save bed files ############################
saveRDS(object = bed1, file = opt$output_bed1)
saveRDS(object = bed2, file = opt$output_bed2)
message("BED files have been saved as RDS files.\n")
