history = require "./history"

# Call with an element representing a shape to create a new history step deleting it.
module.exports = (element) ->
	parent = element.parentNode
	next = element.nextElementSibling

	undo = ->
		if next
			parent.insertBefore element, next
		else
			parent.appendChild element
			
	redo = -> parent.removeChild element
	redo()
	
	history.addStep undo, redo, (->)