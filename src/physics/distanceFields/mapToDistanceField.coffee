# Given a map JSON object, returns a distance field; a function which can be called with the X and Y at which to sample and returns the distance to the scene.
module.exports = (map) ->
	scene = null
	for shape in map.shapes
		distanceField = module.exports.shapeToDistanceField shape.shape
		scene = module.exports.combineDistanceFields shape.operator, scene, distanceField
	return scene
	
module.exports.shapeToDistanceField = require "./shapeToDistanceField"
module.exports.combineDistanceFields = require "./combineDistanceFields"