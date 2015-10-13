boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to move the top border of to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
		changeBy = Math.round (y / pixelsPerRem)
		changeBy -= parseInt element.style.top
		changeBy = Math.min changeBy, ((parseInt element.style.height) - 1)
		element.style.top = (parseInt element.style.top) + changeBy + "rem"
		element.style.height = (parseInt element.style.height) - changeBy + "rem"
	end: boundsChange element