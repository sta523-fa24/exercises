library(tidyverse)
library(palmerpenguins)

## Exercise 1

penguins |> 
  filter(!is.na(sex)) |>
  mutate(
    sex = factor(as.character(sex), levels = c("male", "female"))
  ) |>
  ggplot(
    aes(
      x = body_mass_g,
      fill = species
    )
  ) +
  geom_density(
    alpha = 0.5, color = NA
  ) +
  facet_wrap(
    ~ sex, ncol = 1
  ) +
  labs(
    x = "Body Mass (g)",
    y = "",
    fill = "Species"
  )

## Exercise 2

ggplot(
  penguins,
  aes(x = flipper_length_mm, y = bill_length_mm, color = species)
) +
  geom_point(
    aes(color = species, shape = species), size = 3, alpha = 0.8
  ) +
  scale_color_manual(values = c("darkorange", "purple", "cyan4")) +
  geom_smooth(
    method = "lm", se = FALSE
  ) +
  theme_minimal()

 

