greenspace_data <- readRDS(file = "greenspaceTable.rds")

## Plots to check for errors ----
## Visually check normality assumption ----
lm_green_space<- lm(species.richness ~ animal, data = greenspace_data)
qqnorm(residuals(lm_green_space),main=""); qqline(residuals(lm_green_space)) 
# The dots visually look close to the line, so we can probably assume normality

# To double check, we could also conduct a Shapiro-Wilk normality test
shapiro.test(residuals(lm_green_space))
# The test is non-significant (p = 0.337), so we can assume normality 

## Visualize data with a boxplot ----
library(ggplot2)
green_space_boxplot <- (ggplot(greenspace_data, 
                               aes(x = animal, 
                                   y = species.richness)) + 
                          geom_boxplot()
)
print(green_space_boxplot)
# It seems like the bird and butterfly groups may have unequal variances
# To double check, we could also conduct a Bartleet test of homogeneity of variances 
bartlett.test(species.richness ~ animal, data = greenspace_data)

# The test is significant (p = 0.019), suggesting that the groups have unequal variances 



