dist = (ax, ay, bx, _by) -> Math.sqrt ((ax - bx) * (ax - bx) + (ay - _by) * (ay - _by))

# Given a shape from map JSON, returns a function which can be called with the X and Y at which to sample and returns the distance to the shape.
module.exports = (shape) ->
	if shape.radius
		(x, y) ->
			(dist shape.origin.x, shape.origin.y, x, y) - shape.radius 
	else
		(x, y) ->
			left = shape.left - x
			right = x - (shape.left + shape.width)
			top = shape.top - y
			bottom = y - (shape.top + shape.height)
			switch
				when left > 0 and top > 0 then dist left, top, 0, 0
				when right > 0 and top > 0 then dist right, top, 0, 0
				when left > 0 and bottom > 0 then dist left, bottom, 0, 0
				when right > 0 and bottom > 0 then dist right, bottom, 0, 0
				else Math.max left, right, top, bottom 