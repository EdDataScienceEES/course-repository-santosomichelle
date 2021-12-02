# Introduction ---- 

  # Coding Club Tutorial - Intro to Google Earth Engine
  # December 1, 2021
  # Michelle Santoso, github: santosomichelle

# Libraries ----

# for data viz
library(ggplot2)  
# to set colorblind-friendly theme
library(viridis) 
# to reorder categorical variables
library(forcats)  

# Install libraries ----

# Uncomment lines 14, 15, and/or 16 to install libraries
# install.packages("ggplot2")  
# install.packages("viridis")
# install.packages("forcats")

# Import data ----

# Load forest gain summary table
gain <- read.csv("data/inputs/protected_forest_gain.csv")

# Load forest loss summary table
loss <- read.csv("data/inputs/protected_forest_loss.csv")

# Data manipulation ----

# Create identifier column for gain vs loss
gain$type <- "Gain"
loss$type <- "Loss"

# Bind the objects together
change <- rbind(gain, loss)

# Data Viz ----

# Create graph to visualise change in forest cover  
(change_barplot <- ggplot(change, aes(
                            # set x values as name of protected area
                            x = NAME,
                            # set y-values to percentage change
                            # instead of integer change of forest cover
                            y = (sum/GIS_AREA) * 100,
                            # set factor as type (gain/loss)
                            fill = fct_rev(type))) +
   # set geom function to barplot
   geom_bar(stat = "identity", position = "dodge") +
    # set axis labels 
    labs(x = NULL, 
         y = "Forest change (% of park area)\n",
         caption = "Forest cover data source: Hansen et al., Science 2013") +
    # expand scale to remove empty space below  bars
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_discrete(expand = c(0, 0)) +
    # increase font size
    theme(text = element_text(size = 16),  
          # set legend placement 
          legend.position = c(0.1, 0.85),  
          # remove legend title
          legend.title = element_blank(), 
          legend.background = element_rect(
            # set legend border to black
            color = "black",
            # set fill to transparent
            fill = "transparent",
            # delete border line
            linetype = "blank"),
          # set panel background and border colour
          panel.background = element_rect(fill = "#fff8f2",
                                          color = "#fff8f2"),
          # set subtle grid
          panel.grid.major = element_line(color = "#dbdbd9", 
                                          size = 0.2),
          # remove minor grid
          panel.grid.minor = element_blank(),
    ))
          
# Save barplot

ggplot2::ggsave('data/outputs/forestcoverchange_barplot.png', device = 'png', 
       width = 10, height = 8, units = 'in')


