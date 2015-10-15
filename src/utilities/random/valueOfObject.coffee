range = require "./range"

# Given an object containing at least one key/value, returns a randomly selected value from it.
module.exports = (obj) ->
	total = 0
	total++ for key of obj
	total = range 0, total
	for key, value of obj
		if not total-- then return value