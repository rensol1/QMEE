library(tidyverse)
pup_weights <- read_csv("pup stats - weights.csv",  col_types=cols())
pup_fl<- read_csv("pup stats - forearm length.csv",  col_types=cols())

#Convert pup weight data to long format                  
pup_weights_long <- pup_weights %>% 
  pivot_longer(
    cols = (c(-Pup_ID, -Sex)),
    names_to = "Age",
    values_to = "Weight"
)
#summary(pup_weights_long)

#Convert pup forearm length data to long format
pup_fl_long <- pup_fl %>% 
  pivot_longer(
    cols = (c(-Pup_ID, -Sex)),
    names_to = "Age",
    values_to = "Forearm_Length"
)
#summary(pup_fl_long)

#Merge datasets
weight_fl <- (left_join(pup_weights_long, pup_fl_long, by= c("Pup_ID" = "Pup_ID", "Age" = "Age", "Sex" = "Sex"))
    %>% mutate (Age = factor(Age)
     , Pup_ID = factor(Pup_ID)
     , Sex = factor(Sex))
)
#summary(weight_fl)

#Order factors
weight_fl$Age <- factor(weight_fl$Age,levels=c("2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36"))
weight_fl$Sex <- factor(weight_fl$Sex, levels=c("female", "male"))

#plot weight across age 
age_weight <- (ggplot(weight_fl, aes(Age, Weight, group = Pup_ID, colour = Pup_ID))
               + geom_point()
               + xlab("Age (Day)")
               + ylab("Weight (g)")
               + geom_smooth()
)

#Plot forearm length across age 
age_fl <- (ggplot(weight_fl, aes(Age, Forearm_Length, group = Pup_ID, colour = Pup_ID))
      + geom_point()
      + xlab("Age (Day)")
      + ylab("Forearm Length (mm)")
      + geom_smooth()
)

#Save RDS file
saveRDS(weight_fl, file = "WeightsandForearmLengths.rds")
