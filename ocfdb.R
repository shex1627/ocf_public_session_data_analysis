library(RMySQL)
ocf.db <- dbConnect(MySQL(), user="anonymous", host="mysql.ocf.berkeley.edu")
rs <- dbSendQuery(ocf.db, "select * from ocfstats.`session_duration_public`")
sessions.db <- dbFetch(rs, n=-1)
