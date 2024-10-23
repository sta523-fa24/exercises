library(httr2)

library(job)
empty({
  library(plumber)
  plumb(file='api.R')$run()
})


new_data = tibble::tibble(
  x = rnorm(30),
  y = rnorm(30),
  group = "9",
  rand = "9"
)

request("http://127.0.0.1:9767") |>
  req_url_path("data/new") |>
  req_method("post") |>
  req_body_json(new_data) |>
  req_perform()

request("http://127.0.0.1:9767") |>
  req_url_path("data") |>
  req_perform()

last_response() |>
  resp_body_json() |> 
  bind_rows() |>
  View()
