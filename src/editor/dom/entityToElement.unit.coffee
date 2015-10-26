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
		it "falloffToElement", ->
			expect(entityToElement.__get__ "falloffToElement").toBe require "./falloffToElement"

	describe "on calling", ->
		falloffToElement = createHandle = element = valueChange = undefined
		beforeEach ->
			element = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
				
			document.createElement.and.callFake (type) -> element
			
			createHandle = jasmine.createSpy "createHandle"
			entityToElement.__set__ "createHandle", createHandle
			
			falloffToElement = jasmine.createSpy "falloffToElement"
			entityToElement.__set__ "falloffToElement", falloffToElement
		
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
			it "does not set the element up as a falloff", ->
				expect(falloffToElement).not.toHaveBeenCalled()
		describe "gravity", ->
			input = result = go = undefined
			beforeEach ->
				input = {}
				element.appendChild = jasmine.createSpy "appendChild"
				
				document.createElement.and.callFake (tagName) -> switch tagName
					when "div" then element
					when "input" then input
					else fail "unexpected tag name"
				
				go = ->
					result = entityToElement "gravity", "test name",
						falloff: "test falloff"
						intensity: 0.7
			
			it "creates exactly one div and one input", ->
				go()
				expect(document.createElement.calls.count()).toEqual 2
				expect(document.createElement).toHaveBeenCalledWith "div"
				expect(document.createElement).toHaveBeenCalledWith "input"
			it "returns the div", ->
				go()
				expect(result).toBe element
			it "appends the input to the div", ->
				go()
				expect(element.appendChild).toHaveBeenCalledWith input
			it "sets the input's \"type\" to \"range\"", ->
				go()
				expect(input.type).toEqual "range"
			it "sets the input's \"min\" to -1", ->
				go()
				expect(input.min).toEqual -1
			it "sets the input's \"max\" to 1", ->
				go()
				expect(input.max).toEqual 1
			it "sets the input's \"step\" to \"any\"", ->
				go()
				expect(input.step).toEqual "any"				
			it "sets the input's \"value\" to the intensity of the entity", ->
				go()
				expect(input.value).toEqual 0.7				
			it "copies the name to an attribute", ->
				go()
				expect(element.setAttribute).toHaveBeenCalledWith "name", "test name"
			it "sets the type attribute to \"gravity\"", ->
				go()
				expect(element.setAttribute).toHaveBeenCalledWith "type", "gravity"
			it "includes a delete handle", ->
				go()
				expect(createHandle).toHaveBeenCalledWith element, "delete"
			it "includes a clone handle", ->
				go()
				expect(createHandle).toHaveBeenCalledWith element, "clone"
			it "sets the class to \"entity\"", ->
				go()
				expect(element.className).toEqual "entity"
			it "sets the tabIndex to 0", ->
				go()
				expect(element.tabIndex).toEqual 0
			it "sets the element up as a falloff", ->
				go()
				expect(falloffToElement).toHaveBeenCalledWith "test falloff", element