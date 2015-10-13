boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to move the left border of to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
		changeBy = Math.round (x / pixelsPerRem)
		changeBy -= parseInt element.style.left
		changeBy = Math.min changeBy, ((parseInt element.style.width) - 1)
		element.style.left = (parseInt element.style.left) + changeBy + "rem"
		element.style.width = (parseInt element.style.width) - changeBy + "rem"
	end: boundsChange element