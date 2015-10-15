describe "addPlayer", ->
	rewire = require "rewire"
	
	addPlayer = undefined
	beforeEach ->
		addPlayer = rewire "./addPlayer"
		
	describe "imports", ->
		it "getUniqueEntityNameByType", ->
			expect(addPlayer.__get__ "getUniqueEntityNameByType").toBe require "./getUniqueEntityNameByType"
		it "addElement", ->
			expect(addPlayer.__get__ "addElement").toBe require "./../addElement"
		it "pixelsPerRem", ->
			expect(addPlayer.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		it "entityToElement", ->
			expect(addPlayer.__get__ "entityToElement").toBe require "./../../dom/entityToElement"
			
	describe "on calling", ->
		addElement = entityToElement = getUniqueEntityNameByType = undefined
		beforeEach ->
			window = 
				innerWidth: 650
				innerHeight: 470
				pageXOffset: 2000
				pageYOffset: 3100
			addPlayer.__set__ "window", window
			
			addElement = jasmine.createSpy "addElement"
			addPlayer.__set__ "addElement", addElement
			
			addPlayer.__set__ "pixelsPerRem", 7
			
			entityToElement = jasmine.createSpy "entityToElement"
			entityToElement.and.returnValue "test element"
			addPlayer.__set__ "entityToElement", entityToElement
			
			getUniqueEntityNameByType = jasmine.createSpy "getUniqueEntityNameByType"
			getUniqueEntityNameByType.and.returnValue "test name"
			addPlayer.__set__ "getUniqueEntityNameByType", getUniqueEntityNameByType
			
			addPlayer()
			
		it "gets one name", ->
			expect(getUniqueEntityNameByType.calls.count()).toEqual 1
			expect(getUniqueEntityNameByType).toHaveBeenCalledWith "player"
			
		it "creates one element", ->
			expect(entityToElement.calls.count()).toEqual 1
			expect(entityToElement).toHaveBeenCalledWith "player", "test name", 
				origin:
					x: 332
					y: 476
				facing: "right"
			
		it "adds the created element to the viewport", ->
			expect(addElement.calls.count()).toEqual 1
			expect(addElement).toHaveBeenCalledWith "test element", "entities"