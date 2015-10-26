# Given an element representing an entity defined by falloff, returns a map JSON object to represent the falloff.
module.exports = (element) ->
	output = 
		origin:
			x: parseInt element.style.left
			y: parseInt element.style.top
			
	(output.angle = parseFloat el.style.transform.substring 7) for el in element.children when (el.getAttribute "kind") is "angle"
			
	output