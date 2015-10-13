boundsChange = require "./boundsChange"
pixelsPerRem = require "./../../dom/pixelsPerRem"

# Call with an element you wish to change the radius of to receive an object containing:
# - move: Call with the X and Y positions in pixels to continue manipulation.
# - end: Call to save the finished location to a history step.
module.exports = (element) ->
	move: (x, y) -> 
	    x /= pixelsPerRem
	    y /= pixelsPerRem
	    x -= (parseInt element.style.left) + ((parseInt element.style.width) / 2)
	    y -= (parseInt element.style.top) + ((parseInt element.style.height) / 2)
	    newRadius = Math.max 1, (Math.round (Math.sqrt (x * x + y * y)))
	    difference = (newRadius * 2) - (parseInt element.style.width)
	    difference /= 2
	    element.style.width = element.style.height = newRadius * 2 + "rem"
	    element.style.left = (parseInt element.style.left) - difference + "rem"
	    element.style.top = (parseInt element.style.top) - difference + "rem"
	end: boundsChange element