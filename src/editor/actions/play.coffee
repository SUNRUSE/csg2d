elementsToMap = require "./../dom/elementsToMap"
valueOfObject = require "./../../utilities/random/valueOfObject"

# On calling, switches the editor to "play" mode, spawning a player and removing all editor controls.
# If no player spawn points exist, an alert is shown and play mode is not entered.
module.exports = () ->
	map = elementsToMap()
	if not map.entities.player
		alert "Please add a player spawn point."
	else
		spawn = valueOfObject map.entities.player
		document.body.setAttribute "mode", "play"