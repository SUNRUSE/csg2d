history = require "./actions/history"

addShape = require "./actions/addShape"
_delete = require "./actions/delete"
clone = require "./actions/clone"
pullForward = require "./actions/pullForward"
pushBack = require "./actions/pushBack"
operator = require "./actions/operator"
turn = require "./actions/turn"

move = require "./actions/bounds/move"
moveMiddle = require "./actions/bounds/moveMiddle"
top = require "./actions/bounds/top"
bottom = require "./actions/bounds/bottom"
left = require "./actions/bounds/left"
right = require "./actions/bounds/right"
radius = require "./actions/bounds/radius"
angle = require "./actions/bounds/angle"

addPlayer = require "./actions/entities/addPlayer"
addGravity = require "./actions/entities/addGravity"

play = require "./actions/play"
stop = require "./actions/stop"

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
							when "turn" then turn element.parentNode
							when "pullForward" then pullForward element.parentNode
							when "pushBack" then pushBack element.parentNode
				when "BUTTON"
					switch element.id
						when "play" then play()
						when "stop" then stop()
						when "undo" then history.undo()
						when "redo" then history.redo()
						when "save" then saveFile "map.json", elementsToMap()
						when "addPlayer" then addPlayer()
						when "addGravity" then addGravity()
						else switch element.className
							when "add" then addShape (element.getAttribute "shape"), (element.getAttribute "operator")
	start: (element) -> 
		if element and not element.getAttribute "disabled"
			switch element.tagName
				when "DIV"
					switch element.className
						when "handle" then switch element.getAttribute "kind"
							when "move", "moveMiddle", "left", "right", "top", "bottom", "radiusLeft", "radiusRight", "radiusTop", "radiusBottom", "angle"
								currentAction = switch element.getAttribute "kind"
									when "move" then move element.parentNode
									when "moveMiddle" then moveMiddle element.parentNode
									when "left" then left element.parentNode
									when "right" then right element.parentNode
									when "top" then top element.parentNode
									when "bottom" then bottom element.parentNode
									when "angle" then angle element
									when "radiusLeft", "radiusRight", "radiusTop", "radiusBottom" then radius element.parentNode
	move: (x, y) -> if currentAction then currentAction.move x, y
	end: () -> 
		if currentAction
			currentAction.end()
			currentAction = null