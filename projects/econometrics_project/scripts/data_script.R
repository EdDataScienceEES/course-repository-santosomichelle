# Visualization of microplastics in the seas of Scotland
# Group 1 
# GitHub Usernames: matusseci, filoteea, darahubert, annashulman, lubin-g, 
# santosomichelle
# 28/10/2021 - 04/11/2021

# Install missing libraries ----
# install.packages("tidyverse")  
# install.packages("janitor")

# Load libraries ----
library(tidyverse)  # data manipulation and visualization
library(janitor)    # clean the names


# Import data ----
microplastics <- read.csv("inputs/microplastics.csv")


# Data manipulation ----

# This should work as the dataset for the map as well
microplastics_reduced <- microplastics %>%
  # Clean the names in the dataset
  clean_names() %>%
  # Select only relevant columns - only contains microplastics in mm/m3
  # i.e. no macroplastics or mm/km2 data
  dplyr::select(year, dec_lat_retrieve, dec_long_retrieve, 
                sum_micro_m3, fibres_lte5mm_m3:paint_flakes_lte5mm_m3) %>%
  # Filter out zero values in microplastics
  dplyr::filter(sum_micro_m3 != 0)


# Dataset for the lollipop plot
micropl