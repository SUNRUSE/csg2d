boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to rotate to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
		element.style.transform = "rotate(" + ((Math.atan2 ((parseInt element.parentNode.style.top) * pixelsPerRem - y), ((parseInt element.parentNode.style.left) * pixelsPerRem - x)) + Math.PI) + "rad)"
	end: boundsChange element