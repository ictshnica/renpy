library(plumber)
# LOADING SCRIPT
r <- plumb("backend_example.R")
# DEFINING GROUP NUMBER
GROUP_NUMBER = 02
# THIS WILL BE AVAILABLE 
r$run(port=8100 + GROUP_NUMBER)
