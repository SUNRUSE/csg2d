addElement = require "./addElement"

# Call with an element representing a shape to create a clone of it one row down and one column to the right.
module.exports = (element) ->
	clone = element.cloneNode true
	clone.style.left = (parseInt clone.style.left) + 1 + "rem"
	clone.style.top = (parseInt clone.style.top) + 1 + "rem"
	addElement clone, "shapes"