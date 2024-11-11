library(tidyverse)

# Data setup

set.seed(11112024)
d = data.frame(x = 1:120) |>
  mutate(y = sin(2*pi*x/120) + runif(length(x),-1,1))

l = loess(y ~ x, data=d)
p = predict(l, se=TRUE)

d = d |> mutate(
  pred_y = p$fit,
  pred_y_se = p$se.fit
)

# Initial visualization

g = ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(
    aes(ymin = pred_y - 1.96 * pred_y_se, 
        ymax = pred_y + 1.96 * pred_y_se), 
    fill="red", alpha=0.25
  ) +
  geom_line(aes(y=pred_y)) +
  theme_bw()

g

# Bootstrap

n_rep = 1000

system.time({
bs = purrr::map_dfr(
  seq_len(n_rep),
  function(i) {
    d |>
      select(x, y) |>
      slice_sample(prop = 1, replace = TRUE) |>
      ( \(df) {
        mutate(
          df, iter = i,
          pred = loess(y ~ x, data = df) |> predict()
        )
      })()
  }
) |>
  group_by(x, y) |>
  summarize(
    bs_low = quantile(pred, probs = 0.025),
    bs_upp = quantile(pred, probs = 0.975),
    .groups = "drop"
  )
})

g +
  geom_ribbon(
    data = bs,
    aes(ymin = bs_low, ymax = bs_upp),
    color = "blue", alpha = 0.25
  )


# Multisession Bootstrap

future::plan(future::multisession(workers=16))


n_rep = 10000

system.time({
  #bs = purrr::map_dfr(
  bs = furrr::future_map_dfr(
    seq_len(n_rep),
    function(i) {
      d |>
        select(x, y) |>
        slice_sample(prop = 1, replace = TRUE) |>
        ( \(df) {
          mutate(
            df, iter = i,
            pred = loess(y ~ x, data = df) |> predict()
          )
        })()
    }
  ) |>
    group_by(x, y) |>
    summarize(
      bs_low = quantile(pred, probs = 0.025),
      bs_upp = quantile(pred, probs = 0.975),
      .groups = "drop"
    )
})

g +
  geom_ribbon(
    data = bs,
    aes(ymin = bs_low, ymax = bs_upp),
    color = "blue", alpha = 0.25
  )
