#### Importing my baes 
library(tidyverse)
library(lubridate)

#### Reading raw csv
sessions <- read_csv("~/boc/sessions.csv", 
                     col_names = c('id', 'host', 'start', 'end', 'duration'))

s.sessions <- read_csv("~/boc/staff_sessions.csv",
                       col_names = c('id', 'host', 'user', 'start', 'end', 'last.update', 'duration'))


sessions <- sessions %>% 
  #delete the current session
  filter(!is.na(end)) %>%
  #delete all sessions piror to the semester
  filter(start >= ymd('2017-08-23')) %>%
  #calculating session duration in minutes 
  mutate(duration.min = round((end - start)/60, 2))
  
s.sessions <- s.sessions %>% 
    filter(!is.na(end)) %>%
    filter(start >= ymd('2017-08-23')) %>%
    mutate(duration.min = round((end - start)/60, 2))

#### Writing csv
write_csv(sessions, "~/boc/sessions_clean.csv")
write_csv(s.sessions, "~/boc/staff_sessions_clean.csv")
