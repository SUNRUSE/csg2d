describe "clone", ->
	rewire = require "rewire"
	clone = undefined
	beforeEach ->
		clone = rewire "./clone"
		
	describe "imports", ->
		it "addElement", ->
			expect(clone.__get__ "addElement").toBe require "./addElement"
	
	describe "on calling", ->
		addElement = _clone = original = undefined
		beforeEach ->
			addElement = jasmine.createSpy "addElement"
			clone.__set__ "addElement", addElement

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
			expect(addElement.calls.count()).toEqual 1
			expect(addElement).toHaveBeenCalledWith _clone, "shapes"