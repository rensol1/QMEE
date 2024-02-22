library(tidyverse); theme_set(theme_bw())
library(dotwhisker)
library(car)
library(emmeans)
library(broom)

##This script uses the RDS file created by 'pup weight and fl plots.R, found in the "pup data folder in my repo
weightandfl <- readRDS(file = "WeightsandForearmLengths.rds")

#I hypothesize that Weight increases with Age
#I also hypothesize that males will have smaller weights than females

#Create linear model for Weight
lmweight_added <- lm(Weight ~ Age+Sex, weightandfl)
#This linear model tests the additive effects of Age and Sex on weight, without an interaction term. 

#Anova and drop1() test the effect of Age and Sex on Weight, and print p values
drop1(lmweight_added, test= "F")
Anova(lmweight_added)
#In this case, these two functions provide similar tables

#Print a summary table
print(summary(lmweight_added))
#A summary table compares each factor level to the baseline (Intercept) and prints the resulting t statistic
#In this case my baseline is Age2, female. So the test compares every Age to Age2, and male to female
#I could also use tidy() to print the coefficients and p-values
tidy(lmweight_added)

#Print coefficient table
dwplot(lmweight_added, by_2sd=TRUE)
#I can also visualize the coefficients with a coefficient table.
#This compares all ages to Age2, and male to female.
#I can use this to see how big the effect of Age and Sex are, and also how (un)certain
#As expected, pup weight increases with Age, but not significantly between any two consecutive levels
#Also, males have lower weights than females, which is something I have noticed in my own experience with bats

#Create linear model for pup Weight including interaction term between Age and Sex
lmweight_interaction <- lm(Weight ~ Age*Sex, weightandfl)
#There could be an interaction between Age and Sex, wherein the difference between males and females differs at different ages. 

#Anova() now includes the p-value for the interaction 
Anova(lmweight_interaction)
#drop1() shows the p-value of the interaction, which matches the one printed by Anova()
drop1(lmweight_interaction, test= "F")

#Update linear model for contrasts
lmweight_interactionc <- update(lmweight_interaction, contrasts = list(Age = contr.sum, Sex = contr.sum))
#I am now doing sum to 0 contrasts, which makes the intercept the mean across all levels. 
print(summary(lmweight_interactionc))
#Now when I print the summary table, it compares to the new intercept, not Age2, female.

#Print coefficient table
dwplot(lmweight_interactionc, by_2sd=TRUE)
#Now the interactions are also plotted 
#Based on the summary and coefficient tables, there seems to be an interaction between Age and Sex at Age1, 2, 15, and 16 (originally Ages 2, 4, 32, and 34)
#Though, the effects aren quite small





