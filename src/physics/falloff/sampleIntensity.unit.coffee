describe "sampleIntensity", ->
	rewire = require "rewire"
	sampleIntensity = undefined
	beforeEach -> sampleIntensity = rewire "./sampleIntensity"
	
	describe "on calling", ->
		result = undefined
		describe "ambient", ->
			beforeEach ->
				result = sampleIntensity
					origin: 
						x: 12
						y: 4
					angle: 3.7
			it "returns a function", ->
				expect(result).toEqual jasmine.any Function
			describe "on calling the returned function", ->
				beforeEach ->
					result = result
						x: 21
						y: 30
				it "returns a unit vector pointing along the angle", ->
					expect(result.x).toBeCloseTo -0.84810003171
					expect(result.y).toBeCloseTo -0.5298361409