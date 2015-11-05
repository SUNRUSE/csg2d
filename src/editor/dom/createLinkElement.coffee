# Given:
# - An instance of ./../../physics/points/scene.
# - A link object returned by ./../../physics/points/loadRig.
# Creates a new div for the link and registers a callback to update its position.
module.exports = (scene, link) ->
	if link.sprite
		div = document.createElement "div"
		div.className = "link"
		div.setAttribute "sprite", link.sprite
		update = ->
			diffX = link.to.location.x - link.from.location.x
			diffY = link.to.location.y - link.from.location.y
			dist = Math.sqrt (diffX * diffX + diffY * diffY)
			ang = Math.atan2 diffY, diffX
			div.style.width = dist + "rem"
			div.style.transform = "translate(" + link.from.location.x + "rem, " + link.from.location.y + "rem) rotate(" + ang + "rad)"
		update()
		document.getElementById "preview"
			.appendChild div
		scene.append update