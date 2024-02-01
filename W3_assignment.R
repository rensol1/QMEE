## W3 Assignment

#Libraries ----
library(ggplot2); theme_set(theme_bw(base_size=14))
library(performance)
library(patchwork)
library(DHARMa)

###This script uses the rds file created by "W2_assignment.R" 
## BMB: nice.

#Read rds file to obtain data ----
green_space_data <- readRDS(file = "greenspaceTable.rds")

## BMB: I like to fill in boxplots (see Wilke's book)
## adding the notch gives approx confidence intervals on the median
## (sometimes useful)

#Boxplot created for previous assignment ----
print(ggplot(data = green_space_data, aes(x = animal, y = species.richness )) 
      + geom_boxplot(fill = "gray", notch  = TRUE) 
      )

## BMB: if you're going to plot the same variables in different ways
## you can save the

gg0 <- ggplot(data = green_space_data, aes(x = animal, y = species.richness ))
gg0 + geom_boxplot(fill = "gray")
gg0 + geom_boxplot(fill = "gray") + stat_sum(alpha = 0.5) +
    scale_size(breaks = 1:3, range = c(2, 6))

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
##It would also reveal whether the data have unimodal or multimodal distributions.

## BMB. jitter is fine for exploration, I like fancier things (stat_sum() or
##  beeswarm or ... for prettiness
## pretty hard to see bimodality in a small data set/with dots

species.hist <- (ggplot(data = green_space_data, aes(x = animal, y = species.richness )) 
      + geom_boxplot() 
      + geom_jitter() 
)
print(species.hist)


#Species richness of bird and butterfly plotted as a function of Area (ha) ----
species.line <- (ggplot(data = green_space_data, aes(x = area.ha, y = species.richness, colour = animal))
      + geom_point() 
      + geom_line()
      + labs(x="Area (ha)", y="Species Richness")
)
print(species.line)

## BMB: might want to use points + geom_smooth here (lines don't add much?)

#According to the Cleveland hierarchy, the best graphical feature for plots is to have points positioned along a common scale
#This graph plots the species richness for both bird and butterfly along the common scale for Area
#It also adds simple features like points and connecting lines, which help display the data
#Colour helps to distinguish between groups or categories. In this case, the orange points and lines display the bird data, and the blue points and lines display the butterlfy data

#I can use the patchwork package to display the plots together
#Display next to each other: ----
hist.and.line <- (species.hist | species.line)
print(hist.and.line)
#Having close proximity of my plots makes it easier to compare them. This could be more useful if the two plots were the same type (e.g. two histograms, or two line plots), but I don't have more data to demonstrate this

#Create linear model and check model assumptions ----
#This linear model looks at species richness given greenspace area
lm1 <- lm(species.richness ~ area.ha, green_space_data)
check_model(lm1)
#check_model() is a very useful function because it creates and displays multiple plots to examine the model assumptions (i.e. posterior predictive check, linearity, homogeneity of variance, influential observations, and normalty of residuals)
#I find it very helpful that along with the names of the tests, it gives a brief explanation of what the graph should look like
#It seems my data may have some problems. For example, the model-predicted lines in the posterior predictive check don't quite fall along the observed line, the reference line for the homogeneity of variance deviates from being flat and horizontal, and the dots on the normality of residuals plot do not fall along the line 

## BMB: it's very much a judgement call, but I probably wouldn't worry
## about deviations of this size in a small data set
## DHARMa is another way to check ...

plot(simulateResiduals(lm1))

## mark: 2.1
