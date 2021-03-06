describe "move", ->
	rewire = require "rewire"
	
	move = undefined
	beforeEach ->
		move = rewire "./move"
		
	describe "imports", ->
		it "boundsChange", -> expect(move.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(move.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			move.__set__ "boundsChange", boundsChange
			
			move.__set__ "pixelsPerRem", 7
			
			element = 
				style:
					left: "6rem"
					top: "10rem"
					width: "16rem"
					height: "21rem"
			
			result = move element
		it "creates a bounds change", ->
			expect(boundsChange).toHaveBeenCalledWith element
			expect(boundsChange.calls.count()).toEqual 1
		it "returns the bounds change as \"end\"", ->
			expect(result.end).toEqual "test end"
		it "does not move the element horizontally", ->
			expect(element.style.left).toEqual "6rem"
		it "does not move the element vertically", ->
			expect(element.style.top).toEqual "10rem"
		it "does not resize the element", ->
			expect(element.style.width).toEqual "16rem"
			expect(element.style.height).toEqual "21rem"
		describe "on calling move", ->
			beforeEach -> result.move 350, 225
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "moves the element horizontally", ->
				expect(element.style.left).toEqual "42rem"
			it "moves the element vertically", ->
				expect(element.style.top).toEqual "22rem"
			it "does not resize the element", ->
				expect(element.style.width).toEqual "16rem"
				expect(element.style.height).toEqual "21rem"