describe "valueOfObject", ->
	rewire = require "rewire"
	valueOfObject = undefined
	beforeEach -> valueOfObject = rewire "./valueOfObject"
	
	describe "imports", ->
		it "range", -> expect(valueOfObject.__get__ "range").toBe require "./range"
		
	describe "on calling", ->
		range = obj = undefined
		beforeEach ->
			range = jasmine.createSpy "range"
			valueOfObject.__set__ "range", range
			
			obj = 
				testKeyA: "test value a"
				testKeyB: "test value b"
				testKeyC: "test value c"
				
		it "calls range to determine which value to use", ->
			valueOfObject obj
			expect(range.calls.count()).toEqual 1
			expect(range).toHaveBeenCalledWith 0, 3
			
		it "maps each value to a value (a)" ,->
			range.and.returnValue 0
			expect(valueOfObject obj).toEqual "test value a"
			
		it "maps each value to a value (b)" ,->
			range.and.returnValue 1
			expect(valueOfObject obj).toEqual "test value b"
			
		it "maps each value to a value (c)" ,->
			range.and.returnValue 2
			expect(valueOfObject obj).toEqual "test value c"