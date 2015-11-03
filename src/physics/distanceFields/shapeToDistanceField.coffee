dist = (ax, ay, bx, _by) -> Math.sqrt ((ax - bx) * (ax - bx) + (ay - _by) * (ay - _by))


# Given a shape from map JSON, returns a function which can be called with the X and Y at which to sample and returns the distance to the shape.
module.exports = (shape) ->
	if shape.radius
		(x, y) ->
			(dist shape.origin.x, shape.origin.y, x, y) - shape.radius 
	else
		# Rectangles and ramps are converted to line segment arrays.
		verts = switch shape.ramp
			when "topLeft" then [
					[shape.left, shape.top]
					[shape.left, shape.top + shape.height]
					[shape.left + shape.width, shape.top]
				]
			when "topRight" then [
					[shape.left, shape.top]
					[shape.left + shape.width, shape.top + shape.height]
					[shape.left + shape.width, shape.top]
				]
			when "bottomLeft" then [
					[shape.left, shape.top]
					[shape.left, shape.top + shape.height]
					[shape.left + shape.width, shape.top + shape.height]
				]
			when "bottomRight" then [
					[shape.left, shape.top + shape.height]
					[shape.left + shape.width, shape.top + shape.height]
					[shape.left + shape.width, shape.top]
				]
			else [
					[shape.left, shape.top]
					[shape.left, shape.top + shape.height]
					[shape.left + shape.width, shape.top + shape.height]
					[shape.left + shape.width, shape.top]
				]
				
		segs = for vert, index in verts
			 from: vert
			 to: verts[(index + 1) % verts.length]
			 
		seg.difference = [seg.to[0] - seg.from[0], seg.to[1] - seg.from[1]] for seg in segs
		seg.length = Math.sqrt (seg.difference[0] * seg.difference[0] + seg.difference[1] * seg.difference[1]) for seg in segs

		seg.normal = [-seg.difference[1] / seg.length, seg.difference[0] / seg.length] for seg in segs
		seg.alongNormal = [seg.difference[0] / seg.length, seg.difference[1] / seg.length] for seg in segs
		
		(x, y) ->
			biggestDot = undefined
			for seg in segs
				# The distance to the surface of the segment if it were a plane.
				dot = seg.normal[0] * (x - seg.from[0]) + seg.normal[1] * (y - seg.from[1])
				
				# We're in front of the surface.
				if dot >= 0
					along = seg.alongNormal[0] * (x - seg.from[0]) + seg.alongNormal[1] * (y - seg.from[1])
					switch
						# We're before this segment, so measure the distance to the corner the segment came from.
						when along < 0 then return dist x, y, seg.from[0], seg.from[1] 
						
						# We're before this segment, so measure the distance to the corner the segment is going to.
						when along > seg.length then return dist x, y, seg.to[0], seg.to[1]
						
						# The 
						else return dot
				
				# If all else fails, return the distance closest to the surface.
				if biggestDot is undefined or dot > biggestDot then biggestDot = dot
			biggestDot