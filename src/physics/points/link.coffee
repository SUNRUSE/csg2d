# Given:
# - An object representing a first point containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point.
# - An object representing a second point containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point.
# - A multiplier for the force applied, performed before delinearizing.  When zero, no force is applied.  When 1, velocity increases directly proportional to the difference to the original distance.
# - The linearity of the force applied.  When 1, force scales linearly.  When 2, the force is squared. 
# - A multiplier for the force applied, performed after delinearizing.  When zero, no force is applied.  When 1, velocity increases directly proportional to the difference to the original distance.
# Returns a function to call each tick to update the link between the points.
# This will draw the points together when further apart than they started, and push them apart when closer.
# This will only affect velocity.
module.exports = (a, b, linearityScale, linearityShape, strength) ->
	diffX = a.location.x - b.location.x
	diffY = a.location.y - b.location.y
	originalDistance = Math.sqrt (diffX * diffX + diffY * diffY)  
	->
		diffX = a.location.x - b.location.x
		diffY = a.location.y - b.location.y
		newDistance = Math.sqrt (diffX * diffX + diffY * diffY)
		diffX /= newDistance  
		diffY /= newDistance 
		newDistance -= originalDistance
		newDistance *= linearityScale	
		newDistance = if newDistance >= 0 then (Math.pow newDistance, linearityShape) else (-(Math.pow (-newDistance), linearityShape))
		newDistance *= strength
		diffX *= newDistance
		diffY *= newDistance
		a.velocity.x -= diffX
		a.velocity.y -= diffY 
		b.velocity.x += diffX
		b.velocity.y += diffY