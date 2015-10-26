elementToFalloff = require "./elementToFalloff"

# Given an element representing the entity in the viewport.
# Returns an object containing:
# - type: String specifying the type of entity.
# - name: String specifying the name unique to the type of entity.
# - value: Object which can be stored in a map object to represent it.
module.exports = (element) -> 
	type: element.getAttribute "type"
	name: element.getAttribute "name"
	value: switch element.getAttribute "type"
		when "player"
			origin:
				x: parseInt element.style.left
				y: parseInt element.style.top
			facing: element.getAttribute "facing"
		when "gravity"
			output = 
				falloff: elementToFalloff element
			(output.intensity = parseFloat el.value) for el in element.children when el.tagName is "INPUT" 
			output