library(fpp3)
library(tidyverse)
library(lubridate)
ae_original <- readr::read_csv("data/ae_uk.csv",
                                  col_types = cols(
                                    arrival_time=col_datetime(format = "%d/%m/%Y %H:%M"),
                                    gender=col_character(),
                                    type_injury=col_character()))
ae_original %>%
  mutate(arrival_time=lubridate::force_tz(arrival_time,tz="GB")) -> ae
ae_tsb <- ae %>%
  as_tsibble(key = c(ID,gender,type_injury), index = arrival_time, regular=FALSE)

ae_half_hourly <- ae_tsb %>%
  index_by(time = lubridate::floor_date(arrival_time, "30 minutes")) %>%
  summarise(admission=n()) %>% fill_gaps(admission=0L) %>% ungroup()

