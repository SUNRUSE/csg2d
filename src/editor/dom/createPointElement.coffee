# Given:
# - An instance of ./../../physics/points/scene.
# - A point object returned by ./../../physics/points/point.
# Creates a new div for the point and registers a callback to update its position.
module.exports = (scene, point) ->
	if point.sprite
		div = document.createElement "div"
		div.className = "point"
		div.style.transform = "translate(" + point.location.x + "rem, " + point.location.y + "rem)"
		div.setAttribute "sprite", point.sprite
		document.getElementById "preview"
			.appendChild div
		scene.append -> div.style.transform = "translate(" + point.location.x + "rem, " + point.location.y + "rem)"