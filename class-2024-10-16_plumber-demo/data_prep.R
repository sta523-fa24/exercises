library(tidyverse)

ctrs = matrix(
  c(
    25,15,
    38,29,
    48,58,
    59,75,
    80,83
  ),
  byrow=TRUE,
  ncol=2
)

simpsons = datasauRus::simpsons_paradox |>
  filter(dataset == "simpson_2", x < 75) |>
  select(-dataset)

simpsons = simpsons |>
  mutate(
    group = kmeans(simpsons, ctrs)$cluster |> as.character(),
    rand = sample(group)
  )

write_rds(simpsons, "simpsons.rds")
