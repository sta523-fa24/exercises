# plumber.R

clicks = 0

#* @get /increment
function() {
  clicks <<- clicks + 1
  list(clicks = clicks)
}

#* @get /current
function() {
  list(clicks = clicks)
}
