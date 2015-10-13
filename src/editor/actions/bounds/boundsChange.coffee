history = require "./../history"

# Call with an element representing a shape before moving or resizing it.
# Call the returned function after moving it.
module.exports = (element) ->
	before =
		left: element.style.left
		top: element.style.top
		width: element.style.width
		height: element.style.height
	->
		after =
			left: element.style.left
			top: element.style.top
			width: element.style.width
			height: element.style.height
			
		undo = ->
			element.style.left = before.left
			element.style.top = before.top
			element.style.width = before.width
			element.style.height = before.height
			
		redo = ->
			element.style.left = after.left
			element.style.top = after.top
			element.style.width = after.width
			element.style.height = after.height
			
		history.addStep undo, redo, (->)