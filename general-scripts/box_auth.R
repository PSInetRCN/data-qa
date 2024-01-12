library(fs)
dir_create("~/.boxr-auth", mode = 700)

library(boxr)
box_auth()
