describe "entityToElement", ->
	entityToElement = document = undefined
	rewire = require "rewire"
	beforeEach ->	
		entityToElement = rewire "./entityToElement"
		
		document =
			createElement: jasmine.createSpy "createElement"
			
		entityToElement.__set__ "document", document
	
	describe "imports", ->
		it "document", ->
			expect(entityToElement.__get__ "document").toBe document
		it "createHandle", ->
			expect(entityToElement.__get__ "createHandle").toBe require "./createHandle"
	
	describe "on calling", ->
		createHandle = element = undefined
		beforeEach ->
			element = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
				
			document.createElement.and.callFake (type) -> element
			
			createHandle = jasmine.createSpy "createHandle"
			entityToElement.__set__ "createHandle", createHandle
		
		describe "player", ->
			result = undefined
			beforeEach ->
				result = entityToElement "player", "test name",
					origin: 
						x: 5
						y: 16
					facing: "test facing"
			
			it "creates exactly one div", ->
				expect(document.createElement.calls.count()).toEqual 1
				expect(document.createElement).toHaveBeenCalledWith "div"
			it "returns the div", ->
				expect(result).toBe element
			it "copies the name to an attribute", ->
				expect(element.setAttribute).toHaveBeenCalledWith "name", "test name"
			it "sets the type attribute to \"player\"", ->
				expect(element.setAttribute).toHaveBeenCalledWith "type", "player"
			it "sets the left to origin.x in rem", ->
				expect(element.style.left).toEqual "5rem"
			it "sets the top to origin.y in rem", ->
				expect(element.style.top).toEqual "16rem"
			it "copies the facing direction to an attribute", ->
				expect(element.setAttribute).toHaveBeenCalledWith "facing", "test facing"
			it "includes a move-from-middle handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "moveMiddle"
			it "includes a delete handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "delete"
			it "includes a clone handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "clone"
			it "sets the class to \"entity\"", ->
				expect(element.className).toEqual "entity"
			it "sets the tabIndex to 0", ->
				expect(element.tabIndex).toEqual 0