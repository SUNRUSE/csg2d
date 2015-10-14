# Given:
# - A distance field function.
# - The position on the X axis at which to start.
# - The position on the Y axis at which to start.
# - The position on the X axis at which to end.
# - The position on the Y axis at which to end.
# Returns:
# - When no collision occurred, null.
# - When a collision occurred, an object:
#   - x: The position on the X axis where the collision occurred.
#   - y: The position on the Y axis where the collision occurred.
module.exports = (distance, aX, aY, bX, bY) ->
    diffX = bX - aX
    diffY = bY - aY
    len = Math.sqrt (diffX * diffX + diffY * diffY)
    normX = diffX / len
    normY = diffY / len
    posX = aX
    posY = aY
    travelled = 0
    for x in [0...50]
        dist = distance posX, posY
        travelled += dist
        if travelled > len then return null
        if dist < 0.01 then return unused = 
            x: posX
            y: posY
        posX += normX * dist
        posY += normY * dist