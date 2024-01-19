## Import data ----
library(tidyverse)
green_space_data <- read_csv("Green_Space_Biodiversity_Partial.csv")

## Examine structure and check for problems in the dataset ----
# str(green_space_data)
problems(green_space_data)
# There aren't any obvious problems with the dataset, such as missing or incorrect information

## Convert to long format ----
green_space_long <- green_space_data %>% 
  pivot_longer(
    cols = c(butterfly, bird),
    names_to = "animal",
    values_to = "species.richness"
)

## Examine data ----
greenspaceTable <- (green_space_long
                 %>% mutate(site=as.factor(site)
                        , animal=as.factor(animal)) 
)
summary(greenspaceTable)
# Summary table looks correct
# Each site has 2 data points (1 for bird and 1 for butterfly)
# There are 15 bird and butterfly data points for 15 sites (A–O)

## Visually check normality assumption ----
lm_green_space<- lm(species.richness ~ animal, data = greenspaceTable)
qqnorm(residuals(lm_green_space),main=""); qqline(residuals(lm_green_space)) 
# The dots visually look close to the line, so we can probably assume normality

# To double check, we could also conduct a Shapiro-Wilk normality test
shapiro.test(residuals(lm_green_space))
# The test is non-significant (p = 0.337), so we can assume normality 

## Save object as RDS file ----
saveRDS(greenspaceTable, file = "greenspaceTable.rds")
