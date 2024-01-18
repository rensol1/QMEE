#week 2 class notes#
#Tuesday ---- 

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

#Thursday ----
#villageTable <- read_csv("../data/village.csv") #.. means go up one level, then can find village.csv in data directory. use this??
#tidyverse: "warning message" with i at front, not bad but is "noise"
  ## ℹ Use `spec()` to retrieve the full column specification for this data.
  ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#guessing about columns, check to see if correct
#better to identify column types specifically if you know what they are if others will collaborate w data

#summary table: not good at summarizing characters
#village characterized by number but shouldn't be

#parasiteTable <- read_csv("../data/parademo.csv")
## Warning: One or more parsing issues, see `problems()` for details
#problems(parasiteTable)
#58,000 where it expected date and got something weird. supress warning message by telling it to treat them as NA
#readr has default list of things it treats as na (na = c("", "NA"))
#add "0000-000-00" (weird date cells) 

#still have problems lol 
#add NAs again until 0 problems

#summary table has lots of redundant info, which we want when collecting but not in clean data
#think about how to boil down and crosscheck 
#want non-redundant table for data maintenance. by being relational: info at the level it belongs, separate into diff tables

#gathering: make data tidier and more logically structured
#pivot_longer: for parallel data in original table. how ggplot wants it.
  ##! :everything except time column. INSTEAD USE MINUS SIGN
#pivot_wider: spread data
#check data carpentry from Tuesday

#summary(villageTable %>% mutate_if(is.character, as.factor))
#shows characters as factors in table. how many times the factor shows up in data. old-school but still neatest way to quickly see summary of factors 
#save characters as factors 

#summarize: applies function to all data. goes naturally with group by function.
#list: 
# print(villageTable
#       %>% group_by(vname, vu)
#       %>% summarize(count = n())
# )
#.groups argument instruction ** idk

#shortcut for group by summarize count, which is count. whether all the numebrs are 1
# print(villageTable
#       %>% count(vname, vu, name="count")
# )
#whether vname and vu are working as good index, count should be 1

#can't use just vname, because count 2 for 2 of the villages

#Parasite table
#people within villages (indexed by all 3). how many sampling events each person had
# print(parasiteTable
#       %>% count(id, village, compound, name="count")
# )

#explore ranges with plots 

#correct using tables
#fix with code. correction table
#patching 
#special function to check if NA (is.na)


#dictionaries

#git tab only if R project file, even if directory connected to git repo. 
#new project, choose existing directory
#want git tab to be empty at end of day. delete, gitignore or commit to repo

#2 ways to save stuff: for single object vs bunch of objects in same file

#saveRDS: call file something.rds
#status: ?s no existing file in repo? doesn't know if it should
#file.remove("file")
#only things in repo should be code and original data files you started with. good enough article says not to, but for convenience should
#read in csv, clean, make into factors, then save as RDS file
#ignore in git tab: want to keep file around but want git to know it shouldn't save copy of file. opens gitignore file, can make patterns that say ignore anything with rds or just the one?
#M means modify

#branch is ahead of origin/master (version on github): changes you haven't pushed

#readRDS() take object and read back in. is an R object. assign it to variable
#don't have to remember what it was called before, can name it whatever you want now
#save together save("x", "y", file = "my.stuff.rda")
#load("mystuff.rda"): reloads x and y. show up in environment
#L <- load("mystuff.rda"). print(L), shows what objects we gave it

#get used to using tab completion 

#not for real data? eh?
#library(readr)
#read_delim(delim = "|", trim_ws = TRUE, "hello | 2, goodbye | 2")


