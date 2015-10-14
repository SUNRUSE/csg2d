history = require "./actions/history"

addShape = require "./actions/addShape"
_delete = require "./actions/delete"
clone = require "./actions/clone"
pullForward = require "./actions/pullForward"
pushBack = require "./actions/pushBack"
operator = require "./actions/operator"

move = require "./actions/bounds/move"
top = require "./actions/bounds/top"
bottom = require "./actions/bounds/bottom"
left = require "./actions/bounds/left"
right = require "./actions/bounds/right"
radius = require "./actions/bounds/radius"

elementsToMap = require "./dom/elementsToMap"
saveFile = require "./io/saveFile"

currentAction = null

# An object exposing three methods:
# - tap: Call with the element clicked/touched when a click/touch ends without manipulation.
# - start: Call with the element clicked/touched at the start of manipulation.
# - move: Call when the pointer moves with the X and Y position in pixels.
# - end. Call when manipulation ends.
module.exports = 
	tap: (element) ->
		if element and not element.getAttribute "disabled"
			switch element.tagName
				when "DIV"
					switch element.className
						when "handle" then switch element.getAttribute "kind"
							when "delete" then _delete element.parentNode
							when "clone" then clone element.parentNode
							when "operator" then operator element.parentNode
							when "pullForward" then pullForward element.parentNode
							when "pushBack" then pushBack element.parentNode
				when "BUTTON"
					switch element.id
						when "undo" then history.undo()
						when "redo" then history.redo()
						when "save" then saveFile "map.json", elementsToMap()
						else switch element.className
							when "add" then addShape (element.getAttribute "shape"), (element.getAttribute "operator")
	start: (element) -> 
		if element and not element.getAttribute "disabled"
			switch element.tagName
				when "DIV"
					switch element.className
						when "handle" then switch element.getAttribute "kind"
							when "move", "left", "right", "top", "bottom", "radiusLeft", "radiusRight", "radiusTop", "radiusBottom"
								currentAction = switch element.getAttribute "kind"
									when "move" then move element.parentNode
									when "left" then left element.parentNode
									when "right" then right element.parentNode
									when "top" then top element.parentNode
									when "bottom" then bottom element.parentNode
									when "radiusLeft", "radiusRight", "radiusTop", "radiusBottom" then radius element.parentNode
	move: (x, y) -> if currentAction then currentAction.move x, y
	end: () -> 
		if currentAction
			currentAction.end()
			currentAction = null