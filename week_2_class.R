#week 2 class notes#

# dir.create("data")
download.file(url="https://ndownloader.figshare.com/files/2292169",
              destfile = "data/portal_data_joined.csv")
#or download from website and import

#tidyverse: tidy data in rectangular data in dataframe, not list, etc. typically long format (columns for site, date, species, count etc)

library(tidyverse)
dd <- read_csv("data/portal_data_joined.csv") #nothing gets saves w/o assigning to variable
#tidyverse version of reading csv into rectangular dataframe. reads into tibble
#conflicts: same name as base R, newer ones will mask older

print(dd)

str(dd)
 #select: grabs columns
select(dd, plot_id, species_id, weight)
#leave out columns with -
select(dd, -record_id, -species_id)

#filter: adding or excluding rows 
filter(dd, year == 1995) # needs to be ==. if =, gives error asking if meant ==

#pipe: run some function and sub the thing on left side for first argument on right side of pipe
#%>% |> #both represent right arrows.
dd2 <- (dd 
  %>% select(year, record_id)
  %>% filter(year == 1995)
) #could also put pipe at end of each row w/o parantheses 
#use parantheses or R guesses when command is done 
#but stuck with only subsets of what was alreay in data

#mutate: modify variable or make new variables
dd3 <- (dd %>% mutate(weight_kg = weight/1000) # not ==. create new column
  %>% mutate(squared_weight = weight_kg^2)
)
#dd %>% mutate(weight_kg = weight/1000) %>%
  #select(-weight) #get rid of weight column 


