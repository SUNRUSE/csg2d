describe "radius", ->
	rewire = require "rewire"
	
	radius = undefined
	beforeEach ->
		radius = rewire "./radius"
		
	describe "imports", ->
		it "boundsChange", -> expect(radius.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(radius.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			radius.__set__ "boundsChange", boundsChange
			
			radius.__set__ "pixelsPerRem", 7
			
			element = 
				style:
					left: "6rem"
					top: "10rem"
					width: "16rem"
					height: "16rem"
					# origin: 14, 18
			
			result = radius element
		it "creates a bounds change", ->
			expect(boundsChange).toHaveBeenCalledWith element
			expect(boundsChange.calls.count()).toEqual 1
		it "returns the bounds change as \"end\"", ->
			expect(result.end).toEqual "test end"
		it "does not resize the element", ->
			expect(element.style.width).toEqual "16rem"
			expect(element.style.height).toEqual "16rem"
		it "does not move the element", ->
			expect(element.style.left).toEqual "6rem"
			expect(element.style.top).toEqual "10rem"
		describe "on calling move", ->
			beforeEach -> result.move 250, 335
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "resizes the element", ->
				expect(element.style.width).toEqual "74rem"
				expect(element.style.height).toEqual "74rem"
			it "moves the element", ->
				expect(element.style.left).toEqual "-23rem"
				expect(element.style.top).toEqual "-19rem"
		describe "on calling move on top of the origin", ->
			beforeEach -> result.move 98, 126
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "resizes the element", ->
				expect(element.style.width).toEqual "2rem"
				expect(element.style.height).toEqual "2rem"
			it "moves the element", ->
				expect(element.style.left).toEqual "13rem"
				expect(element.style.top).toEqual "17rem"