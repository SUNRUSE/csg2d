# Given:
# - A distance field function.
# - The position on the x axis to sample at.
# - The position on the y axis to sample at.
# Returns an object describing a unit vector pointing towards the nearest surface:
# - x
# - y
module.exports = (distanceField, x, y) ->
    core = distanceField x, y
    diffX = (distanceField x - 0.01, y) - core
    diffY = (distanceField x, y - 0.01) - core
    length = Math.sqrt (diffX * diffX + diffY * diffY)
    unused = 
        x: diffX / length
        y: diffY / length
    