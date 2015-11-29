# Plot increase in O3 from reference temperature in TI and TD Runs, each mechanism and NOx Condition
# Version 0: Jane Coates 29/11/2015

setwd("~/Documents//LaTeX//Posters//2015_AGU//Plotting")
runs <- c("Dependent", "Independent")
mechanisms <- c("MCMv3.2", "CRIv2", "MOZART-4", "CB05", "RADM2")

data.list <- lapply(runs, get_all_mixing_ratio_data)
data.df <- do.call("rbind", data.list)
tbl_df(data.df)

adapted <- data.df %>%
  arrange(Temperature) %>%
  rowwise() %>%
  mutate(NOx.Condition = get_NOx_condition(H2O2/HNO3), Temperature.C = Temperature - 273) %>%
  select(Run, Mechanism, Temperature.C, O3, NOx.Condition) %>%
  group_by(Run, Mechanism, Temperature.C, NOx.Condition) %>%
  summarise(O3 = mean(O3))
adapted$NOx.Condition <- factor(adapted$NOx.Condition, levels = c("Low-NOx", "Maximal-O3", "High-NOx"))
adapted$Mechanism <- factor(adapted$Mechanism, levels = c("MCMv3.2", "CRIv2", "MOZART-4", "CB05", "RADM2"))

hline.data <- adapted %>%
  filter(Temperature.C == 20)

p <- ggplot(adapted, aes(x = Temperature.C, y = O3))
p <- p + geom_line(size = 1, aes(linetype = Run))
p <- p + geom_vline(x = 20, colour = "#4b97b6")
p <- p + geom_segment(aes(x = 15, xend = 40, y = O3, yend = O3), hline.data, colour = "#4b97b6")
p <- p + facet_grid(Mechanism ~ NOx.Condition)
p <- p + plot_theme()
p <- p + ggtitle("Percent Increase from 20°C from Chemistry and Emissions")
p <- p + theme(legend.position = "top")
p <- p + theme(legend.key.size = unit(2, "cm"))
p <- p + theme(legend.title = element_blank())
p <- p + ylab("O3 (ppbv)") + xlab(expression(bold(paste("Temperature (", degree, "C)"))))
p <- p + scale_x_continuous(limits = c(15, 45), breaks = seq(15, 40, 5), expand = c(0, 0))
p <- p + scale_y_continuous(expand = c(0, 0))
p

CairoPDF(file = "Increase_in_O3.pdf", width = 7, height = 10)
print(p)
dev.off()
