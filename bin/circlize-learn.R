#!/usr/bin/env Rscript
#
# hreyes August 2020
# circlize-learn.R
###################################################################
# learn how to use the circlize package
###################################################################
suppressMessages(library(circlize))
###################################################################
# A character vector to represent categories
# A numeric vector of x values 
# A vector of y values.

set.seed(999)
n = 1000
df = data.frame(factors = sample(letters[1:8], n, replace = TRUE),
                x = rnorm(n), y = runif(n))


# set track.height to 0.1 
# so that all tracks which will be added have a default height of 0.1
# The circle used by circlize always has a radius of 1, 
# so a height of 0.1 means 10% of the circle radius.
circos.par("track.height" = 0.1)

# df$x is split by df$factors 
# the width of sectors are automatically calculated, 
# based on data ranges in each category.
circos.initialize(factors = df$factors, x = df$x)

# THE ALLOCATION OF SECTORS ONLY NEEDS VALUES ON X DIRECTION (circular direction)
# THE VALUES ON Y DIRECTION WILL BE USED IN THE STEP OF CREATING TRACKS (radial direction)

# Since x-ranges for cells in the track have already been defined
# in the initialization step.
#
# Here we only need to specify the y-range for each cell. 
#
# The y-ranges can be specified by y argument as a numeric vector 
# (so that y-range will be automatically extracted and calculated in each cell)
circos.track(factors = df$factors, y=df$y, 
             panel.fun = function(x, y) {
               circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + mm_y(5),
                           CELL_META$sector.index)
               circos.axis(labels.cex = 0.6)
             })

col = rep(c("#FF0000", "#00FF00"), 4)
circos.trackPoints(df$factors, df$x, df$y, col = col, pch = 16, cex = 0.5)
circos.text(-1, 5, "texty", sector.index = "d", track.index = 1)


# CHORDS
set.seed(999)
mat = matrix(sample(18, 18), 3, 6) 
rownames(mat) = paste0("S", 1:3)
colnames(mat) = paste0("E", 1:6)

df = data.frame(from = rep(rownames(mat), times = ncol(mat)),
                to = rep(colnames(mat), each = nrow(mat)),
                value = as.vector(mat),
                stringsAsFactors = FALSE)

chordDiagram(mat)


## THe bloody chromosome
bed1 = test[ ,c("chr1", "start1", "end1", "logFC")]
bed2 = test[ ,c("chr2", "start2", "end2", "logFC")]

circos.clear()

color_fun = colorRamp2(breaks = c(-0.00001, 0, 0.00001), 
                       colors = c("blue", "white", "red"), transparency = 0)

circos.par("start.degree" = 90, "gap.degree" = 4)

circos.initializeWithIdeogram(species = "hg38", chromosome.index = "chr9", plotType = c("ideogram", "axis", "labels"))

circos.genomicLink(bed1, bed2, col = color_fun(bed1$logFC), border = NA)


