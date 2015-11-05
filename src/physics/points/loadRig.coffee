point = require "./point"
link = require "./link"

# Given:
# - A distance field function to collide against.
# - The function returned by ../falloff/gravity.
# - A JSON object specifying a rig to load.
# - A vector specifying an offset.  This is added to each point's location.
# - The object returned by "scene".
# - Null, or an object equivalent to the ./../../input/gamepad object to control the tension of links in the rig.
# Returns an object containing:
# - points: An object where the keys are the names of the points and the values are the created point objects.
# - links: An object where the keys are the name of the links and the values are objects containing:
#	- from: The created point object the link runs from.
#	- to: The created point object the link runs to.
#	- sprite: The "sprite" property from the rig JSON for this link, if any.
module.exports = (distanceField, gravity, rig, offset, scene, gamepad) ->
	if window then window.rig = rig
	output = 
		points: {}
		links: {}
	for name, rigPoint of rig.points
		newPoint = 
			location:
				x: offset.x + rigPoint.location.x
				y: offset.y + rigPoint.location.y
			velocity:
				x: 0
				y: 0
			material: rig.pointMaterials[rigPoint.material]
		if rigPoint.sprite then newPoint.sprite = rigPoint.sprite
		output.points[name] = newPoint
		scene.append point distanceField, gravity, newPoint
	for name, rigLink of rig.links
		scene.append link output.points[rigLink.from], output.points[rigLink.to], rig.linkMaterials[rigLink.material], gamepad, rigLink.controls
		output.links[name] = 
			from: output.points[rigLink.from]
			to: output.points[rigLink.to]
			sprite: rigLink.sprite
	output