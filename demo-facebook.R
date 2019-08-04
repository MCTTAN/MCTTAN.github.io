
# Analyzing Facebook data with R
install.packages("Rfacebook")

library(Rfacebook)

# Getting data via Graph API explorer
# https://developers.facebook.com/tools/explorer

token <- 'EAAFPB7TXKc0BAKQw7sB7Sc4clr8efacp0G6hv48I73FXpaZB31rqwkVQgZBQt43AW1r3xna9pHilel8RlZCfpvWmmVYNY5qsLHv2KZAPBimBqwG6586p1nO9Erl27i9cKhALXJOZAM1ANzHOg4hPNas9JNiwKxPCTFXpkuZAlZCWp5ZBt18IIwZAbq4FZB1UsgcMk3B6FpteZBQJAZDZD'
me <- getUsers("me", token, private_info = TRUE)

me$name
me$hometown

# Getting data from public profiles
obama <- getPage("barackobama", token)
obama$message