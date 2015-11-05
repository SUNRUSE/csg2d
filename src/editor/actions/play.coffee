elementsToMap = require "./../dom/elementsToMap"
valueOfObject = require "./../../utilities/random/valueOfObject"

mapToDistanceField = require "./../../physics/distanceFields/mapToDistanceField"
scene = require "./../../physics/points/scene"
loadRig = require "./../../physics/points/loadRig"
player = require "./../../physics/points/rigs/player"
gravity = require "./../../physics/falloff/gravity"
createPointElement = require "./../dom/createPointElement"
createLinkElement = require "./../dom/createLinkElement"

gamepad = require "./../../input/gamepad"

# On calling, switches the editor to "play" mode, spawning a player and removing all editor controls.
# If no player spawn points exist, an alert is shown and play mode is not entered.
module.exports = () ->
	map = elementsToMap()
	if not map.entities.player
		alert "Please add a player spawn point."
	else
		spawn = valueOfObject map.entities.player
		document.body.setAttribute "mode", "play"
		instance = scene()
		
		# We have to expose the function to stop the event loop somewhere
		# so that the stop button can do it.
		module.exports.stop = instance.stop
		
		distanceField = mapToDistanceField map
		gravityField = gravity map
		created = loadRig distanceField, gravityField, player, spawn.origin, instance, gamepad
		createLinkElement instance, link for name, link of created.links
		createPointElement instance, point for name, point of created.points