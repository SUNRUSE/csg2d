describe "angleToNearestSurface", ->
    angleToNearestSurface = require "./angleToNearestSurface"
    mapToDistanceField = require "./mapToDistanceField"
    distanceField = mapToDistanceField require "./angleToNearestSurface.json"
    
    anglesSame = (x, y, numerator, denominator) ->
        actual = angleToNearestSurface distanceField, x, y
        it "is at least 0", ->
            expect(actual >= 0).toBeTruthy()
        it "is at most 2PI", ->
            expect(actual <= Math.PI * 2).toBeTruthy()
            
        it "is close to " + numerator + "PI/" + denominator, ->
            expect(Math.cos actual).toBeCloseTo Math.cos (numerator * Math.PI / denominator)
            expect(Math.sin actual).toBeCloseTo Math.sin (numerator * Math.PI / denominator)
    
    describe "when left of an additive rectangle", ->
        anglesSame 215, 254, 0, 1
        
    describe "when above an additive rectangle", ->
        anglesSame 233, 227, 1, 2
        
    describe "when right of an additive rectangle", ->
        anglesSame 256, 255, 1, 1
        
    describe "when below an additive rectangle", ->
        anglesSame 233, 270, 3, 2
        
    describe "when near the bottom right corner of an additive rectangle", ->
        anglesSame 254, 268, 5, 4
        
    describe "when near the top left corner of an additive rectangle", ->
        anglesSame 218, 231, 1, 4
        
    describe "when near the top right corner of an additive rectangle", ->
        anglesSame 255, 231, 3, 4
        
    describe "when near the bottom left corner of an additive rectangle", ->
        anglesSame 218, 269, 7, 4
        
        
    describe "when near the right wall of a subtractive rectangle", ->
        anglesSame 287, 233, 0, 1
        
    describe "when near the bottom wall of a subtractive rectangle", ->
        anglesSame 276, 241, 1, 2
        
    describe "when near the left wall of a subtractive rectangle", ->
        anglesSame 269, 233, 1, 1
        
    describe "when near the top wall of a subtractive rectangle", ->
        anglesSame 276, 226, 3, 2
        
        
    describe "when near the bottom right wall of an additive circle", ->
        anglesSame 294, 253, 5, 4
        
    describe "when near the top left wall of an additive circle", ->
        anglesSame 260, 219, 1, 4
        
    describe "when near the top right wall of an additive circle", ->
        anglesSame 294, 219, 3, 4
        
    describe "when near the bottom left wall of an additive circle", ->
        anglesSame 262, 251, 7, 4
        
    describe "when near the right wall of an additive circle", ->
        anglesSame 297, 236, 1, 1
        
    describe "when near the bottom wall of an additive circle", ->
        anglesSame 277, 254, 3, 2
        
    describe "when near the left wall of an additive circle", ->
        anglesSame 258, 236, 0, 1
        
    describe "when near the top wall of an additive circle", ->
        anglesSame 277, 216, 1, 2
        
        
    describe "when near the top left wall of a subtractive circle", ->
        anglesSame 238, 245, 5, 4
        
    describe "when near the bottom right wall of a subtractive circle", ->
        anglesSame 242, 249, 1, 4
        
    describe "when near the bottom left wall of a subtractive circle", ->
        anglesSame 239, 250, 3, 4
        
    describe "when near the top right wall of a subtractive circle", ->
        anglesSame 243, 246, 7, 4
        
    describe "when near the right wall of a subtractive circle", ->
        anglesSame 245, 248, 0, 1
        
    describe "when near the bottom wall of a subtractive circle", ->
        anglesSame 241, 252, 1, 2
        
    describe "when near the left wall of a subtractive circle", ->
        anglesSame 234, 248, 1, 1
        
    describe "when near the top wall of a subtractive circle", ->
        anglesSame 241, 241, 3, 2