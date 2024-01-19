## Import RDS file ----
greenspace_data <- readRDS(file = "greenspaceTable.rds")

## Visualize data with a boxplot ----
library(ggplot2)
green_space_boxplot <- (ggplot(greenspace_data, 
                          aes(x = animal, 
                              y = species.richness)) + 
                          geom_boxplot()
)
print(green_space_boxplot)
# It seems like the bird and butterfly groups may have unequal variances

# To double check, we could also conduct a Bartlett test of homogeneity of variances 
bartlett.test(species.richness ~ animal, data = greenspace_data)
# The test is significant (p = 0.019), suggesting that the groups have unequal variances 



