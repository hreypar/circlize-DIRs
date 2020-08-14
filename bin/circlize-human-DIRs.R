#!/usr/bin/env Rscript
#
# hreyes August 2020
# circlize-human-DIRs.R
########################################################################
# Read in a list of filtered DIRs and plot them in a circos like 
# diagram
########################################################################
#
#################### import libraries and set options ##################
suppressMessages(library(circlize))
#
# input options
args = commandArgs(trailingOnly=TRUE)
#
########################## functions ###################################
# it's dangerous to go alone! take this.
#
################## Create BED from table of DIRs. ######################
create_bed <- function() {

}
#
#################### Separate BED by chromosome ########################
#
######################### read in data #################################
significant.dirs <- readRDS(args[1])

## FIRST READ IN SIGNIFICANT DIRS DATA
## MAYBE ADD A DIR INDEX TO AVOID LOSING TRACK
## THEN CREATE BED1 AND BED2
## THEN SEPARATE EACH BED BY CHROMOSOME

## CREATE LAYOUT WITH 6x4 PLOTS
## FOR EACH OF THEM DO THE IDEOGRAM AND THE LINK TRACKS

#### SEE HOW TO ADD A TITLE AND HOW TO MAKE LABELS LARGER
#### ALSO PLOT THE CHROMOSOME NAME FOR EACH CHORD DIAGRAM
#### ADD ONE LEGEND FOR logFC COLOURS


## THe bloody chromosome
bed1 = test[ ,c("chr1", "start1", "end1", "logFC")]
bed2 = test[ ,c("chr2", "start2", "end2", "logFC")]

circos.clear()

# get the colors that I used for the barplot of number of DIRs
color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                       colors = c("blue", "white", "red"), transparency = 0)

circos.par("start.degree" = 90, "gap.degree" = 4)

circos.initializeWithIdeogram(species = "hg38", chromosome.index = "chr9", plotType = c("ideogram", "axis", "labels"))

circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)


