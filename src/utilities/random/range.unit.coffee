describe "range", ->
	rewire = require "rewire"
	
	range = undefined
	beforeEach -> range = rewire "./range"
	
	describe "imports", ->
		it "Math.random", -> expect(range.__get__ "random").toBe Math.random
	
	describe "on calling", ->
		random = undefined
		beforeEach ->
			tried = false
			range.__set__ "random", -> 
				if tried then fail "Sampled Math.random multiple times"
				random
	
		describe "when given identical min and max", ->
			it "returns min at 0.0", ->
				random = 0.0
				expect(range 3, 3).toEqual 3
				
			it "returns min/max at 0.5", ->
				random = 0.5
				expect(range 3, 3).toEqual 3
				
			it "returns max at 1.0", ->
				random = 1.0
				expect(range 3, 3).toEqual 3
				
		describe "when given positive min/max", ->
			it "returns min at 0.0", ->
				random = 0.0
				expect(range 3, 7).toEqual 3
				
			it "returns between min and max at 0.5", ->
				random = 0.5
				expect(range 3, 7).toEqual 5
				
			it "returns max at 1.0", ->
				random = 1.0
				expect(range 3, 7).toEqual 7
				
		describe "when given negative min/max", ->
			it "returns min at 0.0", ->
				random = 0.0
				expect(range -7, -3).toEqual -7
				
			it "returns between min and max at 0.5", ->
				random = 0.5
				expect(range -7, -3).toEqual -5
				
			it "returns max at 1.0", ->
				random = 1.0
				expect(range -7, -3).toEqual -3
				
		describe "when given negative min and positive max", ->
			it "returns min at 0.0", ->
				random = 0.0
				expect(range -3, 7).toEqual -3
				
			it "returns between min and max at 0.5", ->
				random = 0.5
				expect(range -3, 7).toEqual 2
				
			it "returns max at 1.0", ->
				random = 1.0
				expect(range -3, 7).toEqual 7