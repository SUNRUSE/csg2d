describe "right", ->
	rewire = require "rewire"
	
	right = undefined
	beforeEach ->
		right = rewire "./right"
		
	describe "imports", ->
		it "boundsChange", -> expect(right.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(right.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			right.__set__ "boundsChange", boundsChange
			
			right.__set__ "pixelsPerRem", 7
			
			element = 
				style:
					left: "6rem"
					top: "10rem"
					width: "16rem"
					height: "21rem"
			
			result = right element
		it "creates a bounds change", ->
			expect(boundsChange).toHaveBeenCalledWith element
			expect(boundsChange.calls.count()).toEqual 1
		it "returns the bounds change as \"end\"", ->
			expect(result.end).toEqual "test end"
		it "does not move the element horizontally", ->
			expect(element.style.left).toEqual "6rem"
		it "does not resize the element horizontally", ->
			expect(element.style.width).toEqual "16rem"
		it "does not change the element vertically", ->
			expect(element.style.top).toEqual "10rem"
			expect(element.style.height).toEqual "21rem"
		describe "on calling move", ->
			beforeEach -> result.move 250, 166
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "does not move the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
			it "resizes the element horizontally", ->
				expect(element.style.width).toEqual "30rem"
			it "does not change the element vertically", ->
				expect(element.style.top).toEqual "10rem"
				expect(element.style.height).toEqual "21rem"
		describe "on calling move beyond the left border", ->
			beforeEach -> result.move 5, 166
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "does not move the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
			it "resizes the element horizontally", ->
				expect(element.style.width).toEqual "1rem"
			it "does not change the element vertically", ->
				expect(element.style.top).toEqual "10rem"
				expect(element.style.height).toEqual "21rem"