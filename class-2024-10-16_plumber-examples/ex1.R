# plumber.R

#* Echo back the input
#* @get /echo
function(msg="hello") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand = rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @get /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}


#* @get /msg/<from>/<to>
function(from, to, msg="Hello!") {
  paste0("From: ", from, ", to: ", to, " - ", msg)
}


#* @get /user/<id:int>
function(id){
  list(
    id = id
  )
}

#* @post /user/<id:int>/<active:bool>
function(id, active){
  list(
    id = id,
    active = active
  )
}