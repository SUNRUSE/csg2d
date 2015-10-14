describe "normalToNearestSurface", ->
    normalToNearestSurface = require "./normalToNearestSurface"
    mapToDistanceField = require "./mapToDistanceField"
    distanceField = mapToDistanceField require "./angleToNearestSurface.json"
    
    anglesSame = (x, y, eX, eY) ->
        actual = normalToNearestSurface distanceField, x, y
        it "is close to " + eX + ", " + eY, ->
            expect(actual.x).toBeCloseTo eX
            expect(actual.y).toBeCloseTo eY
    
    describe "when left of an additive rectangle", ->
        anglesSame 215, 254, 1, 0
        
    describe "when above an additive rectangle", ->
        anglesSame 233, 227, 0, 1
        
    describe "when right of an additive rectangle", ->
        anglesSame 256, 255, -1, 0
        
    describe "when below an additive rectangle", ->
        anglesSame 233, 270, 0, -1
        
    describe "when near the bottom right corner of an additive rectangle", ->
        anglesSame 254, 268, -0.70710678118, -0.70710678118
        
    describe "when near the top left corner of an additive rectangle", ->
        anglesSame 218, 231, 0.70710678118, 0.70710678118
        
    describe "when near the top right corner of an additive rectangle", ->
        anglesSame 255, 231, -0.70710678118, 0.70710678118
        
    describe "when near the bottom left corner of an additive rectangle", ->
        anglesSame 218, 269, 0.70710678118, -0.70710678118
        
        
    describe "when near the right wall of a subtractive rectangle", ->
        anglesSame 287, 233, 1, 0
        
    describe "when near the bottom wall of a subtractive rectangle", ->
        anglesSame 276, 241, 0, 1
        
    describe "when near the left wall of a subtractive rectangle", ->
        anglesSame 269, 233, -1, 0
        
    describe "when near the top wall of a subtractive rectangle", ->
        anglesSame 276, 226, 0, -1
        
        
    describe "when near the bottom right wall of an additive circle", ->
        anglesSame 294, 253, -0.70710678118, -0.70710678118
        
    describe "when near the top left wall of an additive circle", ->
        anglesSame 260, 219, 0.70710678118, 0.70710678118
        
    describe "when near the top right wall of an additive circle", ->
        anglesSame 294, 219, -0.70710678118, 0.70710678118
        
    describe "when near the bottom left wall of an additive circle", ->
        anglesSame 262, 251, 0.70710678118, -0.70710678118
        
    describe "when near the right wall of an additive circle", ->
        anglesSame 297, 236, -1, 0
        
    describe "when near the bottom wall of an additive circle", ->
        anglesSame 277, 254, 0, -1
        
    describe "when near the left wall of an additive circle", ->
        anglesSame 258, 236, 1, 0
        
    describe "when near the top wall of an additive circle", ->
        anglesSame 277, 216, 0, 1
        
        
    describe "when near the top left wall of a subtractive circle", ->
        anglesSame 238, 245, -0.70710678118, -0.70710678118
        
    describe "when near the bottom right wall of a subtractive circle", ->
        anglesSame 242, 249, 0.70710678118, 0.70710678118
        
    describe "when near the bottom left wall of a subtractive circle", ->
        anglesSame 239, 250, -0.70710678118, 0.70710678118
        
    describe "when near the top right wall of a subtractive circle", ->
        anglesSame 243, 246, 0.70710678118, -0.70710678118
        
    describe "when near the right wall of a subtractive circle", ->
        anglesSame 245, 248, 1, 0
        
    describe "when near the bottom wall of a subtractive circle", ->
        anglesSame 241, 252, 0, 1
        
    describe "when near the left wall of a subtractive circle", ->
        anglesSame 234, 248, -1, 0
        
    describe "when near the top wall of a subtractive circle", ->
        anglesSame 241, 241, 0, -1