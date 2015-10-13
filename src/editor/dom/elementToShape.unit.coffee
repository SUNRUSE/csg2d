describe "elementToShape", ->
	elementToShape = undefined
	rewire = require "rewire"
	beforeEach -> 
		elementToShape = require "./elementToShape"
	describe "circle", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "circle"
						when "operator" then "test operator"
						else null
				style:
					left: "4rem"
					top: "7rem"
					width: "6rem"
					height: "6rem"
		it "copies the operator", ->
			expect(result.operator).toEqual "test operator"
		it "copies the radius", ->
			expect(result.shape.radius).toEqual 3
		it "copies the origin", ->
			expect(result.shape.origin.x).toEqual 7
			expect(result.shape.origin.y).toEqual 10
			
	describe "rectangle", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "rectangle" then "circle"
						when "operator" then "test operator"
						else null
				style:
					left: "4rem"
					top: "7rem"
					width: "9rem"
					height: "6rem"
		it "copies the operator", ->
			expect(result.operator).toEqual "test operator"
		it "copies left", ->
			expect(result.shape.left).toEqual 4
		it "copies top", ->
			expect(result.shape.top).toEqual 7
		it "copies width", ->
			expect(result.shape.width).toEqual 9
		it "copies height", ->
			expect(result.shape.height).toEqual 6									