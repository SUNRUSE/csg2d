createHandle = require "./createHandle"

# Given:
# - A JSON object representing a falloff from map JSON.
# - An element an entity is being created for.
# Configures any properties necessary for that element to represent that falloff.
module.exports = (falloff, element) ->
	element.setAttribute "falloff", "ambient"
	element.style.left = falloff.origin.x + "rem"
	element.style.top = falloff.origin.y + "rem"
	angleHandle = createHandle element, "angle"
	angleHandle.style.transform = "rotate(" + falloff.angle + "rad)"
	createHandle element, "moveMiddle"