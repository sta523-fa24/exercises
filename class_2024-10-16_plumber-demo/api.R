library(tidyverse)
library(plumber)

simpsons = readRDS("simpsons.rds")


#* @apiTitle Simpson's Paradox API
#* @apiDescription Plumber demo for an API that demonstrates Simpson's Paradox
#* using data from the `datasaurus` package

#* @get /data
function() {
  simpsons
}

#* @get /data/html
#* @serializer html
function() {
  knitr::kable(simpsons, format = "html")
}


#* @get /data/plot
#* @serializer png
function(color = "group") {
  print(color)
  g = if (color == "none") {
    ggplot(simpsons, aes(x=x, y=y))
  } else {
    ggplot(simpsons, aes_string(x="x", y="y", color = color))
  }
  
  print(g + geom_point())
}


#* @get /model
#* @serializer print
function(formula = "y~x") {
  lm(as.formula(formula), data=simpsons) |>
    summary()
}

#* @get /model/stats
#* @serializer html
function(formula = "y~x") {
  lm(as.formula(formula), data=simpsons) |>
    broom::glance() |>
    knitr::kable(format="html")
}

#* @post /data/new
#* @serializer print
function(req) {
  simpsons <<- bind_rows(
    simpsons, req$body  
  )
}

