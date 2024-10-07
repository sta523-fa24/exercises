library(rvest)
library(tidyverse)

url = "https://www.rottentomatoes.com/"

(session = polite::bow(url))

page = polite::scrape(session)

tibble::tibble(
  title = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul .dynamic-text-list__item-title") |>
    html_text(),
  
  tomatometer = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul rt-text") |>
    html_text2() |>
    str_remove("%$") |>
    as.integer(),
  
  certified = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul score-icon-critics") |>
    html_attr("certified") |>
    str_to_upper() |>
    as.logical(),
  
  sentiment = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul score-icon-critics") |>
    html_attr("sentiment"),
  
  url = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul li a.dynamic-text-list__tomatometer-group") |>
    html_attr("href") |>
    (\(x) paste0(url, x))()
) |>
  mutate(
    status = case_when(
      sentiment == "negative" ~ "rotten",
      !certified ~ "fresh",
      certified ~ "certified fresh"
    ),
    
    mpaa_rating = map_chr(url, get_mpaa_rating)
  ) 

get_mpaa_rating = function(url) {
  message("Scraping ",url)
  
  polite::nod(session, url) |>
    polite::scrape() |>
    html_elements(".unset+ rt-text") |>
    html_text()
}


url = "https://www.rottentomatoes.com//m/salems_lot_2024"




