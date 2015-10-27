describe "gravity", ->
	rewire = require "rewire"
	gravity = undefined
	beforeEach -> gravity = rewire "./gravity"
	
	describe "imports", ->
		it "sampleIntensity", -> expect(gravity.__get__ "sampleIntensity").toBe require "./sampleIntensity"
	
	describe "on calling without entities", ->
		result = undefined
		beforeEach ->
			map = 
				entities: {}
						
			gravity.__set__ "sampleIntensity", (falloff) -> fail "Unexpected falloff sampled"
						
			result = gravity map
			
		it "returns a function", ->
			expect(result).toEqual jasmine.any Function
			
		describe "on calling the returned function", ->
			beforeEach ->
				result = result 
					x: 8
					y: 3
			it "returns zero", ->
				expect(result.x).toBeCloseTo 0
				expect(result.y).toBeCloseTo 0 
	
	describe "on calling without gravity entities", ->
		result = undefined
		beforeEach ->
			map = 
				entities:
					unrelatedWithFalloff:
						entityA:
							falloff: "test falloff c"
							intensity: 0.8
					unrelatedWithoutFalloff:
						entityB: {}
						
			gravity.__set__ "sampleIntensity", (falloff) -> fail "Unexpected falloff sampled"
						
			result = gravity map
			
		it "returns a function", ->
			expect(result).toEqual jasmine.any Function
			
		describe "on calling the returned function", ->
			beforeEach ->
				result = result 
					x: 8
					y: 3
			it "returns zero", ->
				expect(result.x).toBeCloseTo 0
				expect(result.y).toBeCloseTo 0 
	
	describe "on calling with gravity entities", ->
		result = undefined
		beforeEach ->
			map = 
				entities:
					gravity:
						gravityA:
							falloff: "test falloff a"
							intensity: 0.6
						gravityB:
							falloff: "test falloff b"
							intensity: -0.3
					unrelatedWithFalloff:
						entityA:
							falloff: "test falloff c"
							intensity: 0.8
					unrelatedWithoutFalloff:
						entityB: {}
						
			gravity.__set__ "sampleIntensity", (falloff) -> switch falloff
				when "test falloff a" then (sample) ->
					expect(sample.x).toEqual 8
					expect(sample.y).toEqual 3
					x: 2
					y: -9
				when "test falloff b" then (sample) ->
					expect(sample.x).toEqual 8
					expect(sample.y).toEqual 3
					x: -5
					y: 7
				else fail "Unexpected falloff sampled"
						
			result = gravity map
			
		it "returns a function", ->
			expect(result).toEqual jasmine.any Function
			
		describe "on calling the returned function", ->
			beforeEach ->
				result = result 
					x: 8
					y: 3
			it "returns the sum of every sampled falloff", ->
				# 2 * 0.6 = 1.2
				# -9 * 0.6 = -5.4
				# -5 * -0.3 = 1.5
				# 7 * -0.3 = -2.1
				expect(result.x).toBeCloseTo 2.7
				expect(result.y).toBeCloseTo -7.5 