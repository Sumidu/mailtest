library(mRpostman)
library(tidyverse)
config <- config::get()


UPDATE_FILENAME <- "lastupdate.rds"

# IMAP settings
con <- configure_imap(
  url=paste0("imaps://",config$imap),
  username=config$username,
  password=config$pw
)

con$reset_timeout_ms(x = 30000)
con$select_folder(name = config$inbox)  

if (file.exists(UPDATE_FILENAME)) {
  dat <- read_rds(UPDATE_FILENAME)  
} else {
  # max go 10 years back
  dat <- (Sys.Date()-3650) %>% format.Date("%d-%b-%Y")
}

# first call?
if(!is.na(con$search_since(date_char = dat))){
  # fetch all new mails.
  mails <- con$search_since(date_char = dat) %>%
    con$fetch_text(write_to_disk = TRUE)
  write_rds(dat, UPDATE_FILENAME)
}


files <- dir(here::here(config$username, config$inbox), pattern = ".txt")
for (file in files) {
  x <-   read_lines(here::here(config$username, config$inbox,file))
  
}

x






if(false){
  
  con$examine_folder(name = "Spam")
  con$examine_folder(name = "INBOX")
  con$search_string(expr = "andre", where = "FROM")
  con$search_string(expr = "andre", where = "FROM") %>% 
    con$fetch_text(write_to_disk = TRUE, keep_in_mem = FALSE)
}
