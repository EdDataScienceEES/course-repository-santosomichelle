#Tutorial: Efficient Data Manipulation in R
#Name: Michelle Santoso
#Date: October 14, 2021

# PACKAGE LIBRARIES FOR THIS TUTORIAL
library(dplyr)     # for data manipulation
library(ggplot2)   # for making graphs

# LOAD DATA
trees <- read.csv(file = "trees.csv", header = TRUE)

head(trees) 

# GROUP BY SPECIES
trees.grouped <- group_by(trees, CommonName)   

# CREATE NEW TABLE SHOWING POPULATION OF EACH TREE SPECIES
trees.summary <- summarise(trees.grouped, count = length(CommonName)) 

# GROUP AND COUNT THROUGH PIPES
trees.summary <- trees %>%    # the data frame object that will be passed in the pipe
  group_by(CommonName) %>%    # name grouping variable (not object)
  tally()                     # and we don't need anything at all here, it has been passed through the pipe!

# Important notes: Pipes only work on data frame objects, and functions outside the tidyverse often require that you specify the data source with a full stop dot .. But as we will see later, you can still do advanced things while keeping these limitations in mind!
  
# CLASSIFY 'Common Ash', 'Rowan', 'Scots Pine' BY AGE GROUP AND POPULATION
trees.subset <- trees %>%
  filter(CommonName %in% c('Common Ash', 'Rowan', 'Scots Pine')) %>%  # filter common ash, rowan, and scots pine
  group_by(CommonName, AgeGroup) %>%                                  # name grouping variables as species and age group
  tally()

# GENERATE SUMMARY DATAFRAME
summ.all <- summarise_all(trees, mean.default)

# TRUE VS. FALSE FOR CONDITIONAL STATEMENTS
vector <- c(4, 13, 15, 6)      # create a vector to evaluate
ifelse(vector < 10, "A", "B")  # give the conditions: if inferior to 10, return A, if not, return B

# CASE_WHEN() COMMAND TO RECLASSIFY VARIALBES
vector2 <- c("What am I?", "A", "B", "C", "D")

case_when(vector2 == "What am I?" ~ "I am the walrus",
          vector2 %in% c("A", "B") ~ "goo",
          vector2 == "C" ~ "ga",
          vector2 == "D" ~ "joob")

# CREATE A FULL LIST OF ALL TREE SPECIES IN DATA

unique(trees$LatinName)  # Shows all the species names
  
trees.genus <- trees %>%
  mutate(Genus = case_when(               # creates new species column and specifies conditions
    grepl("Acer", LatinName) ~ "Acer",
    grepl("Fraxinus", LatinName) ~ "Fraxinus",
    grepl("Sorbus", LatinName) ~ "Sorbus",
    grepl("Betula", LatinName) ~ "Betula",
    grepl("Populus", LatinName) ~ "Populus",
    grepl("Laburnum", LatinName) ~ "Laburnum",
    grepl("Aesculus", LatinName) ~ "Aesculus", 
    grepl("Fagus", LatinName) ~ "Fagus",
    grepl("Prunus", LatinName) ~ "Prunus",
    grepl("Pinus", LatinName) ~ "Pinus",
    grepl("Sambucus", LatinName) ~ "Sambucus",
    grepl("Crataegus", LatinName) ~ "Crataegus",
    grepl("Ilex", LatinName) ~ "Ilex",
    grepl("Quercus", LatinName) ~ "Quercus",
    grepl("Larix", LatinName) ~ "Larix",
    grepl("Salix", LatinName) ~ "Salix",
    grepl("Alnus", LatinName) ~ "Alnus")
  )

# GROUP TREES BY HEIGHT 

trees.genus <- trees.genus %>%   # overwriting our data frame 
  mutate(Height.cat =   # creating our new column
           case_when(Height %in% c("Up to 5 meters", "5 to 10 meters") ~ "Short",
                     Height %in% c("10 to 15 meters", "15 to 20 meters") ~ "Medium",
                     Height == "20 to 25 meters" ~ "Tall")
  )

# REORDER FACTORS LEVELS

levels(trees.genus$Height.cat)  # shows the different factor levels in their default order

trees.genus$Height.cat <- factor(trees.genus$Height.cat,
                                 levels = c('Short', 'Medium', 'Tall'),   # whichever order you choose will be reflected in plots etc
                                 labels = c('SHORT', 'MEDIUM', 'TALL')    # Make sure you match the new names to the original levels!
)   

levels(trees.genus$Height.cat)  # a new order and new names for the levels

# LOAD GGPLOT

install.packages("ggplot2")
library(ggplot2)


# SUBSET DATA FRAME TO FEWER SPECIES 

trees.five <- trees.genus %>%
  filter(Genus %in% c("Acer", "Fraxinus", "Salix", "Aesculus", "Pinus"))

# MAP ALL THE TREES

(map.all <- ggplot(trees.five) +
    geom_point(aes(x = Easting, y = Northing, size = Height.cat, colour = Genus), alpha = 0.5) +
    theme_bw() +
    theme(panel.grid = element_blank(),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 12))
)

# PLOT MAP FOR EACH TREE SPECIEFS


tree.plots <-  
  trees.five  %>%      # the data frame
  group_by(Genus) %>%  # grouping by genus
  do(plots =           # the plotting call within the do function
       ggplot(data = .) +
       geom_point(aes(x = Easting, y = Northing, size = Height.cat), alpha = 0.5) +
       labs(title = paste("Map of", .$Genus, "at Craigmillar Castle", sep = " ")) +
       theme_bw() +
       theme(panel.grid = element_blank(),
             axis.text = element_text(size = 14),
             legend.text = element_text(size = 12),
             plot.title = element_text(hjust = 0.5),
             legend.position = "bottom")
  ) 

# VIEW GRAPHS
tree.plots$plots

# SAVE PLOTS TO FILE

tree.plots %>%              # the saving call within the do function
  do(., 
     ggsave(.$plots, filename = paste(getwd(), "/", "map-", .$Genus, ".png", sep = ""), device = "png", height = 12, width = 16, units = "cm"))

# Change working directory
setwd("~/Desktop/Data_Science_ESS/Efficient_Data_Manipulation_in_R/course-repository-santosomichelle")

# Change working directory
setwd("https://github.com/EdDataScienceEES/course-repository-santosomichelle.git")




