describe "bottom", ->
	rewire = require "rewire"
	
	bottom = undefined
	beforeEach ->
		bottom = rewire "./bottom"
		
	describe "imports", ->
		it "boundsChange", -> expect(bottom.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(bottom.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			bottom.__set__ "boundsChange", boundsChange
			
			bottom.__set__ "pixelsPerRem", 7
			
			element = 
				style:
					left: "6rem"
					top: "10rem"
					width: "16rem"
					height: "22rem"
			
			result = bottom element
		it "creates a bounds change", ->
			expect(boundsChange).toHaveBeenCalledWith element
			expect(boundsChange.calls.count()).toEqual 1
		it "returns the bounds change as \"end\"", ->
			expect(result.end).toEqual "test end"
		it "does not move the element vertically", ->
			expect(element.style.top).toEqual "10rem"
		it "does not resize the element vertically", ->
			expect(element.style.height).toEqual "22rem"
		it "does not change the element horizontally", ->
			expect(element.style.left).toEqual "6rem"
			expect(element.style.width).toEqual "16rem"
		describe "on calling move", ->
			beforeEach -> result.move 250, 335
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "does not move the element vertically", ->
				expect(element.style.top).toEqual "10rem"
			it "resizes the element vertically", ->
				expect(element.style.height).toEqual "38rem"
			it "does not change the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
				expect(element.style.width).toEqual "16rem"
		describe "on calling move beyond the top border", ->
			beforeEach -> result.move 1080, 5
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "does not move the element vertically", ->
				expect(element.style.top).toEqual "10rem"
			it "resizes the element vertically", ->
				expect(element.style.height).toEqual "1rem"
			it "does not change the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
				expect(element.style.width).toEqual "16rem"