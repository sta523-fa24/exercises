## Demo 1 -----

### Get USER endpoint

# https://api.github.com/users/USERNAME

readLines("https://api.github.com/users/rundel") |>
  cat()


jsonlite::read_json("https://api.github.com/users/hadley") |>
  str()


### Get organization repos endpoint

jsonlite::read_json("https://api.github.com/orgs/sta523-fa24/repos") |> 
  purrr::map_chr("full_name")

jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos") |> 
  purrr::map_chr("full_name")

jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos?page=1") |> 
  purrr::map_chr("full_name")

jsonlite::read_json("https://api.github.com/orgs/tidyverse/repos?page=2") |> 
  purrr::map_chr("full_name")

jsonlite::read_json("https://api.github.com/orgs/rstudio/repos?per_page=200&page=4") |> 
  purrr::map_chr("full_name")


### Get my information

jsonlite::read_json("https://api.github.com/user")



## Demo 2 -----

library(httr2)

### Get User info

resp = request("https://api.github.com/users/rundel") |>
  req_perform()

resp |> resp_status()
resp |> resp_status_desc()
resp |> resp_content_type()

resp |> resp_body_json() |> str()


### Get authorized user

request("https://api.github.com/user") |>
  req_headers(
    Authorization = paste0("Bearer ", token)
  ) |>
  req_perform() |>
  resp_body_json() |>
  View()


request("https://api.github.com/user") |>
  req_auth_bearer_token(token) |>
  req_dry_run()

## Get org repos

request("https://api.github.com/orgs/sta523-fa24/repos") |>
  req_auth_bearer_token(token) |>
  req_url_query(per_page = 100) |>
  req_perform() |>
  resp_body_json() |>
  purrr::map_chr("full_name")

last_response() |>
  resp_status()


### Create a gist

req = request("https://api.github.com/gists") |>
  req_method("POST") |>
  req_auth_bearer_token(token) |>
  req_body_json( 
    list(
      description = "Testing 1 2 3 ...",
      files = list(
        "test.R" = list(
          content = "print('hello world!')
1+1
x=3
"
        )
      ),
      public = TRUE
    )
  ) 

resp = req |> req_perform()

resp

resp |> resp_body_json() |> View()

x = resp |> resp_body_json()
x$html_url
