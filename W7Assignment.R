##W7 Assignment

## BMB: if coefplot works that's OK, but it's pretty much superseded by
##  broom/broom.mixed + ggplot2/dotwhisker (more flexible, works for
##  a broader range of models)
library(coefplot)
library(DHARMa)
library(tidyverse)
library(MASS)
##This RDS file is created by "W2_assignment.R" in my repo
## BMB: thanks for documenting!
greenspace_data <- readRDS(file = "greenspaceTable.rds")

greenspace_glm <- glm(species.richness~animal , data=greenspace_data, family="poisson" )
#summary(greenspace_glm)
## BMB: Poisson distribution for species richness is interesting - very widely used
##  but possibly problematic.

#Diagnostic plots
greenspace_sim <- simulateResiduals(fittedModel = greenspace_glm)
plot(greenspace_sim)
##The Q-Q residuals plot: Points near the line indicate residuals are normally distributed, whereas points far from the line indicate they may be non-normally distributed. This tells me there is a significant deviation, meaning the points are non-normally distributed
## BMB: technically, since DHARMa uses _simulated_ residuals, what this indicates is that the conditional distribution of the data is not Poisson
##  (the residuals aren't exactly normal even if the model is exactly correct in this case). DHARMa is actually telling you here that the overall distribution
## (K-S test) is OK, but that there is too much variability (dispersion test)
testDispersion(greenspace_sim)

## test/plot with more sims
big_sim <- simulateResiduals(fittedModel = greenspace_glm, n = 1e4)
testDispersion(big_sim)
##The Levene Test for homogeneity of variance is non-significant, meaning that the variance of the two groups is the same
##  BMB: careful! Means **we can't see a clear difference** (I know this is tedious but it's worth training yourself to think correctly)


## you should fix the dispersion problem ...
g_glm2 <- update(greenspace_glm, family = quasipoisson)
coefplot(g_glm2)
summary(g_glm2)
## with dispersion fix, butterfly effect is now only marginally significant/clear
##  (p = 0.08)

g_glm3 <- MASS::glm.nb(species.richness~animal , data=greenspace_data)
coefplot(g_glm3)
summary(g_glm3)

## comparison:
dotwhisker::dwplot(list(poisson=greenspace_glm, quasipoiss=g_glm2, nbinom=g_glm3)) +
    geom_vline(xintercept = 0, lty = 2)

#Inferential plot
coefplot(greenspace_glm)

#This visualizes the coefficients of the glm, as well as the confidence intervals. Essentially, it is a way to visually summarize the glm.
#The intercept in this case is bird.
#We can see that butterfly has less species richness than bird. 
##However, I have not been using this data, so I am not sure if this difference is biologically meaningful.
##See below for what I was trying to do, but could not figure out



##I  have some ordinal data that I am currently collecting. I used it to discuss last week's assignment.
##I have been treating this round of data collection as an exploration of my methods and analyses

##I'm having trouble figuring out how to model it

##This RDS file is created by "exercise_data.R" in my repo
## BMB: you forgot to push treadmill.csv, so I can't make it ...

flight_data <- readRDS(file="flights.RDS")
#summary(flight_data)
flight_data_long <- flight_data %>% 
  pivot_longer(
    cols = (c(Score_Flight1, Score_Flight2, Score_Flight3, Score_Flight4, Score_Flight5)),
    names_to = "Flight_Number",
    values_to = "Flight_Score") 
#Score_Flight1 to Score_Flight5 are performance scores I have given to bat flight trials.
#Group refers to the treatment or control group
#From what I can find (on Google), the best way to model this is with Ordinal Logistic Regression using polr()
flightscore_glm <- polr(Flight_Score ~ Group, data = flight_data_long, Hess=TRUE)
#summary(flightscore_glm)
#This seems to work? However, I don't know what to do next 

# flight_sim <- simulateResiduals(fittedModel = flightscore_glm)
# plot(flight_sim)
#This doesn't work 

#plot(flightscore_glm)
#This also doesn't work

#I can create a coefficient plot
coefplot(flightscore_glm)
#But I'm not exactly sure how to interpret it (or if it's correct)
##Sorry:(

## BMB: don't be sorry, you're trying.
## Probably the easiest/best approach is to use the 'ordinal' package

library(ordinal)

## The ‘wine’ data set is adopted from Randall(1989) and from a
##      factorial experiment on factors determining the bitterness of
##      wine. Two treatment factors (temperature and contact) each have
##      two levels. Temperature and contact between juice and skins can be
##      controlled when cruching grapes during wine production. Nine
##      judges each assessed wine from two bottles from each of the four
##      treatment conditions, hence there are 72 observations in all.



fm1 <- clm(rating ~ temp * contact, data = wine)
fm1 ## print method
dotwhisker::dwplot(fm1)
## DHARMa doesn't work
## this article is pretty technical, and doesn't mention diagnostics,
##  but section 4.1 is an interpretation of the fit above.
if (FALSE) vignette("clm_article", package = "ordinal")

## mark: 2
