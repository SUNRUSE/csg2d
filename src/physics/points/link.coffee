# Given:
# - An object representing a first point containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point.
# - An object representing a second point containing:
#	- location: Vector specifying the current location of the point.
#	- velocity: Vector specifying the distance to traverse each point.
# - An object representing the material the link is made of containing:
# 	- linearityScale: A multiplier for the force applied, performed before delinearizing.  When zero, no force is applied.  When 1, velocity increases directly proportional to the difference to the original distance.
# 	- linearityShape: The linearity of the force applied.  When 1, force scales linearly.  When 2, the force is squared. 
# 	- strength: A multiplier for the force applied, performed after delinearizing.  When zero, no force is applied.  When 1, velocity increases directly proportional to the difference to the original distance.
# - Null, or an object equivalent to the ./../../input/gamepad object to control the tension of the link. 
# - Null, or an object describing how the link should tense under control.  Keys will be checked for truthiness against the gamepad object equivalent.
#   The target length of the limit will then be divided by the value.  This means:
#       If a key called "crouch" exists in this object with a value of 2, the link will attempt to halve in length when a "crouch" key is true in the gamepad object equivalent.
# Returns a function to call each tick to update the link between the points.
# This will draw the points together when further apart than they started, and push them apart when closer.
# This will only affect velocity.
module.exports = (a, b, material, gamepad, tensions) ->
	diffX = a.location.x - b.location.x
	diffY = a.location.y - b.location.y
	originalDistance = Math.sqrt (diffX * diffX + diffY * diffY)  
	->
		diffX = a.location.x - b.location.x
		diffY = a.location.y - b.location.y
		newDistance = Math.sqrt (diffX * diffX + diffY * diffY)
		diffX /= newDistance  
		diffY /= newDistance 
		scaledDistance = originalDistance
		if gamepad and tensions
			for key, value of tensions
				if gamepad[key] then scaledDistance /= value
		newDistance -= scaledDistance
		newDistance *= material.linearityScale	
		newDistance = if newDistance >= 0 then (Math.pow newDistance, material.linearityShape) else (-(Math.pow (-newDistance), material.linearityShape))
		newDistance *= material.strength
		diffX *= newDistance
		diffY *= newDistance
		a.velocity.x -= diffX
		a.velocity.y -= diffY 
		b.velocity.x += diffX
		b.velocity.y += diffY