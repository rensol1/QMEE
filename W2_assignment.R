library(tidyverse)
green_space_data <- read_csv("Green_Space_Biodiversity_Partial.csv")

problems(green_space_data)

## Convert to long format ----

green_space_long <- green_space_data %>% 
  pivot_longer(
    cols = c(butterfly, bird),
    names_to = "animal",
    values_to = "species.richness"
)

## Examine data ----
print(green_space_long)
str(green_space_long)

greenspaceTable <- (green_space_long
                 %>% mutate(site=as.factor(site)) 
                 %>% mutate(animal=as.factor(animal))
)

summary(greenspaceTable)


saveRDS(green_space_long, file = "greenspaceTable.rds")
