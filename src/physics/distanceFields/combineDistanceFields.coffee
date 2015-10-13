# Given:
# - A string specifying the operator to use, of "add" or "subtract".
# - The scene distance field to combine with, which is a function taking the X and Y position to sample at and returning the distance to the scene.
# - The shape distance field to combine with, which is a function taking the X and Y position to sample at and returning the distance to the shape.
module.exports = (operator, scene, shape) ->
	if scene
		switch operator
			when "add" then (x, y) -> Math.min (scene x, y), (shape x, y)
			when "subtract" then (x, y) -> Math.max (scene x, y), -(shape x, y)
	else
		switch operator
			when "add" then shape
			when "subtract" then (x, y) -> -(shape x, y) 