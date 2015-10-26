describe "elementToFalloff", ->
	rewire = require "rewire"
	elementToFalloff = undefined
	beforeEach -> elementToFalloff = rewire "./elementToFalloff"
	
	describe "on calling", ->
		describe "ambient", ->
			result = undefined
			beforeEach ->
				result = elementToFalloff 
					style:
						left: "4rem"
						top: "17rem"
					children: [
								getAttribute: (name) -> switch name
									when "kind" then "fish"
									else null
								style:
									transform: "rotate(1.8rad)"
							,
								getAttribute: (name) -> null
								style:
									transform: "rotate(2.4rad)"
							,
								getAttribute: (name) -> switch name
									when "kind" then "fish"
									else null
								style:
									transform: "fish"
							,
								getAttribute: (name) -> null
								style:
									transform: "fish"
							,
								getAttribute: (name) -> switch name
									when "kind" then "angle"
									else null
								style:
									transform: "rotate(3.7rad)"
							,
								getAttribute: (name) -> switch name
									when "kind" then "fish"
									else null
								style:
									transform: "fish"
							,
								getAttribute: (name) -> null
								style:
									transform: "fish"
							,
								getAttribute: (name) -> switch name
									when "kind" then "fish"
									else null
								style:
									transform: "rotate(2.1rad)"
							,
								getAttribute: (name) -> null
								style:
									transform: "rotate(4.5rad)"
						]
			it "returns an object", ->
				expect(result).toEqual jasmine.any Object
			it "copies the origin", ->
				expect(result.origin.x).toEqual 4
				expect(result.origin.y).toEqual 17
			it "copies the angle", ->
				expect(result.angle).toEqual 3.7