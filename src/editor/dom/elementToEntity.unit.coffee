describe "elementToEntity", ->
	elementToEntity = undefined
	rewire = require "rewire"
	beforeEach -> 
		elementToEntity = rewire "./elementToEntity"
		
	describe "imports", ->
		it "elementToFalloff", -> expect(elementToEntity.__get__ "elementToFalloff").toBe require "./elementToFalloff"
		
	describe "for non-falloff entity", ->
		beforeEach ->
			elementToEntity.__set__ "elementToFalloff", -> fail "no falloff should be generated for this entity"
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
	describe "for falloff entity", ->
		element = undefined
		beforeEach ->
			elementToEntity.__set__ "elementToFalloff", (_element) ->
				expect(_element).toBe element
				"test falloff"
		describe "gravity", ->
			result = undefined
			beforeEach ->	
				element = 
					children: [
								tagName: "DIV"
								value: "-0.3"
							,
								tagName: "INPUT"
								value: "0.7"
							,
								tagName: "DIV"
								value: "0.2"
						]
					getAttribute: (name) ->
						switch name
							when "type" then "gravity"
							when "name" then "test name"
							else null
				result = elementToEntity element
	
			it "copies the type", ->
				expect(result.type).toEqual "gravity"
			it "copies the name", ->
				expect(result.name).toEqual "test name"
			it "copies the falloff", ->
				expect(result.value.falloff).toEqual "test falloff" 
			it "copies the intensity", ->
				expect(result.value.intensity).toEqual 0.7