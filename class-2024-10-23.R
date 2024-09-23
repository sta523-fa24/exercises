library(tidyverse)

## Example 1

draw_points = function(n) {
  list(
    x = runif(n),
    y = runif(n)
  )
}

in_unit_circle = function(d) {
  sqrt(d$x^2 + d$y^2) <= 1
}

approx_pi = function(x, n) {
  4*x / n
}

draw_points(1e4) |>
  in_unit_circle() |>
  sum() |>
  approx_pi(1e4)


tibble(
  n = 10^(2:7)
) |>
  mutate(
    draws = map(n, draw_points),
    n_in_ucirc = map_int(draws, ~ sum(in_unit_circle(.x))),
    pi_approx = map2_dbl(n_in_ucirc, n, approx_pi),
    pi_error = abs(pi - pi_approx)
  )














