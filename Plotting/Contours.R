# Plot contours,  facet run ~ mechanism
# Version 0: Jane Coates 23/11/2015

setwd("~/Documents//LaTeX/Posters//2015_AGU//Plotting")
runs <- c("Dependent", "Independent")
mechanisms <- c("CRIv2", "MOZART-4", "CB05", "RADM2", "MCMv3.2")
spc <- "O3"

list <- lapply(runs, read_mixing_ratio_data, spc = spc, mechanisms = mechanisms)
df <- do.call("rbind", list)
p <- plot_contours(df, spc)
p <- p + theme(panel.margin.y = unit(1, "mm"))
p <- p + scale_colour_gradient(low = "#44c9ff", high = "#4b97b6")
p <- p + ggtitle("Ozone Mixing Ratios in ppbv as a Function of NOx and Temperature")
direct.label(p)

CairoPDF(file = "O3_comparison.pdf", width = 7, height = 10)
p1 = direct.label(p, list("top.pieces", cex = 0.7))
p2 = ggplot_gtable(ggplot_build(p1))
p2$layout$clip[p2$layout$name == "panel"] = "off"
print(grid.draw(p2))
dev.off()

# print(direct.label(p, list("top.pieces", cex = 0.7)))