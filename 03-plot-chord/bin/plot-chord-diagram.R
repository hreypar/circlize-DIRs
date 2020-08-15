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

########################## functions ###################################
# it's dangerous to go alone! take this.
#
#################### Separate BED by chromosome ########################
#
######################### read in data #################################

## READ IN BED1 AND BED2
## THEN SEPARATE EACH BED BY CHROMOSOME (MAKE A LIST?)
## IF THERE IS NO DATA IN A LIST MEMBER, ADD EMPTY DATA TO

## CREATE LAYOUT WITH 6x4 PLOTS
## FOR EACH OF THEM DO THE IDEOGRAM AND THE LINK TRACKS


#### SEE HOW TO ADD A TITLE AND HOW TO MAKE LABELS LARGER
#### ALSO PLOT THE CHROMOSOME NAME FOR EACH CHORD DIAGRAM
#### ADD ONE LEGEND FOR logFC COLOURS


#### IF A FLAG IS TRUE DRAW THE PDF INDIVIDUAL PLOTS
#### IF ANOTHER FLAG IS TRUE DRAW THE INDIVIDUAL PLOTS EACH A PNG

circos.clear()

# get the colors that I used for the barplot of number of DIRs
color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                       colors = c("blue", "white", "red"), transparency = 0)

circos.par("start.degree" = 90, "gap.degree" = 4)

circos.initializeWithIdeogram(ideogram.height = 0.05, major.by = 5000000, species = "hg38", chromosome.index = "chr9", 
                              plotType = c("ideogram", "axis", "labels"))

circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)

############################################################################
## CREATE LOTS OF PLOTS IN ONE PLOT

# colour function
color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                      colors = c("blue", "white", "red"), transparency = 0)
# Arrange the layout
layout(matrix(1:24, 4, 6)) 

# A loop to create 23 circular plots
for(i in 1:23) {
  par(mar = c(0.25, 0.25, 0.25, 0.25), bg=rgb(1,1,1,0.1) )

  # parameters
  circos.par("start.degree" = 90, "gap.degree" = 4, "cell.padding" = c(0, 0, 0, 0))
  
  # add ideogram
  circos.initializeWithIdeogram(ideogram.height = 0.05, major.by = 5000000,
                                species = "hg38", chromosome.index = "chr9", 
                                plotType = c("ideogram", "axis", "labels"))
  
  # add links
  circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)

  circos.clear()
}


