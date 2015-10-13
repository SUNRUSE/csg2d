boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to move to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
		element.style.left = (Math.round ((x - ((parseInt element.style.width) * pixelsPerRem / 2)) / pixelsPerRem)) + "rem"
		element.style.top = (Math.round ((y - ((parseInt element.style.height) * pixelsPerRem / 2)) / pixelsPerRem)) + "rem"
	end: boundsChange element