library(plumber)
# LOADING SCRIPT
r <- plumb("backend_example.R")
# DEFINING GROUP NUMBER
GROUP_NUMBER = 01
# THIS WILL BE AVAILABLE AT http://p01.piterdata.ninja
r$run(port=8100 + GROUP_NUMBER)
