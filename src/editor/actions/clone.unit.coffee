describe "clone", ->
	rewire = require "rewire"
	clone = undefined
	beforeEach ->
		clone = rewire "./clone"
		
	describe "imports", ->
		it "addShapeElement", ->
			expect(clone.__get__ "addShapeElement").toBe require "./addShapeElement"
	
	describe "on calling", ->
		addShapeElement = _clone = original = undefined
		beforeEach ->
			addShapeElement = jasmine.createSpy "addShapeElement"
			clone.__set__ "addShapeElement", addShapeElement

			_clone = undefined
			
			original =
				style:
					left: "3rem"
					top: "17rem"
				cloneNode: (deep) ->
					expect(deep).toBeTruthy()
					expect(_clone).toBeUndefined()
					_clone = 					
						style:
							left: "3rem"
							top: "17rem"		
				
			clone original
			
		it "does not modify the original", ->
			expect(original).toEqual
				cloneNode: jasmine.any Function
				style:
					left: "3rem"
					top: "17rem"
		it "moves the clone down one row", ->
			expect(_clone.style.top).toEqual "18rem"
		it "moves the clone right one column", ->
			expect(_clone.style.left).toEqual "4rem"
		it "appends the cloned element to the viewport", ->
			expect(addShapeElement.calls.count()).toEqual 1
			expect(addShapeElement).toHaveBeenCalledWith _clone