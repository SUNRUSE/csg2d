describe "angle", ->
	rewire = require "rewire"
	
	angle = undefined
	beforeEach -> angle = rewire "./angle"
		
	describe "imports", ->
		it "boundsChange", -> expect(angle.__get__ "boundsChange").toBe require "./boundsChange"
		it "pixelsPerRem", -> expect(angle.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		
	describe "on calling", ->
		result = element = boundsChange = undefined
		beforeEach ->
			boundsChange = jasmine.createSpy "boundsChange"
			boundsChange.and.returnValue "test end"
			angle.__set__ "boundsChange", boundsChange
			
			angle.__set__ "pixelsPerRem", 7
			
			element = 
				parentNode:
					style: 
						left: "20rem" # 140
						top: "34rem" # 238
				style:
					transform: "rotate(18rad)"
			
			result = angle element
		it "creates a bounds change", ->
			expect(boundsChange).toHaveBeenCalledWith element
			expect(boundsChange.calls.count()).toEqual 1
		it "returns the bounds change as \"end\"", ->
			expect(result.end).toEqual "test end"
		it "does not turn the element", ->
			expect(element.style.transform).toEqual "rotate(18rad)"
			
		rotateRegex = /rotate\((\d+\.\d+)rad\)$/
			
		describe "on calling move to the top right", ->
			beforeEach -> result.move 160, 228
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "rotates the element", ->
				expect(element.style.transform).toMatch rotateRegex
				expect(parseFloat (rotateRegex.exec element.style.transform)[1]).toBeCloseTo 5.82
		describe "on calling move to the top left", ->
			beforeEach -> result.move 120, 228
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "rotates the element", ->
				expect(element.style.transform).toMatch rotateRegex
				expect(parseFloat (rotateRegex.exec element.style.transform)[1]).toBeCloseTo 3.61
		describe "on calling move to the bottom right", ->
			beforeEach -> result.move 160, 248
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "rotates the element", ->
				expect(element.style.transform).toMatch rotateRegex
				expect(parseFloat (rotateRegex.exec element.style.transform)[1]).toBeCloseTo 0.46
		describe "on calling move to the bottom left", ->
			beforeEach -> result.move 120, 248
			it "does not create another bounds change", ->
				expect(boundsChange.calls.count()).toEqual 1
			it "rotates the element", ->
				expect(element.style.transform).toMatch rotateRegex
				expect(parseFloat (rotateRegex.exec element.style.transform)[1]).toBeCloseTo 2.68