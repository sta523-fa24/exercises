library(tidyverse)

## Exercise 1

palmerpenguins::penguins |>
  count(island, species) |>
  pivot_wider(
    id_cols = island,
    names_from = species,
    values_from = n,
    values_fill = 0
  )

## Exercise 2

tibble(planet = repurrrsive::sw_planets) |>
  unnest_wider(planet) |>
  select(name, films) |>
  unnest_longer(films) |>
  count(name, sort = TRUE) |>
  slice_max(n, n = 2)

tibble(people = repurrrsive::sw_people) |>
  unnest_wider(people) |>
  select(name, homeworld)|> 
  left_join(
    tibble(planet = repurrrsive::sw_planets) |>
      unnest_wider(planet) |>
      select(planet = name, url),
    by = c("homeworld" = "url")
  ) |>
  count(planet) |>
  slice_max(n, n=3)