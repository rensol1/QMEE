## W3 Assignment

#Libraries ----
library(tidyverse)
library(ggplot2); theme_set(theme_bw(base_size=14))
library(performance)
library(patchwork)

###This script uses the rds file created by "W2_withRDS.R" 

#Read rds file to obtain data ----
green_space_data <- readRDS(file = "greenspaceTable.rds")

#Boxplot created for previous assignment ----
print(ggplot(data = green_space_data, aes(x = animal, y = species.richness )) 
      + geom_boxplot() 
)
#This boxplot displays the species richness of bird and butterfly, and summarizes information such as the median, the upper and lower quartiles, interquartile range, and the highest and lowest values.  
#However, it doesn't display the underlying distribution of the data in the groups.
#The following boxplot adds jitter on top to display the data points: ----

species.hist <- (ggplot(data = green_space_data, aes(x = animal, y = species.richness )) 
      + geom_boxplot() 
      + geom_jitter() 
)
print(species.hist)
#This could reveal information not available without the underlying distribution of data.
#For example, it could be the case that the groups have different sample sizes, which you could not see without the jitter. 
#It would also reveal whether the data have unimodal or multimodal distributions.

#Species richness of bird and butterfly plotted as a function of Area (ha) ----
species.line <- (ggplot(data = green_space_data, aes(x = area.ha, y = species.richness, colour = animal))
      + geom_point() 
      + geom_line()
      + labs(x="Area (ha)", y="Species Richness")
)
print(species.line)
#According to the Cleveland hierarchy, the best graphical feature for plots is to have points positioned along a common scale
#This graph plots the species richness for both bird and butterfly along the common scale for Area
#It also adds simple features like points and connecting lines, which help display the data
#Colour helps to distinguish between groups or categories. In this case, the orange points and lines display the bird data, and the blue points and lines display the butterlfy data

#I can use the patchwork package to display the plots together
#Stacking on top of each other: ----
stacked <- species.hist/species.line 
print(stacked)
#Having close proximity of my plots makes it easier to compare them. This would be more useful if the two plots were the same type (e.g. two histograms, or two line plots), but I don't have more data to demonstrate this

#Create linear model and check model assumptions 
lm1 <- lm(species.richness ~ area.ha, green_space_data)
check_model(lm1)
#check_model() is a very useful function because it creates and displays multiple plots to examine the model assumptions (i.e. posterior predictive check, linearity, homogeneity of variance, influential observations, and normalty of residuals)
#I find it very helpful that along with the names of the tests, it gives a brief explanation of what the graph should look like

