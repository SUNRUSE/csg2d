describe "entityNameIsUnique", ->
	rewire = require "rewire"
	
	entityNameIsUnique = undefined
	beforeEach ->
		entityNameIsUnique = rewire "./entityNameIsUnique"
		
	describe "on calling", ->
		document = undefined
		
		beforeEach ->
			entityNameIsUnique.__set__ "document",
				getElementsByName: (name) -> switch name
					when "test name a" then [
								className: "anotherClass"
								getAttribute: (attr) -> switch attr
									when "type" then "test type a"
									else null
							,
								className: "entity"
								getAttribute: (attr) -> switch attr
									when "type" then "test type b"
									else null
							,
								className: "entity"
								getAttribute: (attr) -> switch attr
									when "type" then "test type c"
									else null
						]
					else []
			
		describe "when an element which is not an entity has a matching name and type", ->
			it "returns truthy", -> expect(entityNameIsUnique "test type a", "test name a").toBeTruthy()
				
		describe "when an element which is an entity has a matching name but not type", ->
			it "returns truthy", -> expect(entityNameIsUnique "test type e", "test name a").toBeTruthy()
			
		describe "when an element which is an entity has a matching type but not name", ->
			it "returns truthy", -> expect(entityNameIsUnique "test type c", "test name e").toBeTruthy()
			
		describe "when an element which is an entity has a matching type but the name does not match due to case", ->
			it "returns truthy", -> expect(entityNameIsUnique "test type b", "test nAMe a").toBeTruthy()
				
		describe "when an element which is an entity has a matching type and name", ->
			it "returns falsy", -> expect(entityNameIsUnique "test type b", "test name a").toBeFalsy()