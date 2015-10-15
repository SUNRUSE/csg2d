describe "getUniqueEntityNameByType", ->
	rewire = require "rewire"
	getUniqueEntityNameByType = undefined
	beforeEach ->
		getUniqueEntityNameByType = rewire "./getUniqueEntityNameByType"
	
	describe "imports", ->
		it "entityNameIsUnique", -> expect(getUniqueEntityNameByType.__get__ "entityNameIsUnique").toBe require "./entityNameIsUnique"
		
	describe "on calling", ->
		taken = undefined
		beforeEach ->
			taken = []
			
			getUniqueEntityNameByType.__set__ "entityNameIsUnique", (type, name) ->
				expect(type).toBe "test type"
				(taken.indexOf name) is -1 
				
		describe "when no entity names are taken", ->
			it "returns a non-empty string without padding whitespace", ->
				result = getUniqueEntityNameByType "test type"
				expect(result).toEqual jasmine.any String
				expect(result.trim()).toEqual result
				expect(result.length).toBeTruthy()
			describe "after one entity name is taken", ->
				beforeEach -> taken.push getUniqueEntityNameByType "test type"
				it "returns a distinct non-empty string without padding whitespace", ->
					result = getUniqueEntityNameByType "test type"
					expect(taken.indexOf result).toEqual -1
					expect(result).toEqual jasmine.any String
					expect(result.trim()).toEqual result
					expect(result.length).toBeTruthy()
				describe "after two entity names are taken", ->
					beforeEach -> taken.push getUniqueEntityNameByType "test type"
					it "returns a distinct non-empty string without padding whitespace", ->
						result = getUniqueEntityNameByType "test type"
						expect(taken.indexOf result).toEqual -1
						expect(result).toEqual jasmine.any String
						expect(result.trim()).toEqual result
						expect(result.length).toBeTruthy()