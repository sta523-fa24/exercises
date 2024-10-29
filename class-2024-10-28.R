library(dplyr)

db = DBI::dbConnect(RSQLite::SQLite(), "flights.sqlite")

flight_tbl = dplyr::copy_to(
  db, nycflights13::flights, 
  name = "flights", 
  temporary = FALSE
)
