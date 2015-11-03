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
		it "does not set ramp", ->
			expect(result.shape.ramp).toBeUndefined()	
			
	describe "rectangle", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "rectangle"
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
		it "does not set ramp", ->
			expect(result.shape.ramp).toBeUndefined()							
			
	describe "ramp (top left)", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "ramp"
						when "operator" then "test operator"
						when "position" then "topLeft"
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
		it "sets ramp to \"topLeft\"", ->
			expect(result.shape.ramp).toEqual "topLeft"
			
	describe "ramp (top right)", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "ramp"
						when "operator" then "test operator"
						when "position" then "topRight"
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
		it "sets ramp to \"topRight\"", ->
			expect(result.shape.ramp).toEqual "topRight"
			
	describe "ramp (bottom left)", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "ramp"
						when "operator" then "test operator"
						when "position" then "bottomLeft"
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
		it "sets ramp to \"bottomLeft\"", ->
			expect(result.shape.ramp).toEqual "bottomLeft"
			
	describe "ramp (bottom right)", ->
		result = undefined
		beforeEach ->	
			result = elementToShape
				getAttribute: (name) ->
					switch name
						when "shape" then "ramp"
						when "operator" then "test operator"
						when "position" then "bottomRight"
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
		it "sets ramp to \"bottomRight\"", ->
			expect(result.shape.ramp).toEqual "bottomRight"