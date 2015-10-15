boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to move to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
# This differs from "move" in that it assumes the origin is the top left of the element.
module.exports = (element) ->
	move: (x, y) -> 
		element.style.left = (Math.round (x / pixelsPerRem)) + "rem"
		element.style.top = (Math.round (y / pixelsPerRem)) + "rem"
	end: boundsChange element