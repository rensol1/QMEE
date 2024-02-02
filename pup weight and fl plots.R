library(tidyverse)
pup_weights <- read_csv("pup stats - weights.csv",  col_types=cols())
pup_fl<- read_csv("pup stats - forearm length.csv",  col_types=cols())

#Convert pup weight data to long format                  
pup_weights_long <- pup_weights %>% 
  pivot_longer(
    cols = (-Pup_ID),
    names_to = "Age",
    values_to = "Weight"
)
#summary(pup_weights_long)

#Convert pup forearm length data to long format
pup_fl_long <- pup_fl %>% 
  pivot_longer(
    cols = (-Pup_ID),
    names_to = "Age",
    values_to = "Forearm_Length"
)
#summary(pup_fl_long)

#Merge datasets
weight_fl <- (left_join(pup_weights_long, pup_fl_long, by= c("Pup_ID" = "Pup_ID", "Age" = "Age"))
  %>% mutate (Age = factor(Age))
  %>% mutate (Pup_ID = factor(Pup_ID))
)
#summary(weight_fl)

#Weight as a factor of age
# print(ggplot(weight_fl, aes(Age,  Weight, group = Pup_ID, colour = Pup_ID))
#       + geom_point()
#       + geom_line()
#       + xlab("Age (Day)")
#       + ylab("Weight (g)")
# )
##This organizes the x-axis by the first digit rather than the whole number

age_weight <- (ggplot(weight_fl, aes(x = factor(Age, level = c("2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36")), Weight, group = Pup_ID, colour = Pup_ID))
               + geom_point()
               + xlab("Age (Day)")
               + ylab("Weight (g)")
)    
##Is there a better way to fix than this??

age_weight + geom_line()
#vs
age_weight + geom_smooth()
#When is geom_line more effective than geom_smooth & vice versa

#Forearm length as a factor of age
# print(ggplot(weight_fl, aes(Age, Forearm_Length, group = Pup_ID, colour = Pup_ID))
#       + geom_point()
#       + geom_line()
#       + xlab("Age (Day)")
#       + ylab("Forearm Length (mm)")
# )
#Same thing as weight plot

age_fl <- (ggplot(weight_fl, aes(x = factor(Age, level = c("2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36")), Forearm_Length, group = Pup_ID, colour = Pup_ID))
      + geom_point()
      + xlab("Age (Day)")
      + ylab("Forearm Length (mm)")
)


age_fl + geom_line()
#or
age_fl + geom_smooth() #?


