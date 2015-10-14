normalToNearestSurface = require "./../distanceFields/normalToNearestSurface"

# Given:
# - A distance field function.
# - The position on the X axis at which to start.
# - The position on the Y axis at which to start.
# - The position on the X axis at which to end.
# - The position on the Y axis at which to end.
# Returns:
# - When no collision occurred, null.
# - When a collision occurred, an object:
#   - x: The position on the X axis where a point travelling along the line could have ended.  This may not be on the line.
#   - y: The position on the Y axis where a point travelling along the line could have ended.  This may not be on the line.
module.exports = (distance, aX, aY, bX, bY) ->
    for iteration in [0...5]
        diffX = bX - aX
        diffY = bY - aY
        len = Math.sqrt (diffX * diffX + diffY * diffY)
        normX = diffX / len
        normY = diffY / len
        travelled = 0
        for x in [0...50]
            dist = distance aX, aY
            travelled += dist
            if travelled > len
                if iteration then return unused = 
                    x: bX
                    y: bY
                else return null
            if dist < 0.01
                norm = normalToNearestSurface distance, aX, aY
                aX -= norm.x * 0.05
                aY -= norm.y * 0.05
                adjust = (bX - aX) * norm.x + (bY - aY) * norm.y
                bX -= norm.x * adjust
                bY -= norm.y * adjust
                break
            aX += normX * dist
            aY += normY * dist
    unused = 
        x: bX
        y: bY