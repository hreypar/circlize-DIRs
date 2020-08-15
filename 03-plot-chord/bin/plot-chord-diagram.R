#!/usr/bin/env Rscript
#
# hreyes August 2020
# plot-chord-diagram.R
########################################################################
# Read in two BED files of DIRs and plot them in a circos like 
# diagram
########################################################################
#
#################### import libraries and set options ##################
suppressMessages(library(circlize))
library(optparse)
message("\nRequired libraries have been loaded.")
#
chord.chromosomes <- c("chr1", "chr7", "chr13", "chr19",
  "chr2", "chr8", "chr14", "chr20",
  "chr3", "chr9", "chr15", "chr21",
  "chr4", "chr10", "chr16", "chr22",
  "chr5", "chr11", "chr17", "chrX",
  "chr6", "chr12", "chr18")
#
########################## read in data ################################
option_list = list(
  make_option(opt_str = c("-i", "--input_bed1"), 
              type = "character",
              help = "Input BED1 of significant pairs as an Rds file."),
  make_option(opt_str = c("-j", "--input_bed2"), 
              type = "character", 
              help = "Input BED2 of significant pairs as an Rds file."),
  make_option(opt_str = c("-o", "--output_plot"), 
              type = "character", 
              help = "File name (including path but NO extension) for the chord diagram."),
  make_option(opt_str = c("-e", "--each_chromosome"), 
              type = "logical", 
              help = "logical: Should every chromosome be plotted individually?")
)

opt <- parse_args(OptionParser(option_list=option_list))

if (is.null(opt$input_bed1) | is.null(opt$input_bed2)){
  print_help(OptionParser(option_list=option_list))
  stop("TWO BED input files are mandatory.n", call.=FALSE)
}
#
########################## functions ###################################
# it's dangerous to go alone! take this.
#
######################## format chromosomes ############################
format_chromosomes <- function(chrs) {
  chrs <- replace(x = chrs, chrs == "chr23", "chrX")
  chrs <- factor(chrs, levels = chord.chromosomes)
#  chrs <- droplevels(chrs)
  return(chrs)
}
########################################################################
######################### read in data #################################
bed1 <- readRDS(opt$input_bed1)
bed2 <- readRDS(opt$input_bed2)

# check that the BEDs are paired
matches = bed1$DIRindex == bed2$DIRindex
if(FALSE %in% matches) {
  stop("The BED files DON'T contain paired DIRs.")
}
############### format the chromosome columns ##########################
bed1$chr1 <- format_chromosomes(bed1$chr1)
bed2$chr2 <- format_chromosomes(bed2$chr2)
#
#################### Split BEDs by chromosome ##########################
bed1 <- split(x = bed1, f = bed1$chr1, drop = FALSE)
bed2 <- split(x = bed2, f = bed2$chr2, drop = FALSE)
#
############################### PLOTS ##################################
# If each chromosome is true, produce individual plots
if(opt$each_chromosome) {
  
  # PDF file with all plots
  pdf(file = )
  
  color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                         colors = c('#0c007a', "grey", '#ff3633'), transparency = 0)
  
  circos.par("start.degree" = 90, "gap.degree" = 4)
  
  circos.initializeWithIdeogram(ideogram.height = 0.05, major.by = 5000000, species = "hg38", chromosome.index = "chr9", 
                                plotType = c("ideogram", "axis", "labels"))
  
  circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)
  
  circos.clear()
  

}


## CREATE LAYOUT WITH 6x4 PLOTS

## FOR EACH NAME ON THE LIST DO THE IDEOGRAM AND THE LINK TRACKS
## IF THERE IS NO DATA IN A LIST MEMBER, ADD EMPTY CHR PLOT


#### SEE HOW TO ADD A TITLE AND HOW TO MAKE LABELS LARGER
#### ALSO PLOT THE CHROMOSOME NAME FOR EACH CHORD DIAGRAM
#### ADD ONE LEGEND FOR logFC COLOURS


############################################################################
## CREATE LOTS OF PLOTS IN ONE PLOT

# colour function
color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                      colors = c('#0c007a', "grey", '#ff3633'), transparency = 0)
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


