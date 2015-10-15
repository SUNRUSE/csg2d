random = Math.random

# Given an inclusive minimum and exclusive maximum value, returns a random integer in that range.
module.exports = (min, max) -> Math.min (min + random() * (max - min))