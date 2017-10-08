#### Importing my baes 
library(tidyverse)
library(lubridate)
library(RMySQL)

#### SQL connection
ocf.db <- dbConnect(MySQL(), user="anonymous", host="mysql.ocf.berkeley.edu")

#### Reading raw csv

#### Get total Sessions
rs <- dbSendQuery(ocf.db, "select * from ocfstats.`session_duration_public`")
sessions <- dbFetch(rs, n=-1)

#### Get Staff Sessions
rs <- dbSendQuery(ocf.db, "select * from ocfstats.`staff_session_duration_public`")
s.sessions <- dbFetch(rs, n=-1)

sessions <- sessions %>% 
  #delete the current session
  filter(!is.na(end)) %>%
  #delete all sessions piror to the semester
  filter(start >= ymd('2017-08-23')) %>%
  #converting start and end string to R date obejctve
  mutate(start = as.POSIXct(start)) %>% 
  mutate(end = as.POSIXct(end)) %>%
  #calculating session duration in minutes 
  mutate(duration = hms(duration)) %>%
  mutate(duration.min = hour(duration)*60 + minute(duration))
  
s.sessions <- s.sessions %>% 
    filter(!is.na(end)) %>%
    filter(start >= ymd('2017-08-23')) %>%
    mutate(start = as.POSIXct(start)) %>% 
    mutate(end = as.POSIXct(end)) %>%
    mutate(duration = hms(duration)) %>%
    mutate(duration.min = hour(duration)*60 + minute(duration))

not.s.sessions <- sessions %>% 
  #removing staff sessions from regular sessions
  anti_join(s.sessions, by = 'id') %>%
  #there is an outlier, computer 'hailstorm' had a 3k min long session idk why
  filter(duration.min < 1000) %>%
  #removing front desk staff sessions
  filter(host != 'blizzard.ocf.berkeley.edu')

#### Writing csv
write_csv(sessions, "~/boc/ocf_session_data_analysis/sessions_clean.csv")
write_csv(s.sessions, "~/boc/ocf_session_data_analysis/staff_sessions_clean.csv")
write_csv(not.s.sessions, "~/boc/ocf_session_data_analysis/not_s_sessions_clean.csv")
