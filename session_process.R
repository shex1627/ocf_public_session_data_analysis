#### Importing my baes 
library(tidyverse)
library(lubridate)

#### Reading raw csv
sessions <- read_csv('https://www.ocf.berkeley.edu/~shichenh/sessions_data/sessions.csv',
                     col_names = c('id', 'host', 'start', 'end', 'duration'))
  
s.sessions <- read_csv("https://www.ocf.berkeley.edu/~shichenh/sessions_data/staff_sessions.csv",
                       col_names = c('id', 'host', 'user', 'start', 'end', 'last.update', 'duration'))


sessions <- sessions %>% 
  #delete the current session
  filter(!is.na(end)) %>%
  #delete all sessions piror to the semester
  filter(start >= ymd('2017-08-23')) %>%
  #calculating session duration in minutes 
  mutate(duration.min = as.numeric(round((end - start)/60, 2)))
  
s.sessions <- s.sessions %>% 
    filter(!is.na(end)) %>%
    filter(start >= ymd('2017-08-23')) %>%
    mutate(duration.min = as.numeric(round((end - start)/60, 2)))

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
