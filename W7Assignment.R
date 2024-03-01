#W7 Assignment 
library(MASS)

#This RDS file is created by "W2_assignment.R" in my repo 
greenspace_data <- readRDS(file = "greenspaceTable.rds")

#Hypothesis: greenspace area size (in ha.) has an effect on species richness in that area
greenspace_glm <- glm(species.richness~area.ha, data=greenspace_data, family="poisson" )
#summary(greenspace_glm)

plot(greenspace_glm)
#This creates diagnostic plots
#The residuals vs. fitted plot is the first we should examine because it allows us to look for patterns or trends in the residuals. I don't see any particular (obvious) trends. 
#The Q-Q residuals plot is shown next, though really we should consider it last. Points near the line indicate residuals are normally distributed, whereas points far from the line indicate they may be non-normally distributed. The 3 highest points are the farthest away from the line, and may indicate non-normality at larger theoretical quantiles
#The Scale-Location plot is used to visually examine whether there is heteroscedasticity, which is shown if the line deviates from horizontal. There is quite a large dip in the line between 2.2 and 2.3 of the predicted values. 
#The Residuals vs Leverage shows points with high leverage; points outside the dotted lines have high leverage (influence on the model). There is a point near the bottom right corner that has high leverage. 


##I used this published data because I don't have other count or proportion data
#I do have some ordinal data that I am currently collecting. I used it to discuss last week's assignment.
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


