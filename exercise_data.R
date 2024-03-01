library(tidyverse); theme_set(theme_bw())

#Treadmill scores for exercise (treatment) group
treadmill_exercise <- read_csv("treadmill_exercise.csv", col_types=cols_only(Bat_ID=col_factor()
                                                                                , Date=col_date(format = "")
                                                                                , Score_1=col_factor()
                                                                                , Score_2=col_factor()
                                                                                , Score_3=col_factor())
)
#summary(treadmill_exercise)

#Treadmill scores for no exercise (control) group
treadmill_control <- read_csv("treadmill_control.csv", col_types=cols_only(Bat_ID=col_factor()
                                                                             , Date=col_date(format = "")
                                                                             , DuringActivity_1=col_factor()
                                                                             , DuringActivity_2=col_factor()
                                                                             , DuringActivity_3=col_factor())
)
#summary(treadmill_control)

#Flight scores for both exercise and no exercise groups
flights <- read_csv("flight.csv", col_types = cols_only(Bat_ID=col_factor()
                                                        , Date=col_date(format = "")
                                                        , Trial_Number=col_factor()
                                                        , Score_Flight1=col_factor()
                                                        , Willingness_Flight1=col_factor()
                                                        , Score_Flight2=col_factor()
                                                        , Willingness_Flight2=col_factor()
                                                        , Score_Flight3=col_factor()
                                                        , Willingness_Flight3=col_factor()
                                                        , Score_Flight4=col_factor()
                                                        , Willingness_Flight4=col_factor()
                                                        , Score_Flight5=col_factor()
                                                        , Willingness_Flight5=col_factor()
                                                        , Group=col_factor())
)
#summary(flights)

saveRDS(treadmill_exercise, file = "treadmill_exercise.RDS")
saveRDS(treadmill_control, file = "treadmill_control.RDS")
saveRDS(flights, file = "flights.RDS")

