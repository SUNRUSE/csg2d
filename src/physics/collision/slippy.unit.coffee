describe "slippy", ->
    slippy = require "./slippy"
    mapToDistanceField = require "./../distanceFields/mapToDistanceField"
    distanceField = mapToDistanceField require "./testMap.json"
    
    describe "when the line misses by passing through a subtractive area", ->
        it "returns null", ->
            expect(slippy distanceField, 241, 268, 223, 232).toBeNull()
            
    describe "when the line misses the entire scene", ->
        it "returns null", ->
            expect(slippy distanceField, 217, 228, 272, 235).toBeNull()
            
    describe "when the line hits a subtractive circle", ->
        it "returns the point slippy collision ended", ->
            result = slippy distanceField, 241, 267, 236, 252
            expect(result.x).toBeCloseTo 235.6, 0.7
            expect(result.y).toBeCloseTo 252.7, 0.7
        
    describe "when the line hits an additive circle", ->
        it "returns the point slippy collision ended", ->
            result = slippy distanceField, 246, 266, 249, 254
            expect(result.x).toBeCloseTo 247, 0.7
            expect(result.y).toBeCloseTo 256.2, 0.7
            
    describe "when the line hits an additive square", ->
        it "returns the point slippy collision ended", ->
            result = slippy distanceField, 246, 261, 242, 257
            expect(result.x).toBeCloseTo 243, 0.7
            expect(result.y).toBeCloseTo 257, 0.7
            
    describe "when the line hits a subtractive square", ->
        it "returns the point slippy collision ended", ->
            result = slippy distanceField, 257, 260, 250, 246
            expect(result.x).toBeCloseTo 251, 0.7
            expect(result.y).toBeCloseTo 246, 0.7
            
    describe "when the line falls short of hitting a subtractive circle", ->
        it "returns null", ->
            expect(slippy distanceField, 242, 266, 238, 255).toBeNull()
        
    describe "when the line falls short of hitting an additive circle", ->
        it "returns null", ->
            expect(slippy distanceField, 245, 266, 249, 259).toBeNull()
            
    describe "when the line falls short of hitting an additive square", ->
        it "returns null", ->
            expect(slippy distanceField, 247, 260, 244, 257).toBeNull()
            
    describe "when the line falls short of hitting a subtractive square", ->
        it "returns null", ->
            expect(slippy distanceField, 257, 261, 252, 252).toBeNull()
            
    describe "when the line goes in the wrong direction to hit a subtractive circle", ->
        it "returns null", ->
            expect(slippy distanceField, 238, 255, 242, 266).toBeNull()
        
    describe "when the line goes in the wrong direction to hit an additive circle", ->
        it "returns null", ->
            expect(slippy distanceField, 249, 259, 245, 266).toBeNull()
            
    describe "when the line goes in the wrong direction to hit an additive square", ->
        it "returns null", ->
            expect(slippy distanceField, 244, 257, 247, 260).toBeNull()
            
    describe "when the line goes in the wrong direction to hit a subtractive square", ->
        it "returns null", ->
            expect(slippy distanceField, 252, 252, 257, 261).toBeNull()
            
    describe "when the line does not move", ->
        it "returns null", ->
            expect(slippy distanceField, 252, 252, 252, 252).toBeNull()
            
    it "does not get stuck when crossing the borders between subtractive shapes within an additive shape", ->
        distanceField2 = mapToDistanceField require "./touchingSubtractiveShapes.json"
        expect(slippy distanceField2, 225, 233, 264, 259).toBeNull()