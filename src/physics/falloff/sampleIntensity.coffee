# Given a map falloff object, returns a function which given a vector specifying where to sample, returns a vector specifying the direction and intensity of the falloff. 
module.exports = (falloff) ->
	x = Math.cos (falloff.angle)
	y = Math.sin (falloff.angle)
	(location) ->
		x: x
		y: y 