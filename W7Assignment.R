#W7 Assignment 
library(coefplot)
library(DHARMa)
library(tidyverse)
library(MASS)
#This RDS file is created by "W2_assignment.R" in my repo 
greenspace_data <- readRDS(file = "greenspaceTable.rds")

greenspace_glm <- glm(species.richness~animal , data=greenspace_data, family="poisson" )
#summary(greenspace_glm)


#Diagnostic plots
greenspace_sim <- simulateResiduals(fittedModel = greenspace_glm)
plot(greenspace_sim)
#The Q-Q residuals plot: Points near the line indicate residuals are normally distributed, whereas points far from the line indicate they may be non-normally distributed. This tells me there is a significant deviation, meaning the points are non-normally distributed
#The Levene Test for homogeneity of variance is non-significant, meaning that the variance of the two groups is the same


#Inferential plot
coefplot(greenspace_glm)
#This visualizes the coefficients of the glm, as well as the confidence intervals. Essentially, it is a way to visually summarize the glm.
#The intercept in this case is bird.
#We can see that butterfly has less species richness than bird. 
#However, I have not been using this data, so I am not sure if this difference is biologically meaningful.
#See below for what I was trying to do, but could not figure out


#I  have some ordinal data that I am currently collecting. I used it to discuss last week's assignment.
    #I have been treating this round of data collection as an exploration of my methods and analyses

#I'm having trouble figuring out how to model it

#This RDS file is created by "exercise_data.R" in my repo
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
#Sorry:(
