describe "point", ->
	rewire = require "rewire"
	point = undefined
	beforeEach -> point = rewire "./point"
	
	describe "imports", ->
		it "slippy", -> expect(point.__get__ "slippy").toBe require "./../collision/slippy"
	
	describe "on calling", ->
		distanceField = slippy = model = result = undefined
		beforeEach ->
			distanceField = jasmine.createSpy "distanceField"
			
			slippy = jasmine.createSpy "slippy"
			point.__set__ "slippy", slippy
			
			model = {}
			result = point distanceField, model 
		it "does not modify the point", ->
			expect(model).toEqual {}
		it "returns a function", ->
			expect(result).toEqual jasmine.any Function
		it "does not sample the distance field", ->
			expect(distanceField).not.toHaveBeenCalled()
		it "does not perform any collision", ->
			expect(slippy).not.toHaveBeenCalled()
		describe "on calling the returned function", ->
			beforeEach ->
				model.location =
					x: 7
					y: 14
				model.velocity = 
					x: 2
					y: -3.5
				model.material = 
					density: 0.7
					airResistance: 2
					mass: 8
					friction: 4
			describe "on not colliding", ->
				beforeEach ->
					slippy.and.returnValue null
					result()
				it "sends the position and the position incremented by the velocity divided by the mass to sliding collision", ->
					expect(slippy.calls.count()).toEqual 1
					expect(slippy).toHaveBeenCalledWith distanceField, 7, 14, 7.25, 13.5625
				it "copies the position incremented by the velocity divided by mass to the point's location", ->
					expect(model.location.x).toEqual 7.25
					expect(model.location.y).toEqual 13.5625
				it "divides the velocity by the material's air resistance", ->
					expect(model.velocity.x).toEqual 1
					expect(model.velocity.y).toEqual -1.75
				it "does not modify the material", ->
					expect(model.material.density).toEqual 0.7
					expect(model.material.airResistance).toEqual 2
					expect(model.material.mass).toEqual 8
					expect(model.material.friction).toEqual 4
				it "does not sample the distance field", ->
					expect(distanceField).not.toHaveBeenCalled()
			describe "on colliding", ->
				beforeEach ->
					slippy.and.returnValue
						x: 2
						y: 11
					result()
				it "sends the position and the position incremented by the velocity divided by the mass to sliding collision", ->
					expect(slippy.calls.count()).toEqual 1
					expect(slippy).toHaveBeenCalledWith distanceField, 7, 14, 7.25, 13.5625
				it "copies the resulting location to the point's location", ->
					expect(model.location.x).toEqual 2
					expect(model.location.y).toEqual 11
				it "divides the velocity by the material's friction", ->
					expect(model.velocity.x).toEqual 0.5
					expect(model.velocity.y).toEqual -0.875
				it "does not modify the material", ->
					expect(model.material.density).toEqual 0.7
					expect(model.material.airResistance).toEqual 2
					expect(model.material.mass).toEqual 8
					expect(model.material.friction).toEqual 4
				it "does not sample the distance field", ->
					expect(distanceField).not.toHaveBeenCalled()