describe "elementToEntity", ->
	elementToEntity = undefined
	rewire = require "rewire"
	beforeEach -> 
		elementToEntity = rewire "./elementToEntity"
	describe "player", ->
		result = undefined
		beforeEach ->	
			result = elementToEntity
				getAttribute: (name) ->
					switch name
						when "type" then "player"
						when "name" then "test name"
						when "facing" then "test facing"
						else null
				style:
					left: "4rem"
					top: "7rem"
		it "copies the type", ->
			expect(result.type).toEqual "player"
		it "copies the name", ->
			expect(result.name).toEqual "test name"
		it "copies the facing direction", ->
			expect(result.value.facing).toEqual "test facing"
		it "copies the origin", ->
			expect(result.value.origin.x).toEqual 4
			expect(result.value.origin.y).toEqual 7