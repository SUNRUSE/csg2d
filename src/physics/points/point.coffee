# Given:
# - A distance field function. 
# - An object containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point before application of mass.
#	- material: An object describing the point's static data:
#		- density: When 0, the point is completely unaffected by gravity.  When 1, the point experiences full Earth gravity.
#		- airResistance: When 1, the point will coast forever.  When 2, the point will lose half of its speed every tick.  When 3, the point will lose one third of its speed every tick.
#		- mass: The greater this value, the harder it is to move the point.
#		- friction: When 1, the point does not slow down when in contact with surfaces.  When 2, the point loses half of its speed every tick it is in contact with a surface.
# Returns a function to call to advance the physics of that point by one tick.
slippy = require "./../collision/slippy"

module.exports = (distanceField, point) -> ->
	newX = point.location.x + point.velocity.x / point.material.mass
	newY = point.location.y + point.velocity.y / point.material.mass
	result = slippy distanceField, point.location.x, point.location.y, newX, newY
	if result
		point.location.x = result.x
		point.location.y = result.y
		point.velocity.x /= point.material.friction
		point.velocity.y /= point.material.friction
	else
		point.location.x = newX
		point.location.y = newY
		point.velocity.x /= point.material.airResistance
		point.velocity.y /= point.material.airResistance