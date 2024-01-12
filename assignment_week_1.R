green_space_data <- read.csv("Green_Space_Biodiversity_Partial.csv")


area <- green_space_data$area.ha #Area (in hectares)
butterfly <- green_space_data$butterfly #Butterfly species richness
bird <- green_space_data$bird #Bird species richness

#Is park area (in hectares) correlated with butterfly species richness in the area?----
area_butterfly_correlation <- cor.test(x = area , y = butterfly, 
                method = "pearson")
area_butterfly_correlation
#Park area is not correlated with butterfly species richness (r=0.14, n=15, p=0.609).


#Is park area (in hectares) correlated with bird species richness in the area?----
area_bird_correlation <- cor.test(x = area , y = bird, 
                method = "pearson")
area_bird_correlation
#Park area is not correlated with bird species richness (r=0.49, n=15, p=0.066)

#Is there a significant difference between the means of butterfly species richness and bird species richness?----
t.test(x = butterfly, y = bird)
#There is no significant difference between the means of butterfly species richness and bird species richness (t(21)=-1.8, p=0.093).
