describe "top", ->
	rewire = require "rewire"
	
	top = undefined
	beforeEach ->
		top = rewire "./top"
		
	describe "imports", ->
		it "boundsChange", -> expect(top.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(top.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			top.__set__ "boundsChange", boundsChange
			
			top.__set__ "pixelsPerRem", 7
			
			element = 
				style:
					left: "6rem"
					top: "10rem"
					width: "16rem"
					height: "22rem"
			
			result = top element
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
			beforeEach -> result.move 250, 166
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "moves the element vertically", ->
				expect(element.style.top).toEqual "24rem"
			it "resizes the element vertically", ->
				expect(element.style.height).toEqual "8rem"
			it "does not change the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
				expect(element.style.width).toEqual "16rem"
		describe "on calling move beyond the bottom border", ->
			beforeEach -> result.move 1080, 7000
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "moves the element vertically", ->
				expect(element.style.top).toEqual "31rem"
			it "resizes the element vertically", ->
				expect(element.style.height).toEqual "1rem"
			it "does not change the element horizontally", ->
				expect(element.style.left).toEqual "6rem"
				expect(element.style.width).toEqual "16rem"