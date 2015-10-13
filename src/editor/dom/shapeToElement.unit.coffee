describe "shapeToElement", ->
	shapeToElement = document = undefined
	rewire = require "rewire"
	beforeEach ->	
		shapeToElement = rewire "./shapeToElement"
		
		document =
			createElement: jasmine.createSpy "createElement"
			
		shapeToElement.__set__ "document", document
	
	describe "imports", ->
		it "document", ->
			expect(shapeToElement.__get__ "document").toBe document
		it "createHandle", ->
			expect(shapeToElement.__get__ "createHandle").toBe require "./createHandle"
	
	describe "on calling", ->
		createHandle = element = undefined
		beforeEach ->
			element = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
				
			document.createElement.and.callFake (type) -> element
			
			createHandle = jasmine.createSpy "createHandle"
			shapeToElement.__set__ "createHandle", createHandle
		
		describe "circle", ->
			result = undefined
			beforeEach ->
				result = shapeToElement
					operator: "test operator"
					shape:
						origin: 
							x: 8
							y: 15
						radius: 3
			
			it "creates exactly one div", ->
				expect(document.createElement.calls.count()).toEqual 1
				expect(document.createElement).toHaveBeenCalledWith "div"
			it "returns the div", ->
				expect(result).toBe element
			it "copies the operator to an attribute", ->
				expect(element.setAttribute).toHaveBeenCalledWith "operator", "test operator"
			it "sets the shape attribute to \"circle\"", ->
				expect(element.setAttribute).toHaveBeenCalledWith "shape", "circle"
			it "sets the width to double the radius in rem", ->
				expect(element.style.width).toEqual "6rem"
			it "sets the height to double the radius in rem", ->
				expect(element.style.height).toEqual "6rem"
			it "sets the left to location.x take radius in rem", ->
				expect(element.style.left).toEqual "5rem"
			it "sets the top to location.y take radius in rem", ->
				expect(element.style.top).toEqual "12rem"
			it "includes a move handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "move"
			it "includes a delete handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "delete"
			it "includes an operator handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "operator"
			it "includes a clone handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "clone"
			it "includes four radius handles", ->
				expect(createHandle).toHaveBeenCalledWith element, "radiusTop"
				expect(createHandle).toHaveBeenCalledWith element, "radiusBottom"
				expect(createHandle).toHaveBeenCalledWith element, "radiusLeft"
				expect(createHandle).toHaveBeenCalledWith element, "radiusRight"
			it "includes a pullForward handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "pullForward"
			it "includes a pushBack handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "pushBack"
			it "sets the class to \"shape\"", ->
				expect(element.className).toEqual "shape"
			it "sets the tabIndex to 0", ->
				expect(element.tabIndex).toEqual 0
			
		describe "rectangle", ->
			result = undefined
			beforeEach ->
				result = shapeToElement
					operator: "test operator"
					shape:
						left: 3,
						top: 8,
						height: 12,
						width: 10
			
			it "creates exactly one div", ->
				expect(document.createElement.calls.count()).toEqual 1
				expect(document.createElement).toHaveBeenCalledWith "div"
			it "returns the div", ->
				expect(result).toBe element
			it "copies the operator to an attribute", ->
				expect(element.setAttribute).toHaveBeenCalledWith "operator", "test operator"
			it "sets the shape attribute to \"rectangle\"", ->
				expect(element.setAttribute).toHaveBeenCalledWith "shape", "rectangle"
			it "copies the width", ->
				expect(element.style.width).toEqual "10rem"
			it "copies the height", ->
				expect(element.style.height).toEqual "12rem"
			it "copies the left", ->
				expect(element.style.left).toEqual "3rem"
			it "copies the top", ->
				expect(element.style.top).toEqual "8rem"
			it "includes a move handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "move"
			it "includes a left handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "left"
			it "includes a right handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "right"
			it "includes a top handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "top"
			it "includes a bottom handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "bottom"
			it "includes a delete handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "delete"
			it "includes an operator handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "operator"
			it "includes a clone handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "clone"
			it "includes a pullForward handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "pullForward"
			it "includes a pushBack handle", ->
				expect(createHandle).toHaveBeenCalledWith element, "pushBack"
			it "sets the class to \"shape\"", ->
				expect(element.className).toEqual "shape"
			it "sets the tabIndex to 0", ->
				expect(element.tabIndex).toEqual 0