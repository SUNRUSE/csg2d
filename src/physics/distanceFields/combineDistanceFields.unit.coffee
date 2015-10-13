describe "combineDistanceFields", ->
	combineDistanceFields = require "./combineDistanceFields"
	
	describe "without an existing scene", ->
		describe "add", ->
			it "returns the distance to the shape", ->
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				distanceField = combineDistanceFields "add", null, shape
				
				expect(distanceField 4, 7).toEqual 9
				
		describe "subtract", ->
			it "returns the inverse distance to the shape", ->
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				distanceField = combineDistanceFields "subtract", null, shape
				
				expect(distanceField 4, 7).toEqual -9
	
	describe "with an existing scene", ->
		describe "add", ->
			it "returns the distance to the scene when it is closer", ->
				scene = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					14
				
				distanceField = combineDistanceFields "add", scene, shape
				
				expect(distanceField 4, 7).toEqual 9
				
			it "returns the distance to the shape when it is closer", ->
				scene = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					14
				
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				distanceField = combineDistanceFields "add", scene, shape
				
				expect(distanceField 4, 7).toEqual 9
				
		describe "subtract", ->
			it "returns the distance to the scene when outside the shape", ->
				scene = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					14
				
				distanceField = combineDistanceFields "subtract", scene, shape
				
				expect(distanceField 4, 7).toEqual 9
				
			it "returns the inverse distance to the shape when inside the shape", ->
				scene = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					9
				
				shape = (x, y) ->
					expect(x).toBe 4
					expect(y).toBe 7
					-14
				
				distanceField = combineDistanceFields "subtract", scene, shape
				
				expect(distanceField 4, 7).toEqual 14