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
survey <- read.csv("data/inputs/survey_responses.csv")


# Data manipulation ----

# Table dataset 
survey_reduced <- survey %>% 
  # Rename variables
  rename(gender = What.is.your.sex.assigned.at.birth.,
                  c_height = How.tall.are.you.in.cm.,
                  m_height = How.tall.is.your.genetic.mother.in.cm.,
                  d_height = How.tall.is.your.genetic.father.in.cm.) %>%
  # # Select only relevant columns for Galton regression 
  # i.e. children height, children gender, and biological parents heights)
  select(gender, c_height, m_height, d_height) %>% 
  # Adjust heights by transmuting female heights by a factor of 1.08
  mutate(adj_c_height = c_height %>% 
           case_when(gender = Female, c_height = c_height*1.08)) %>% 
  # Calculate mean heights of parents 
  mutate(mean_am_heights = mean(m_height, d_height))
  


# Dataset for the lollipop plot
micropl