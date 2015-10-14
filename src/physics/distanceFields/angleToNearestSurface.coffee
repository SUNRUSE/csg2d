# Given:
# - A distance field function.
# - The position on the x axis to sample at.
# - The position on the y axis to sample at.
# Returns the angle to the nearest surface, where 0 is X+ and PI/2 is Y+.
module.exports = (distanceField, x, y) ->
    core = distanceField x, y
    result = Math.atan2 (distanceField x, y + 0.01) - core, (distanceField x + 0.01, y) - core
    result += Math.PI