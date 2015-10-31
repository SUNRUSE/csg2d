point = require "./point"
link = require "./link"

# Given:
# - A distance field function to collide against.
# - The function returned by ../falloff/gravity.
# - A JSON object specifying a rig to load.
# - A vector specifying an offset.  This is added to each point's location.
# - The object returned by "scene".
# - A function called for every point.  This is given the point object created and the returned function will be called after every update of the point's location.
# - Null, or an object equivalent to the ./../../input/gamepad object to control the tension of links in the rig.
module.exports = (distanceField, gravity, rig, offset, scene, create, gamepad) ->
	if window then window.rig = rig
	createdPoints = {}
	for name, rigPoint of rig.points
		newPoint = 
			location:
				x: offset.x + rigPoint.location.x
				y: offset.y + rigPoint.location.y
			velocity:
				x: 0
				y: 0
			material: rig.pointMaterials[rigPoint.material]
		createdPoints[name] = newPoint
		scene.append point distanceField, gravity, newPoint
		scene.append create newPoint
	for name, rigLink of rig.links
		scene.append link createdPoints[rigLink.from], createdPoints[rigLink.to], rig.linkMaterials[rigLink.material], gamepad, rigLink.controls