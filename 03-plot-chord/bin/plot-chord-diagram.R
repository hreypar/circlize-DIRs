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
individual.chromosomes <- c(paste0("chr", seq(1,22,1)), "chrX")
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
format_chromosomes <- function(chrs, type) {
  # replace chr23 for chrX
  chrs <- replace(x = chrs, chrs == "chr23", "chrX")
  
  # use factors depending on type of formatting
  if(type == "individual") {
    chrs <- factor(chrs, levels = individual.chromosomes)
  } else if (type == "chord") {
    chrs <- factor(chrs, levels = chord.chromosomes)
  }
  return(chrs)
}
#
######################## plot each chromosome ##########################
plot_individual_chords <- function(b1, b2) {

  # Split BEDs by chromosome
  b1 <- split(x = b1, f = b1$chr1, drop = TRUE)
  b2 <- split(x = b2, f = b2$chr2, drop = TRUE)
  
  # Set colours to use
  color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                         colors = c('#0c007a', "grey", '#ff3633'), transparency = 0)
  
    # PDF file for all plots
  pdf(file = paste0(opt$output_plot, "_byChr.pdf"), width = 18, height = 18)
  
  lapply(names(b1), function(chr) { 
  
  circos.par("start.degree" = 90, "gap.degree" = 4)
  
  circos.initializeWithIdeogram(ideogram.height = 0.05,
                                species = "hg38", 
                                chromosome.index = chr, 
                                plotType = c("ideogram"))
  
  circos.genomicAxis(major.by = 5000000, labels.cex = 1.25)
  
  circos.genomicLink(b1[[chr]], b2[[chr]], 
                     col = color_fun(b1[[chr]]$logFC),
                     border = NA)
  
  title(paste("tururu", "tuii tuiii"), sub = chr, line = -2)
  
  circos.clear()
  
  })
  
  dev.off()
  
  # one PNG for each chromosome
  
 # dir.create("results/lala/turu", recursive = TRUE)
}
#
######################## multiple chord plot ##########################
plot_multiple_chords <- function() {
  ## CREATE LOTS OF PLOTS IN ONE PLOT
  
  # colour function
  color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                         colors = c('#0c007a', "grey", '#ff3633'), transparency = 0)
  # Arrange the layout WITH 6x4 PLOTS
  layout(matrix(1:24, 4, 6)) 
  
  # A loop to create 23 circular plots
  for(i in 1:23) {
    par(mar = c(0.25, 0.25, 0.25, 0.25), bg=rgb(1,1,1,0.1) )
    
    # parameters
    circos.par("start.degree" = 90, "gap.degree" = 4, "cell.padding" = c(0, 0, 0, 0))
    
    # add ideogram
    circos.initializeWithIdeogram(ideogram.height = 0.5, major.by = 5000000,
                                  species = "hg38", chromosome.index = "chr9", 
                                  plotType = c("ideogram", "axis", "labels"))
    
    # add links
    circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)
    
    circos.clear()
  }
}
#
########################################################################
# MAIN CODE #
######################### read in data #################################
bed1 <- readRDS(opt$input_bed1)
bed2 <- readRDS(opt$input_bed2)

# check that the BEDs are paired
if(FALSE %in% (bed1$DIRindex == bed2$DIRindex)) {
  stop("The BED files DON'T contain paired DIRs.")
}
#
############################### PLOTS ##################################
# If each chromosome is true, produce individual plots
if(opt$each_chromosome) {
  
  # idk if this is wise but the factoring of chr is dynamic
  bed1$chr1 <- format_chromosomes(bed1$chr1, type = "individual")
  bed2$chr2 <- format_chromosomes(bed2$chr2, type = "individual")
  
  # call function
  plot_individual_chords(b1 = bed1, b2 = bed2)
  message("A Chord plot for each chromosome has been produced.")
}


# Produce the multiple chord plot



#### SEE HOW TO ADD A TITLE AND HOW TO MAKE LABELS LARGER
#### ALSO PLOT THE CHROMOSOME NAME FOR EACH CHORD DIAGRAM
#### ADD ONE LEGEND FOR logFC COLOURS
