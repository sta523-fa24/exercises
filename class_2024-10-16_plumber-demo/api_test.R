library(httr2)

library(job)
empty({
  library(plumber)
  plumb(file='api.R')$run(port=4443)
})
