# Given:
# - A distance field function.
# - The function returned by ../falloff/gravity.
# - An object containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point before application of mass.
#	- sprite: The "sprite" property from the rig JSON for this point, if any.
#	- material: An object describing the point's static data:
#		- density: When 0, the point is completely unaffected by gravity.  When 1, the point experiences full Earth gravity.
#		- airResistance: When 1, the point will coast forever.  When 2, the point will lose half of its speed every tick.  When 3, the point will lose two thirds of its speed every tick.
#		- mass: The greater this value, the harder it is to move the point.
#		- friction: When 1, the point does not slow down when in contact with surfaces.  When 2, the point loses half of its speed every tick it is in contact with a surface.
#		- restitution: When 1, the point will bounce forever.  When 2, the point will lose half of its velocity every bounce.  When 3, the point will lose two thirds of its velocity every bounce.
# Returns a function to call to advance the physics of that point by one tick.
slippy = require "./../collision/slippy"
normalToNearestSurface = require "./../distanceFields/normalToNearestSurface"

module.exports = (distanceField, gravity, point) -> ->
	gravitySample = gravity point.location
	point.velocity.x += gravitySample.x * point.material.mass * point.material.density
	point.velocity.y += gravitySample.y * point.material.mass * point.material.density
	newX = point.location.x + point.velocity.x / point.material.mass
	newY = point.location.y + point.velocity.y / point.material.mass
	result = slippy distanceField, point.location.x, point.location.y, newX, newY
	if result
		point.location.x = result.x
		point.location.y = result.y
		normal = normalToNearestSurface distanceField, result.x, result.y
		againstSurface = point.velocity.x * normal.x + point.velocity.y * normal.y
		againstSurface /= point.material.restitution
		acrossSurface = point.velocity.x * normal.y - point.velocity.y * normal.x
		acrossSurface /= point.material.friction
		point.velocity.x = normal.x * (-(Math.abs againstSurface)) + normal.y * acrossSurface
		point.velocity.y = normal.y * (-(Math.abs againstSurface)) - normal.x * acrossSurface
	else
		point.location.x = newX
		point.location.y = newY
		point.velocity.x /= point.material.airResistance
		point.velocity.y /= point.material.airResistance