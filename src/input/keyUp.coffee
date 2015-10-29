# Call with a keydown event to toggle off the mapped key if any.
gamepad = require "./gamepad"
keyMappings = require "./keyMappings"

module.exports = (e) ->
	mapping = keyMappings[e.keyCode]
	if not mapping then return
	gamepad[mapping] = false