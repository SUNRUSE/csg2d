describe "addGravity", ->
	rewire = require "rewire"
	
	addGravity = undefined
	beforeEach ->
		addGravity = rewire "./addGravity"
		
	describe "imports", ->
		it "getUniqueEntityNameByType", ->
			expect(addGravity.__get__ "getUniqueEntityNameByType").toBe require "./getUniqueEntityNameByType"
		it "addElement", ->
			expect(addGravity.__get__ "addElement").toBe require "./../addElement"
		it "pixelsPerRem", ->
			expect(addGravity.__get__ "pixelsPerRem").toBe require "./../../dom/pixelsPerRem"
		it "entityToElement", ->
			expect(addGravity.__get__ "entityToElement").toBe require "./../../dom/entityToElement"
			
	describe "on calling", ->
		addElement = entityToElement = getUniqueEntityNameByType = undefined
		beforeEach ->
			window = 
				innerWidth: 650
				innerHeight: 470
				pageXOffset: 2000
				pageYOffset: 3100
			addGravity.__set__ "window", window
			
			addElement = jasmine.createSpy "addElement"
			addGravity.__set__ "addElement", addElement
			
			addGravity.__set__ "pixelsPerRem", 7
			
			entityToElement = jasmine.createSpy "entityToElement"
			entityToElement.and.returnValue "test element"
			addGravity.__set__ "entityToElement", entityToElement
			
			getUniqueEntityNameByType = jasmine.createSpy "getUniqueEntityNameByType"
			getUniqueEntityNameByType.and.returnValue "test name"
			addGravity.__set__ "getUniqueEntityNameByType", getUniqueEntityNameByType
			
			addGravity()
			
		it "gets one name", ->
			expect(getUniqueEntityNameByType.calls.count()).toEqual 1
			expect(getUniqueEntityNameByType).toHaveBeenCalledWith "gravity"
			
		it "creates one element", ->
			expect(entityToElement.calls.count()).toEqual 1
			expect(entityToElement).toHaveBeenCalledWith "gravity", "test name", 
				falloff:
					angle: 1.57079632679489661923132169163975144209858469968755
					origin:
						x: 332
						y: 476
				intensity: 0.25
			
		it "adds the created element to the viewport", ->
			expect(addElement.calls.count()).toEqual 1
			expect(addElement).toHaveBeenCalledWith "test element", "entities"