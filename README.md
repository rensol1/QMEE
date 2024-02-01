# QMEE

Bio 708 

**Assignment Week 1**

Fuller et al. (2007) evaluated the benefits of urban public greenspaces in Sheffield, England. I have provided part of their dataset, including the greenspace areas (in hectares), as well as butterfly and bird species richness in these areas (`Green_Space_Biodiversity_Partial.csv`). From these data, we can ask whether there is some correlation between butterfly species richness and the size of greenspace areas or bird species richness and the size of greenspace areas. It could be that having larger greenspace areas allows for greater butterfly and bird species richness. We can also ask whether there is a difference in richness of butterfly species compared to bird species. Over the evaluated greenspace areas, there could be greater butterfly species richness than bird species richness, or vice versa. 

Reference

Fuller, R. A., Irvine, K. N., Devine-Wright, P., Warren, P. H., & Gaston, K. J. (2007). Psychological benefits of greenspace increase with biodiversity. _Biology Letters_, _3_, 390–394. http://doi.org/10.1098/rsbl.2007.0149.

**Assignment Week 2**

The two scripts for this week's assignment are "W2_assignment.R" and "W2_withRDS.R". Both are found in the main branch of my QMEE repository. 

"W2_assignment.R" uses tidyverse to import Fuller et al. (2007) data ("Green_Space_Biodiversity_Partial.csv", also found in the main branch) and checks for problems with the dataset. It then converts the dataset to long format, saving it as a new object (green_space_long). To examine the data, the script uses this new object and converts the character variables (site and animal) to factors, creating another new object (greenspaceTable), and then summarizes it. The summary table looks correct (i.e. every site has 2 data points for bird and butterfly, and there are 15 bird and butterfly data points for sites A–O). Then, to check whether the data are distributed normally, the script creates a linear model and uses it to graph the residuals of species richness given animal type. Visually, the data appear to be normal, but the script also performs a Shapiro-Wilk normality test to double check. Finally, the script saves the greenspaceTable as an RDS file. So, "W2_assignment.R" needs to be run first to obtain the file for the following script.

"W2_withRDS.R" reads the greenspaceTable RDS file. Using the ggplot2 library, it creates and prints a boxplot, with animal (i.e. butterfly vs bird) as the independent variable, and species richness as the dependent variable. Finally, it performs a Bartlett test of homogeneity of variances of species richness given animal type.

These scripts only use a portion of the Fuller et al. (2007) data. Specifically, they examine and compare the species richness of butterflies and birds across multiple greenspace sites. Butterfly and bird species richness can fluctuate as these animals can move. Fuller et al. (2007) also recorded species richness of static plant species in the greenspace areas. In the future, we could compare fluctuating and static species richness. 

Furthermore, Fuller et al. (2007) recorded the size of the greenspace areas, which could be used to assess whether there is a correlation between area size and species richness (bird, butterfly, or plant).

Finally, Fuller et al. (2007) surveyed urban city dwellers on their perceptions of species richness in the greenspace areas. Therefore, we could compare actual species richness to perceived species richness.

Reference

Fuller, R. A., Irvine, K. N., Devine-Wright, P., Warren, P. H., & Gaston, K. J. (2007). Psychological benefits of greenspace increase with biodiversity. _Biology Letters_, _3_, 390–394. http://doi.org/10.1098/rsbl.2007.0149.
