## Exercise 1

### Part 1

typeof( c(1, NA+1L, "C") )  # Character

typeof( c(1L / 0, NA) )     # Double

typeof( c(1:3, 5) )         # Double

typeof( c(3L, NaN+1L) )     # Double

typeof( c(NA, TRUE) )       # Logical


### Part 2

# What is R’s implicit type conversion hierarchy 
# (from highest priority to lowest priority)?
#
# Character > Double > Integer > Logical

## Exercise 2

f = function(x) {
  # Check small prime
  if (x > 10 || x < -10) {
    stop("Input too big")
  } else if (x %in% c(2, 3, 5, 7)) {
    cat("Input is prime!\n")
  } else if (x %% 2 == 0) {
    cat("Input is even!\n")
  } else if (x %% 2 == 1) {
    cat("Input is odd!\n")
  }
}

