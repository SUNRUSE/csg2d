point = require "./point"
link = require "./link"

# Given:
# - A distance field function to collide against.
# - A JSON object specifying a rig to load.
# - A vector specifying an offset.  This is added to each point's X location.
# - The object returned by "scene".
# - A function called for every point.  This is given the point object created and the returned function will be called after every update of the point's location.
module.exports = (distanceField, rig, offset, scene, create) ->
	createdPoints = {}
	for name, rigPoint of rig.points
		newPoint = 
			location:
				x: offset.x + rigPoint.location.x
				y: offset.y + rigPoint.location.y
			velocity:
				x: 0
				y: 0
			material: rig.materials[rigPoint.material]
		createdPoints[name] = newPoint
		scene.append point distanceField, newPoint
		scene.append create newPoint
	for name, rigLink of rig.links
		scene.append link createdPoints[rigLink.from], createdPoints[rigLink.to], rigLink.strength, rigLink.linearity