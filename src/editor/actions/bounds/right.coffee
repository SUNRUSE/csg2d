boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to move the right border of to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
		element.style.width = (Math.max 1, ((Math.round (x / pixelsPerRem)) - (parseInt element.style.left))) + "rem"
	end: boundsChange element