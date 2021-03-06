#!/usr/bin/env Rscript
#
# hreyes August 2020
# plot-chord-diagram.R
########################################################################
# Read in two BED files of DIRs and plot them in a circos like 
# diagram
########################################################################
#################### import libraries and set options ##################
suppressMessages(library(circlize))
library(optparse)
message("\nRequired libraries have been loaded.")
#
multiple.chromosomes <- c("chr1", "chr7", "chr13", "chr19",
                          "chr2", "chr8", "chr14", "chr20",
                          "chr3", "chr9", "chr15", "chr21",
                          "chr4", "chr10", "chr16", "chr22",
                          "chr5", "chr11", "chr17", "chrX",
                          "chr6", "chr12", "chr18")
#
individual.chromosomes <- c(paste0("chr", seq(1,22,1)), "chrX")
#
option_list = list(
  make_option(opt_str = c("-i", "--input_bed1"), 
              type = "character",
              help = "Input BED1 of significant pairs as an Rds file."),
  make_option(opt_str = c("-j", "--input_bed2"), 
              type = "character", 
              help = "Input BED2 of significant pairs as an Rds file."),
  make_option(opt_str = c("-o", "--out_plot"), 
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
  } else if (type == "multiple") {
    chrs <- factor(chrs, levels = multiple.chromosomes)
  }
  return(chrs)
}
#
####################### set colours to use #############################
colour_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                       colors = c('#ff3633', "grey",'#0c007a'), 
                       transparency = 0.2)
#
####################### basic chord function ###########################
basic_chord <- function(b1, b2, chr.ind, main.title) {
  
  # begin plotting chromosome on top, separate the chromosome ends by 4.
  circos.par("start.degree" = 90, "gap.degree" = 4)
  
  # plot the ideogram aka cytoband
  circos.initializeWithIdeogram(ideogram.height = 0.05,
                                species = "hg38", 
                                chromosome.index = chr.ind, 
                                plotType = c("ideogram"))
  # plot the axis with ticks each 5Mb.
  circos.genomicAxis(major.by = 5000000, labels.cex = 1.15)
  # plot the DIRs as links.
  circos.genomicLink(b1, b2, 
                     col = colour_fun(b1$logFC),
                     border = NA)
  
  title(main = main.title, sub = chr.ind, 
        cex.main = 2, cex.sub = 3.5, 
        line = -0.5, adj = 0.05,
        font.main = 2, font.sub = 2)
  
  circos.clear()
}
######################## plot each chromosome ##########################
plot_individual_chords <- function(bed1, bed2) {

  # Split BEDs by chromosome
  bed1 <- split(x = bed1, f = bed1$chr1, drop = TRUE)
  bed2 <- split(x = bed2, f = bed2$chr2, drop = TRUE)
  
  # obtain this comparisons name
  comparison = gsub("\\.chord_diagram", "", gsub(".+__", "", opt$out_plot))
  
  # generate main title for this plot
  this.main = paste("Differentially Interacting Regions", comparison)

  ##############################
  # One PDF file for all plots
  ##############################
  
  pdf(file = paste0(opt$out_plot, "_byChr.pdf"), width = 18, height = 18)

  mapply(basic_chord, bed1, bed2, chr.ind = names(bed1), main.title = this.main)
  
  dev.off()
  
  message(paste("One PDF file with", length(bed1), "chord plots has been created."))
  
  ##############################
  # One PNG file for each chromosome
  ##############################
  
  # create directory for plots
  individuals.directory = paste0(dirname(opt$out_plot),
                                 "/individual-chromosomes-",
                                 comparison, "/")
  dir.create(individuals.directory, recursive = TRUE, showWarnings = FALSE)
  
  # create basic name for plots
  individuals.name = paste0(individuals.directory, comparison, ".chord_diagram")
  
  # call plotting function for each list element
  lapply(names(bed1), function(chr) {
  
    png(filename = paste0(individuals.name, "_", chr, ".png"), 
        width = 14, height = 14, units = "in", res = 350)
    
    basic_chord(b1 = bed1[[chr]], b2 = bed2[[chr]], chr.ind = chr, main.title = this.main)
    
    dev.off()
  })
  
  message(paste(length(bed1), "PNG files (each with one chord plot) have been created."))
}
#
######################## plot all chromosomes ##########################
plot_multiple_chords <- function(bed1, bed2) {
  
  # Split BEDs by chromosome keeping all factors
  bed1 <- split(x = bed1, f = bed1$chr1, drop = FALSE)
  bed2 <- split(x = bed2, f = bed2$chr2, drop = FALSE)
  
  # obtain this comparisons name
  comparison = gsub("\\.chord_diagram", "", gsub(".+__", "", opt$out_plot))
  
  # generate main title for this plot
  this.main = paste("Differentially Interacting Regions", comparison)
  
  png(paste0(opt$out_plot, ".png"), width = 18, height = 12, units = "in", res = 300)
  # Arrange the layout WITH 6x4 PLOTS
  
  par(oma = c(0, 0, 4, 0))
  
  layout(matrix(1:24, 4, 6))
  
  # A loop to create 23 circular plots
  for(i in 1:23) {
    
    if(nrow(bed1[[i]]) == 0) {
      plot.new()
      next
    }
    
    par("mar"=c(0.2, 0.2, 0.2, 0.2))
    
    circos.par("start.degree" = 90, "gap.degree" = 4)

    
    # plot the ideogram aka cytoband
    circos.initializeWithIdeogram(ideogram.height = 0.05,
                                  species = "hg38", 
                                  chromosome.index = names(bed1[i]), 
                                  plotType = c("ideogram"))
    
    # plot the axis with ticks each 5Mb.
    circos.genomicAxis(major.by = 5000000, labels.cex = 0.5)
    
    # plot the DIRs as links.
    circos.genomicLink(bed1[[i]], bed2[[i]], 
                       col = colour_fun(bed1[[i]]$logFC),
                       border = NA)
    
    title(main = "", sub = names(bed1[i]), 
          cex.main = 0.1, cex.sub = 2, 
          line = -1.5, adj = 0.05,
          font.main = 2, font.sub = 2)
    
    mtext(this.main, outer = TRUE, line = 1, cex = 1.5)
    
    circos.clear()
  }
  
  dev.off()
  message(paste("A PNG plot with", i, "chord diagrams has been created\n"))
}
#
message("Required functions have been loaded.")
########################################################################
# MAIN CODE #
######################### read in data
my.bed1 <- readRDS(opt$input_bed1)
my.bed2 <- readRDS(opt$input_bed2)

# check that the BEDs are paired
if(FALSE %in% (my.bed1$DIRindex == my.bed2$DIRindex)) {
  stop("The BED files DON'T contain paired DIRs.")
}
#
########################## Individual plots 
# If each_chromosome is true, produce individual plots
if(opt$each_chromosome) {
  
  # idk if this is wise but the factoring of chr is dynamic
  my.bed1$chr1 <- format_chromosomes(my.bed1$chr1, type = "individual")
  my.bed2$chr2 <- format_chromosomes(my.bed2$chr2, type = "individual")
  
  # call function
  plot_individual_chords(bed1 = my.bed1, bed2 = my.bed2)
}
#
######################### All together plots
# Produce the multiple chord plot
my.bed1$chr1 <- format_chromosomes(my.bed1$chr1, type = "multiple")
my.bed2$chr2 <- format_chromosomes(my.bed2$chr2, type = "multiple")

plot_multiple_chords(bed1 = my.bed1, bed2 = my.bed2)


#### PENDIENTES ####
# ADD ONE LEGEND FOR logFC COLOURS
# ADD RESOLUTION TO THE TITLES