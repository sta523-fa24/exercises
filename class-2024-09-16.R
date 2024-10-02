library(dplyr)
library(nycflights13)

# How many flights to Los Angeles (LAX) did each of the legacy carriers 
# (AA, UA, DL or US) have in May from JFK, and what was their average duration?

flights |>
  filter(month == 5) |>
  filter(dest == "LAX") |>
  filter(carrier %in% c("AA", "UA", "DL", "US")) |>
  filter(origin == "JFK") |>
  summarize(
    n_flights = n(),
    avg_duration = mean(air_time, na.rm = TRUE),
    .by = carrier
  )

# What was the shortest flight out of each airport in terms of distance? 
# In terms of duration?

flights |>
  slice_min(distance, n = 1, by = origin) |>
  select(origin, dest, distance) |>
  distinct()

flights |>
  slice_min(air_time, n = 1, by = origin) |>
  select(origin, dest, air_time) |>
  distinct()

# Which plane (check the tail number) flew out of each New York airport the most?

flights |>
  count(origin, tailnum) |>
  filter(!is.na(tailnum)) |>
  slice_max(n, n=1, by = origin)

  
# Which date should you fly on if you want to have the lowest possible average 
# departure delay? What about arrival delay?

flights |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .by = c(month, day, origin)
  ) |>
  slice_min(avg_dep_delay, n = 1, by = origin)

flights |>
  summarize(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    .by = c(month, day, origin)
  ) |>
  slice_min(avg_arr_delay, n = 1, by = origin)
