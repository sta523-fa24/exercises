# plumber.R

#* @get /req
function(req, arg="") {
  if (arg == "")
    ls(envir=req)
  else
    req[[arg]]
}


#* @get /res
function(res, arg="") {
  if (arg == "")
    ls(envir=res)
  else
    res[[arg]]
}


#* Return the sum of two numbers
#* @param a:numeric The first number to add
#* @param b:numeric The second number to add
#* @post /sum
#* @get /sum
function(req, res, a, b) {
  as.numeric(a) + as.numeric(b)
}

#* @get /error
#* @serializer html
function() {
  stop("This is an error")
}

#* @get /forbidden
#* @serializer text
function(res) {
  res$status = 403
  res$body = "You are forbidden from accessing this resource"
}
