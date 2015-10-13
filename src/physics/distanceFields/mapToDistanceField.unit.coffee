describe "mapToDistanceField", ->
	rewire = require "rewire"
	mapToDistanceField = undefined
	beforeEach ->
		mapToDistanceField = rewire "./mapToDistanceField"
	
	describe "imports", ->
		it "shapeToDistanceField", ->
			expect(mapToDistanceField.shapeToDistanceField).toEqual require "./shapeToDistanceField"
		it "combineDistanceFields", ->
			expect(mapToDistanceField.combineDistanceFields).toEqual require "./combineDistanceFields"
	
	describe "on calling", ->
		map = undefined
		
		beforeEach ->
			map = 
				shapes: [
							operator: "test operator a"
							shape: "test shape a"
						,
							operator: "test operator b"
							shape: "test shape b"
						,
							operator: "test operator c"
							shape: "test shape c"
					]
					
			mapToDistanceField.shapeToDistanceField = (shape) ->
				switch shape
					when "test shape a" then "test distance field a"
					when "test shape b" then "test distance field b"
					when "test shape c" then "test distance field c"
					else expect(false).toBeTruthy "unexpected shape"
					
			mapToDistanceField.combineDistanceFields = (operator, scene, shape) ->
				switch operator
					when "test operator a"
						expect(scene).toBeNull()
						expect(shape).toEqual "test distance field a"
						"test scene a"
					when "test operator b"
						expect(scene).toEqual "test scene a"
						expect(shape).toEqual "test distance field b"
						"test scene b"
					when "test operator c"
						expect(scene).toEqual "test scene b"
						expect(shape).toEqual "test distance field c"
						(x, y) ->
							expect(x).toEqual 4
							expect(y).toEqual 7
							"test result"
					else expect(false).toBeTruthy "unexpected operator"
					
		it "returns a distance field", ->
			expect(mapToDistanceField map).toEqual jasmine.any Function
			
		describe "on calling the result", ->
			it "returns the final distance", ->
				expect((mapToDistanceField map) 4, 7).toEqual "test result"