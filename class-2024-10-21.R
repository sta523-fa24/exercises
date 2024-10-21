library(tidyverse)
library(rvest)

## La Quinta

url = "https://www.wyndhamhotels.com"

hotels = read_html(file.path(url,"/laquinta/locations")) |>
  html_nodes(".property a:nth-child(1)")

hotel_urls = hotels |> 
  html_attr("href") |>
  (\(x) {file.path(url, x)})() |>
  str_subset("durham")

dir.create("data/lq", recursive = TRUE, showWarnings = FALSE)

for (i in seq_along(hotel_urls)) {
  hotel = basename(dirname(hotel_urls[i])) |>
    paste0(".html")
  
  message("Downloading ", hotel, "(", i, "of", length(hotel_urls), ")")
  download.file(
    url = hotel_urls[i],
    destfile = file.path("data/lq", hotel),
    quiet = TRUE
  )
  
  break
}



durham = "https://www.wyndhamhotels.com/laquinta/durham-north-carolina/la-quinta-university-area-chapel-hill/overview"
durham = dir("data/lq", full.names = TRUE)


### In parse_lq.R

readr::read_file(durham) |> # avoids encoding edge cases for a couple hotel
  read_html() |>
  html_nodes(".address-info > a") |>
  html_attr("href")



## Dennys

dennys_url = paste0(
  "https://nomnom-prod-api.dennys.com/restaurants/near?",
  "lat=35.779556&long=-78.638145&",
  "radius=1000&",
  "limit=1000&",
  "nomnom=calendars&nomnom_calendars_from=20241020&nomnom_calendars_to=20241028&nomnom_exclude_extref=999"
)

x = jsonlite::read_json(dennys_url)
View(x)


