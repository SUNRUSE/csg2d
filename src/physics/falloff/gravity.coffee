# Given a map object, returns a function which given a vector specifying where to sample, returns a vector specifying the direction and intensity of gravity at that point.
sampleIntensity = require "./sampleIntensity"

module.exports = (map) ->
	output = (sample) ->
		x: 0
		y: 0
	
	for key, value of map.entities.gravity
		do (value) ->
			intensity = sampleIntensity value.falloff
			wrap = output
			output = (sample) ->
				a = wrap sample
				b = intensity sample
				unused = 
					x: a.x + b.x * value.intensity
					y: a.y + b.y * value.intensity
		
	output