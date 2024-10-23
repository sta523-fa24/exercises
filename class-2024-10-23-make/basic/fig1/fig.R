p = GGally::ggpairs(mtcars)

ggplot2::ggsave(here::here("fig1/fig.png"), p, width=10, height=10)
