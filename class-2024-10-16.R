library(httr2)


## echo endpoint

request("http://127.0.0.1:4946") |>
  req_url_path("echo") |>
  req_url_query(msg="hello from httr2") |>
  req_perform()

last_response() |>
  resp_body_json()


## user endpoint

request("http://127.0.0.1:4946") |>
  req_url_path("user") |>
  req_url_path_append("1234") |>
  req_perform() |>
  resp_body_json()

request("http://127.0.0.1:4946") |>
  req_url_path("user") |>
  req_method("post") |>
  req_url_path_append("1234") |>
  req_url_path_append("t") |>
  req_perform() |>
  resp_body_json()
