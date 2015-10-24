random = Math.random

# Given an inclusive minimum and exclusive maximum value, returns a random integer in that range.
module.exports = (min, max) ->
	if min is max
		min
	else 
		Math.round (min + random() * (max - min - 1))