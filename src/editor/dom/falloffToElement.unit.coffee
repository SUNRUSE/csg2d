describe "falloffToElement", ->
	rewire = require "rewire"
	falloffToElement = undefined
	beforeEach -> falloffToElement = rewire "./falloffToElement"
	
	describe "imports", ->
		it "createHandle", -> expect(falloffToElement.__get__ "createHandle").toBe require "./createHandle"
	
	describe "on calling", ->
		angleHandle = createHandle = element = undefined
		beforeEach ->
			element = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
			
			createHandle = jasmine.createSpy "createHandle"
			angleHandle = 
				style: {}
			createHandle.and.callFake (element, kind) -> switch kind
				when "angle" then angleHandle
				else null 
			falloffToElement.__set__ "createHandle", createHandle
		describe "ambient", ->
			beforeEach ->
				falloff = 
					origin:
						x: 24
						y: 76
					angle: 5.4
				falloffToElement falloff, element
			it "sets the \"falloff\" attribute to \"ambient\"", ->
				expect(element.setAttribute).toHaveBeenCalledWith "falloff", "ambient"
			it "copies the x to style.left", ->
				expect(element.style.left).toEqual "24rem"
			it "copies the y to style.top", ->
				expect(element.style.top).toEqual "76rem"
			it "includes a move-middle handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "moveMiddle"
			it "includes an angle handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "angle"
			it "sets the rotation of the angle handle", ->
				expect(angleHandle.style.transform).toEqual "rotate(5.4rad)"