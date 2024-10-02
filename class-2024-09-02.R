## Exercise 1

x = 5
y = 2
f = function() {
  if (x %% 2 == 1 & y %% 2 == 0) {
    stop("x is odd and y is even!", call. = TRUE)
  }
  
  if (x > 3 & y <= 3) {
    print("Hello world!")
  } else if (x > 3) {
    print("!dlrow olleH")
  } else if (x <= 3) {
    print("Something else ...")
  }
}

f(x,y)

## Exercise 3

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 
            29, 31, 37, 41, 43, 47, 53, 59, 61, 
            67, 71, 73, 79, 83, 89, 97)

x = c(3,4,12,19,23,51,61,63,78)
res = c()
for (val in x) {
  is_prime = FALSE
  
  for (prime in primes) {
    if (val == prime) {
      is_prime = TRUE
      break
    }
  }
  
  if (!is_prime)
    res = c(res, val)
}

res

x[!x %in% primes]
